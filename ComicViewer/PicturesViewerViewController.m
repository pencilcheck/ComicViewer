//
//  PicturesViewerViewController.m
//  ComicViewer
//
//  Created by Penn Su on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PicturesViewerViewController.h"
#import "Segmentation.h"
#import "panelcut.h"

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
    pictures = [[NSMutableArray alloc] init];    
    panels = [[NSMutableArray alloc] init];
    
    //cutter
    //Segmentation* cutter;
	
    for (int i = 0; i < 10; ++i) {
        NSLog(@"loading %d comic", i);
        MyScrollView* scrollView = [[MyScrollView alloc] initWithFrame:self.view.frame withImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i+1]]];
        [scrollView setContentMode:UIViewContentModeScaleAspectFit];
        [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        
        panelcut* cutter = [[panelcut alloc] init];
        [cutter panel:[[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i+1]] CGImage]];
        [cutter release];
        
        NSMutableArray* panelRects = [cutter.corners retain];
        
        NSMutableArray* panelViews = [[NSMutableArray alloc] init];
        
        for (int j = 0; j < [panelRects count]; ++j) {
            [panelViews addObject:[self loadPanel:scrollView.imageView.image.CGImage withPanelRect:[[panelRects objectAtIndex:j] CGRectValue]]];
        }
        
        [pictures addObject:[NSArray arrayWithObjects:scrollView, panelViews, nil]];
        [panels addObject:panelRects];
        [scrollView release];
        [panelViews release];
        [panelRects release];
    }
    
    
    // gesture recognizers
    UIPanGestureRecognizer* panGesture;
    UISwipeGestureRecognizer* swipeLeftGesture;
    UISwipeGestureRecognizer* swipeRightGesture;
    UITapGestureRecognizer* doubleTapGesture;
    UITapGestureRecognizer* tapGesture;
    
    // init gestures
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPicture:)];
    
    swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePicture:)];
    [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipePicture:)];
    [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    
    doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleMode:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleToolbars:)];
    tapGesture.numberOfTapsRequired = 1;
    [tapGesture requireGestureRecognizerToFail: doubleTapGesture];
    
    //tapGestureRecognizer.delegate = self;
    
    // attach gestures
    //[self.view addGestureRecognizer:panGesture];
    [self.view addGestureRecognizer:swipeLeftGesture];
    [self.view addGestureRecognizer:swipeRightGesture];
    [self.view addGestureRecognizer:doubleTapGesture];
    [self.view addGestureRecognizer:tapGesture];
    
    // release gestures
    [panGesture release];
    [swipeLeftGesture release];
    [swipeRightGesture release];
    [doubleTapGesture release];
    [tapGesture release];
    
    // Initialize parameters
	viewerMode = ViewerModePageView;
    currentPageIndex = 0;
	
    previousImage = NULL;
    currentImage = NULL;
    nextImage = NULL;
    
    // Init pictures
    if ( [pictures count] > 1 ) {
        currentImage = [[pictures objectAtIndex:currentPageIndex] objectAtIndex:0];
        nextImage = [[pictures objectAtIndex:currentPageIndex+1] objectAtIndex:0];
        [self positionUI];
    }
	
    return self;
}

