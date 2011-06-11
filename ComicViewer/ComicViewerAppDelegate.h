//
//  ComicViewerAppDelegate.h
//  ComicViewer
//
//  Created by Penn Su on 5/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComicViewerViewController;
@class PicturesViewerViewController;

@interface ComicViewerAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

//@property (nonatomic, retain) IBOutlet ComicViewerViewController *viewController;
@property (nonatomic, retain) IBOutlet PicturesViewerViewController *viewController;

@end
