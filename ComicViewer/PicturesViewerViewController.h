//
//  PicturesViewerViewController.h
//  ComicViewer
//
//  Created by Penn Su on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "MyScrollView.h"


typedef enum {
	ViewerModePageView,
	ViewerModePanelView
} ViewerMode;

typedef enum {
    scrollViewIndex,
    panelRectsIndex
} getPair;

@interface PicturesViewerViewController : UIViewController {
    // datasource
    NSMutableArray* pictures;
    
    // gesture recognizers
    UIPanGestureRecognizer* panGesture;
    UISwipeGestureRecognizer* swipeLeftGesture;
    UISwipeGestureRecognizer* swipeRightGesture;
    UIRotationGestureRecognizer* rotateGesture;
    UITapGestureRecognizer* doubleTapGesture;
    
    // UI
    MyScrollView* previousImage;
    MyScrollView* currentImage;
    MyScrollView* nextImage;
    
    // Index
    int currentPageIndex;
    int currentPanelIndex;
    
    // Mode switching flag
    BOOL comingFromDifferentMode;

	// State Variable
	ViewerMode viewerMode;
}

@end
