//
//  ComicViewerViewController.m
//  ComicViewer
//
//  Created by Penn Su on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AQGridView.h"
#import "ComicViewerViewController.h"
#import "PicturesViewerViewController.h"
#import "ComicCoverCell.h"

@implementation ComicViewerViewController

@synthesize gridView;
@synthesize loadingView;

- (void)dealloc
{
    [comics release];
    [gridView release];
    [loadingView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - GridView Delegate

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView;
{
	return [comics count];
}

- (AQGridViewCell *) gridView: (AQGridView *)inGridView cellForItemAtIndex: (NSUInteger) index;
{
	ComicCoverCell *cell = nil;
    cell = (ComicCoverCell *)[inGridView dequeueReusableCellWithIdentifier:@"cell"];
    NSLog(@"check if cell is null");
	if (!cell) {
        NSLog(@"cell is null");
		cell = [[ComicCoverCell alloc] initWithFrame:CGRectMake(0, 0, 100, 134) imageFrame:CGRectMake(6, 5, 78, 110) overlayFrame:CGRectMake(0, 0, 90, 124) title:@"" reuseIdentifier:@"cell"];
	}
    NSLog(@"finish check if cell is null");
    
	cell.selectionStyle = AQGridViewCellSelectionStyleGlow;
    
    NSLog(@"index: %d", index);
    [cell setImage:[comics objectAtIndex:index]];
	
	return cell;
}

#pragma mark - GridView Delegate

- (void) removeSpinner
{
    [loadingView stopAnimating];
}

- (void) loadPictureViewer
{
    picturesViewer = [[PicturesViewerViewController alloc] initWithFrame:self.view.frame];
    
    // Initialize Toolbars
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController setToolbarHidden:NO animated:NO];
    [self.navigationController setDelegate:picturesViewer];
    
    [self performSelectorOnMainThread:@selector(removeSpinner) withObject:nil waitUntilDone:NO];
    
    [self.navigationController pushViewController:picturesViewer animated:YES];
    [picturesViewer release];
}

- (void) gridView: (AQGridView *) gridView didSelectItemAtIndex: (NSUInteger) index;
{
    // Create a new PicturesViewController and push it
    
    //TODO: need to pass the index of the comic or the array
	
	NSLog(@"TableView Width: %g, Height: %g", self.view.frame.size.width, self.view.frame.size.height);
    
    // Turn on Activity Indicator View
    [loadingView startAnimating];

    [self performSelectorInBackground:@selector(loadPictureViewer) withObject:nil];
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView;
{
	return CGSizeMake(100, 150);
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated;
{
    NSLog(@"viewWillAppear");
	[gridView reloadData];
	
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated;
{
    NSLog(@"viewDidAppear");
	[self.gridView deselectItemAtIndex: [self.gridView indexOfSelectedItem] animated: YES];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure tableview parameters
    /*
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = [UIColor clearColor];
    */ 
    
    gridView.leftContentInset = 0.f;
	gridView.rightContentInset = 0.f;
    

    /*NSArray* array = [[NSArray alloc] initWithObjects:
                      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]], 
                      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.png"]], 
                      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.png"]], nil];
    comics = [[NSMutableArray alloc] initWithArray:array];*/
    
    NSLog(@"init comics");
    comics = [[NSMutableArray alloc] initWithObjects:
                      [UIImage imageNamed:@"cover1.png"], 
                      [UIImage imageNamed:@"cover2.png"], 
                      [UIImage imageNamed:@"cover3.png"], nil];
    
    NSLog(@"set title to MangaFlow");
	[self setTitle:@"MangaFlow"];
    
}


- (void)viewDidUnload
{
    [self setGridView:nil];
    [self setLoadingView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
