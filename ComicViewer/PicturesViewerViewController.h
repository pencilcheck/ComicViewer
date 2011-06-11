//
//  PicturesViewerViewController.h
//  ComicViewer
//
//  Created by Penn Su on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


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
    UIImageView* previousImage;
    UIImageView* currentImage;
    UIImageView* nextImage;
}

@end
