//
//  MyScrollView.m
//  ViewTest
//
//  Created by JLiu on 6/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyScrollView.h"


@implementation MyScrollView


@synthesize imageView;


//CGRectMake(0, 0, [self.view bounds].size.width, [self.view bounds].size.height)
- (id)initWithFrame:(CGRect)frame withImage:(UIImage *)image {
    
    self = [super initWithFrame:frame];
    if (self) {
		imageView = [[UIImageView alloc] initWithImage:image];
		[self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
		[self setContentSize:imageView.image.size];
		self.delegate = self;
		[self addSubview:imageView];
		
		self.minimumZoomScale = 0.1;
		self.maximumZoomScale = 10.0;
		CGFloat fitWidthScale =  (self.frame.size.width / imageView.image.size.width);
		CGFloat fitHeightScale =  (self.frame.size.height / imageView.image.size.height);
		CGFloat fitScreenScale = MIN(fitWidthScale, fitHeightScale);
		[self setZoomScale:fitScreenScale];
		self.minimumZoomScale = fitScreenScale;
		self.maximumZoomScale = fitScreenScale;
		self.bouncesZoom = NO;
		
		imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    return self;
}

- (void)handleRotate:(BOOL)animation {
	NSLog (@"self: %@", self);
	[self setContentSize:imageView.image.size];
	self.minimumZoomScale = 0.1;
	self.maximumZoomScale = 10.0;
	CGFloat fitWidthScale =  (self.frame.size.width / imageView.image.size.width);
	CGFloat fitHeightScale =  (self.frame.size.height / imageView.image.size.height);
	CGFloat fitScreenScale = MIN(fitWidthScale, fitHeightScale);
	[self setZoomScale:fitScreenScale animated:animation];
	self.minimumZoomScale = fitScreenScale;
	self.maximumZoomScale = fitScreenScale;
	NSLog (@"iCenter: %g, %g  sCenter: %g, %g", imageView.center.x, imageView.center.y, self.center.x, self.center.y);
	imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

- (UIView *) viewForZoomingInScrollView: (UIScrollView *) scrollView {
	return imageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
