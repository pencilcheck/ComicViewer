//
//  ComicViewerViewController.h
//  ComicViewer
//
//  Created by Penn Su on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AQGridView.h"

@class PicturesViewerViewController;

@interface ComicViewerViewController : UIViewController <AQGridViewDelegate, AQGridViewDataSource> {
    NSMutableArray* comics;
    
    PicturesViewerViewController* picturesViewer;
    
    AQGridView *gridView;
    UIActivityIndicatorView *loadingView;
}

@property (nonatomic, retain) IBOutlet AQGridView *gridView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingView;

- (void) loadPictureViewer;
- (void) startSpinner;
- (void) removeSpinner;

@end
