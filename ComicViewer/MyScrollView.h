//
//  MyScrollView.h
//  ViewTest
//
//  Created by JLiu on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyScrollView : UIScrollView <UIScrollViewDelegate> {
	UIImageView* imageView;
}

@property (nonatomic, retain) UIImageView* imageView;

- (void)handleRotate;

@end
