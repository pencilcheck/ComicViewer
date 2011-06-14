//
//  ComicViewerViewController.m
//  ComicViewer
//
//  Created by Penn Su on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ComicViewerViewController.h"
#import "PicturesViewerViewController.h"

@implementation ComicViewerViewController

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

#pragma mark - TableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"comic"];

    if (cell == nil) 
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"comic"];
    
    cell.textLabel.text = @"Link's Logbook, The Legend of Zelda The Wind Waker";
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Part%d", indexPath.row+1];
    
    cell.imageView.image = [[comics objectAtIndex:[indexPath row]] image];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [comics count];
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create a new PicturesViewController and push it
    
    //TODO: need to pass the index of the comic or the array
	
	NSLog(@"TableView Width: %g, Height: %g", self.tableView.frame.size.width, self.tableView.frame.size.height);
    picturesViewer = [[PicturesViewerViewController alloc] initWithFrame:self.tableView.frame];
    
    // Initialize Toolbars
    [self.navigationController.toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [self.navigationController setToolbarHidden:NO animated:NO];
    [self.navigationController setDelegate:picturesViewer];
    
    [self.navigationController pushViewController:picturesViewer animated:YES];
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure tableview parameters
    self.tableView.rowHeight = 100;
    self.tableView.backgroundColor = [UIColor clearColor];

    NSArray* array = [[NSArray alloc] initWithObjects:
                      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.png"]], 
                      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2.png"]], 
                      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.png"]], nil];
    comics = [[NSMutableArray alloc] initWithArray:array];
    
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

@end
