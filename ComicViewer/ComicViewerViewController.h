//
//  ComicViewerViewController.h
//  ComicViewer
//
//  Created by Penn Su on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PicturesViewerViewController;

@interface ComicViewerViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray* comics;
    PicturesViewerViewController* picturesViewer;
}

@end
