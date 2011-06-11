//
//  PicturesViewerViewController.m
//  ComicViewer
//
//  Created by Penn Su on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PicturesViewerViewController.h"


@implementation PicturesViewerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super init];
	self.view.frame = frame;
	
	// datasource
    
    NSArray* array = [[NSArray alloc] initWithObjects:
                      [[MyScrollView alloc] initWithFrame:self.view.frame withImage:[UIImage imageNamed:@"1.jpg"]], 
                      [[MyScrollView alloc] initWithFrame:self.view.frame withImage:[UIImage imageNamed:@"2.jpg"]], 
                      [[MyScrollView alloc] initWithFrame:self.view.frame withImage:[UIImage imageNamed:@"3.jpg"]], nil];
    pictures = [[NSMutableArray alloc] initWithArray:array];
    
    // init gestures
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPicture:)];
    swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePicture:)];
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePicture:)];
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMode:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    
    // attach gestures
    //[self.view addGestureRecognizer:panGesture];
    [self.view addGestureRecognizer:swipeLeftGesture];
    [self.view addGestureRecognizer:swipeRightGesture];
    [self.view addGestureRecognizer:doubleTapGesture];
    
    // release gestures
    [panGesture release];
    [swipeLeftGesture release];
    [swipeRightGesture release];
    [doubleTapGesture release];
    
	viewerMode = ViewerModePageView;
    // init pictures
    if ( [pictures count] > 0 ) {
        previousImage = NULL;
        currentImage = [pictures objectAtIndex:0];
        nextImage = [pictures objectAtIndex:1];
        [self setupUI];
    }
	
	
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)loadImage
{
   
    if (previousImage == NULL) {
        int previousIndex = [pictures indexOfObject:currentImage]-1;
        if (previousIndex >= 0) {
            previousImage = [pictures objectAtIndex:previousIndex];
        }
    }
    if (nextImage == NULL) {
        int nextIndex = [pictures indexOfObject:currentImage]+1;
        if (nextIndex < [pictures count]) {
            nextImage = [pictures objectAtIndex:nextIndex];

        }
    }
    
    [self setupUI];
}

#pragma mark - Gesture handler

- (void)toggleMode:(UITapGestureRecognizer *)sender
{
	static MyScrollView *tempMyScrollView = nil;
	CGRect firstPanel = CGRectMake(23, 116, 485, 269);

	if (viewerMode == ViewerModePageView) {
		CGPoint tapPointInImage = [sender locationInView:currentImage.imageView];
		if (CGRectContainsPoint(firstPanel, tapPointInImage)) {
			viewerMode = ViewerModePanelView;
			tempMyScrollView = currentImage;
			CGImageRef ref = CGImageCreateWithImageInRect(currentImage.imageView.image.CGImage, firstPanel);
			UIImage *image = [UIImage imageWithCGImage:ref];
			NSLog (@"iW: %g  iH: %g", image.size.width, image.size.height);
			[currentImage removeFromSuperview];
			currentImage = [[MyScrollView alloc] initWithFrame:self.view.frame withImage:image];
			[self setupUI];
		}
	}
	else if (viewerMode == ViewerModePanelView) {
		viewerMode = ViewerModePageView;
		[currentImage removeFromSuperview];
		currentImage = tempMyScrollView;
		[self setupUI];
	}
}

- (void)panPicture:(UIPanGestureRecognizer *)sender
{
    CGPoint translate = [sender translationInView:self.view];
    CGRect newFrame = [currentImage frame];
    
    newFrame.origin.x += translate.x;
    sender.view.frame = newFrame;
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        newFrame.origin.x -= translate.x;
        [currentImage setFrame:newFrame];
        return;
    }   
}

- (void)swipePicture:(UISwipeGestureRecognizer *)sender
{
    [self loadImage];
	
    if ([sender direction] == 1) {
        // swipe right
        
        if (previousImage == NULL) {
            return;
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint center = currentImage.center;
            center.x += self.view.frame.size.width;
            currentImage.center = center;
            
            center = previousImage.center;
            center.x += self.view.frame.size.width;
            previousImage.center = center;            
        } completion:^(BOOL finished){
            [nextImage removeFromSuperview];
            nextImage = currentImage;
            currentImage = previousImage;
            previousImage = NULL;
			
        }];
    }
    else {        
        // swipe left

        if (nextImage == NULL) {
            return;
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint center = currentImage.center;
            center.x -= self.view.frame.size.width;
            currentImage.center = center;

            center = nextImage.center;
            center.x -= self.view.frame.size.width;
            nextImage.center = center;
        } completion:^(BOOL finished){
            [previousImage removeFromSuperview];
            previousImage = currentImage;
            currentImage = nextImage;
            nextImage = NULL;
        }];
    }

}

#pragma mark - View lifecycle

- (void)setupUI
{
    // initialize the background of the view to the background of the image

    if ( previousImage != NULL ) {
        // configure the parameters
        [previousImage setContentMode:UIViewContentModeScaleAspectFit];
        [previousImage setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
        // resize to fit the screen
        [previousImage setFrame:CGRectMake(-[self.view frame].size.width, 0, [self.view frame].size.width, [self.view frame].size.height)];
        
        if ([previousImage superview] == NULL)
            [self.view addSubview:previousImage];
    }
    
    if ( currentImage != NULL ) {
        // configure the parameters
        [currentImage setContentMode:UIViewContentModeScaleAspectFit];
        [currentImage setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
        // resize to fit the screen
        [currentImage setFrame:self.view.frame];

        if ([currentImage superview] == NULL)
            [self.view addSubview:currentImage];
    }
    
    if ( nextImage != NULL ) {
        // configure the parameters
        [nextImage setContentMode:UIViewContentModeScaleAspectFit];
        [nextImage setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
        // resize to fit the screen
        [nextImage setFrame:CGRectMake([self.view frame].size.width, 0, [self.view frame].size.width, [self.view frame].size.height)];

        if ([nextImage superview] == NULL)
            [self.view addSubview:nextImage];
    }

	[previousImage handleRotate:NO];
	[currentImage handleRotate:NO];
	[nextImage handleRotate:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self setupUI];
	[previousImage handleRotate:YES];
	[currentImage handleRotate:YES];
	[nextImage handleRotate:YES];
}

@end