- (void)dealloc
{
    [pictures release];
    [panels release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (MyScrollView*)loadPanelView:(MyScrollView*)scrollView withPanelIndex:(int)panelIndex ofPageIndex:(int)pageIndex
{
    [scrollView removeFromSuperview];
    scrollView = [[[pictures objectAtIndex:pageIndex] objectAtIndex:panelRectsIndex] objectAtIndex:panelIndex];
    return scrollView;
}

//- (MyScrollView*)loadPanel:(MyScrollView*)scrollView withPanelRect:(CGRect)panelInfo
- (MyScrollView*)loadPanel:(CGImageRef)cgimage withPanelRect:(CGRect)panelInfo
{    
    //[scrollView removeFromSuperview];
    UIImage* img = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(cgimage, panelInfo)];
    MyScrollView* newPanel = [[MyScrollView alloc] initWithFrame:self.view.frame withImage:img];

    return newPanel;
}

- (void)loadImage
{
	if (viewerMode == ViewerModePageView) {
        if (comingFromDifferentMode) {

            int previousIndex = currentPageIndex-1;
            if (previousIndex >= 0) {
                [previousImage removeFromSuperview];
                previousImage = [[pictures objectAtIndex:previousIndex] objectAtIndex:scrollViewIndex];
            }

            int currentIndex = currentPageIndex;
            if (currentIndex >= 0 && currentIndex < [pictures count]) {
                [currentImage removeFromSuperview];
                currentImage = [[pictures objectAtIndex:currentIndex] objectAtIndex:scrollViewIndex];
            }

            int nextIndex = currentPageIndex+1;
            if (nextIndex < [pictures count]) {
                [nextImage removeFromSuperview];
                nextImage = [[pictures objectAtIndex:nextIndex] objectAtIndex:scrollViewIndex];
            }

            
            comingFromDifferentMode = false;
        }
        else {
            if (previousImage == NULL) {
                int previousIndex = currentPageIndex-1;
                if (previousIndex >= 0) {
                    [previousImage removeFromSuperview];                    
                    previousImage = [[pictures objectAtIndex:previousIndex] objectAtIndex:0];
                }
            }
            
            if (nextImage == NULL) {
                int nextIndex = currentPageIndex+1;
                if (nextIndex < [pictures count]) {
                    [nextImage removeFromSuperview];
                    nextImage = [[pictures objectAtIndex:nextIndex] objectAtIndex:0];
                    
                }
            }
        }
    }
	else if (viewerMode == ViewerModePanelView) {
        NSLog(@"in PanelView");

        NSLog(@"Loading Previous Image");
        int previousIndex = currentPanelIndex-1;
        if (previousIndex >= 0) {
            //previousImage = [self loadPanel:[[pictures objectAtIndex:currentPageIndex] objectAtIndex:scrollViewIndex] withPanelRect:[[[[pictures objectAtIndex:currentPageIndex] objectAtIndex:panelRectsIndex] objectAtIndex:previousIndex] CGRectValue]];
            previousImage = [self loadPanelView:previousImage withPanelIndex:previousIndex ofPageIndex:currentPageIndex];
        }
        else {
            // Previous page
            if (currentPageIndex > 0) {
                //previousImage = [self loadPanel:[[pictures objectAtIndex:currentPageIndex-1] objectAtIndex:scrollViewIndex] withPanelRect:[[[[pictures objectAtIndex:currentPageIndex] objectAtIndex:panelRectsIndex] objectAtIndex:[[[pictures objectAtIndex:currentPageIndex] objectAtIndex:panelRectsIndex] count]-1] CGRectValue]];
                previousImage = [self loadPanelView:previousImage withPanelIndex:[[[pictures objectAtIndex:currentPageIndex] objectAtIndex:panelRectsIndex] count]-1 ofPageIndex:currentPageIndex];
            }
        }
        NSLog(@"Finish Loading Previous Image");

        NSLog(@"Loading Current Image");
        if (comingFromDifferentMode) {
            int currentIndex = currentPanelIndex;
            if (currentIndex >= 0 && currentIndex < [[[pictures objectAtIndex:currentPageIndex] objectAtIndex:panelRectsIndex] count]) {
                //currentImage = [self loadPanel:[[pictures objectAtIndex:currentPageIndex] objectAtIndex:scrollViewIndex] withPanelRect:[[[[pictures objectAtIndex:currentPageIndex] objectAtIndex:panelRectsIndex] objectAtIndex:currentIndex] CGRectValue]];                    
                currentImage = [self loadPanelView:currentImage withPanelIndex:currentPanelIndex ofPageIndex:currentPageIndex];
            }
            
            comingFromDifferentMode = false;
        }    
        NSLog(@"Finish Loading Current Image");

        NSLog(@"Loading Next Image");
        int nextIndex = currentPanelIndex+1;
        if (nextIndex < [[[pictures objectAtIndex:currentPageIndex] objectAtIndex:panelRectsIndex] count]) {
            //nextImage = [self loadPanel:[[pictures objectAtIndex:currentPageIndex] objectAtIndex:scrollViewIndex] withPanelRect:[[[[pictures objectAtIndex:currentPageIndex] objectAtIndex:panelRectsIndex] objectAtIndex:nextIndex] CGRectValue]];                    
            nextImage = [self loadPanelView:nextImage withPanelIndex:nextIndex ofPageIndex:currentPageIndex];
        }
        else {
            // Next page
            if (currentPageIndex < [pictures count]-1) {
                //nextImage = [self loadPanel:[[pictures objectAtIndex:currentPageIndex+1] objectAtIndex:scrollViewIndex] withPanelRect:[[[[pictures objectAtIndex:currentPageIndex] objectAtIndex:panelRectsIndex] objectAtIndex:0] CGRectValue]];         
                nextImage = [self loadPanelView:nextImage withPanelIndex:0 ofPageIndex:currentPageIndex+1];
            }
        }
        NSLog(@"Finish Loading Next Image");
    }
    
    [self positionUI];
}

#pragma mark - Gesture handler

- (void)toggleToolbars:(UITapGestureRecognizer*)sender
{
	//CGPoint tapPointInImage = [sender locationInView:currentImage.imageView];
	//NSLog (@"X: %g  Y: %g", tapPointInImage.x, tapPointInImage.y);

    // Hide bars
    if (![[self.navigationController navigationBar] isHidden])
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    else
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (self.navigationController.toolbarHidden)
        [self.navigationController setToolbarHidden:NO animated:YES];
    else
        [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self positionUI];

}

- (void)toggleMode:(UITapGestureRecognizer *)sender
{
    NSLog(@"ToggleMode");
	if (viewerMode == ViewerModePageView) {
		CGPoint tapPointInImage = [sender locationInView:currentImage.imageView];
        //for (NSValue* rectValue in [[pictures objectAtIndex:currentPageIndex] objectAtIndex:panelRectsIndex]) {
        for (int i = 0; i < [[panels objectAtIndex:currentPageIndex] count]; ++i) {
        //for (NSValue* rectValue in [panels objectAtIndex:currentPageIndex]) {
            CGRect rect = [[[panels objectAtIndex:currentPageIndex] objectAtIndex:i] CGRectValue];
            //if (CGRectContainsPoint([rectValue CGRectValue], tapPointInImage)) {
            if (CGRectContainsPoint(rect, tapPointInImage)) {
                viewerMode = ViewerModePanelView;
                comingFromDifferentMode = true;
				//currentPanelIndex = [[panels objectAtIndex:currentPageIndex] indexOfObject:rectValue];
                currentPanelIndex = i;
				[previousImage removeFromSuperview];
				[nextImage removeFromSuperview];
				previousImage = nil;
				nextImage = nil;
                
                NSLog(@"Loading Image");
                [self loadImage];
                NSLog(@"Finish Loading Image");
            }
        }
	}
	else if (viewerMode == ViewerModePanelView) {
		viewerMode = ViewerModePageView;
        comingFromDifferentMode = true;

        [self loadImage];
	}
    NSLog(@"Finish ToggleMode");
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
        // swipe right, pictures move right
        
        if (previousImage == NULL) {
            return;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
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
        
        if (viewerMode == ViewerModePageView)
            currentPageIndex--;
        else if (viewerMode == ViewerModePanelView) {
            currentPanelIndex--;
            if (currentPanelIndex < 0) {
                currentPageIndex--;
                currentPanelIndex = [[[pictures objectAtIndex:currentPageIndex] objectAtIndex:panelRectsIndex] count]-1;
            }
        }
    }
    else {        
        // swipe left, pictures move left

        if (nextImage == NULL) {
            return;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
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
        
        if (viewerMode == ViewerModePageView)
            currentPageIndex++;
        else if (viewerMode == ViewerModePanelView) {
            currentPanelIndex++;
            if (currentPanelIndex > [[[pictures objectAtIndex:currentPageIndex] objectAtIndex:panelRectsIndex] count]-1) {
                currentPageIndex++;
                currentPanelIndex = 0;
            }
        }
    }

}

#pragma mark - View lifecycle

- (void)positionUI
{
    // initialize the background of the view to the background of the image
    NSLog(@"Configuring Previous Image");
    if ( previousImage != NULL ) {
        // configure the parameters
        /*[previousImage setContentMode:UIViewContentModeScaleAspectFit];
        [previousImage setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];*/
        
        // resize to fit the screen
        [previousImage setFrame:CGRectMake(-[self.view frame].size.width, 0, [self.view frame].size.width, [self.view frame].size.height)];
        
        if ([previousImage superview] == NULL)
            [self.view addSubview:previousImage];
    }
    NSLog(@"Finish Configuring Previous Image");
    NSLog(@"Configuring Current Image");
    if ( currentImage != NULL ) {
        // configure the parameters
        /*[currentImage setContentMode:UIViewContentModeScaleAspectFit];
        [currentImage setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];*/
        
        // resize to fit the screen
        [currentImage setFrame:self.view.frame];

        if ([currentImage superview] == NULL)
            [self.view addSubview:currentImage];
    }
    NSLog(@"Finish Configuring Current Image");
    NSLog(@"Configuring Next Image");
    if ( nextImage != NULL ) {
        // configure the parameters
        /*[nextImage setContentMode:UIViewContentModeScaleAspectFit];
        [nextImage setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];*/
        
        // resize to fit the screen
        [nextImage setFrame:CGRectMake([self.view frame].size.width, 0, [self.view frame].size.width, [self.view frame].size.height)];

        if ([nextImage superview] == NULL)
            [self.view addSubview:nextImage];
    }
    NSLog(@"Finish Configuring Next Image");
    NSLog(@"HandleRotate");
	[previousImage handleRotate:NO];
	[currentImage handleRotate:NO];
	[nextImage handleRotate:NO];
    NSLog(@"Finish HandleRotate");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)viewDidUnload
{
    pictures = nil;
    panels = nil;
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
	[self positionUI];
	[previousImage handleRotate:YES];
	[currentImage handleRotate:YES];
	[nextImage handleRotate:YES];
}

#pragma mark - NavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController != self) {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

@end
