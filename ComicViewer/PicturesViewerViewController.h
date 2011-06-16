//
//  PicturesViewerViewController.h
//  ComicViewer
//
//  Created by Penn Su on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "MyScrollView.h"
#import "Segmentation.h"
#import "panelcut.h"


typedef enum {
	ViewerModePageView,
	ViewerModePanelView
} ViewerMode;

typedef enum {
    scrollViewIndex,
    panelRectsIndex
} indexPair;

@interface PicturesViewerViewController : UIViewController <UINavigationControllerDelegate> {
    // datasource
    NSMutableArray* pictures;
    NSMutableArray* panels;
    
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

- (void)positionUI;
//- (MyScrollView*)loadPanel:(MyScrollView*)scrollView withPanelRect:(CGRect)panelInfo;
- (MyScrollView*)loadPanel:(CGImageRef)cgimage withPanelRect:(CGRect)panelInfo;
- (MyScrollView*)loadPanelView:(MyScrollView*)scrollView withPanelIndex:(int)panelIndex ofPageIndex:(int)pageIndex;

@end
