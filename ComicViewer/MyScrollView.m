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
- (id)initWithFrame:(CGRect)frame withName:(NSString*)imageName {
    
    self = [super initWithFrame:frame];
    if (self) {
		imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
		[self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
		[self setContentSize:imageView.frame.size];
		self.minimumZoomScale = 0.1;
		self.maximumZoomScale = 10.0;
		self.delegate = self;
		[self addSubview:imageView];
		
		CGFloat fitScreenScale = (self.frame.size.height / imageView.image.size.height);
		[self setZoomScale:fitScreenScale];
		self.minimumZoomScale = fitScreenScale;
		self.maximumZoomScale = fitScreenScale;
		self.bouncesZoom = NO;
		
		imageView.center = self.center;
    }
    return self;
}

- (void)handleRotate {
	[self setContentSize:imageView.frame.size];
	self.minimumZoomScale = 0.1;
	self.maximumZoomScale = 10.0;
	CGFloat fitScreenScale = (self.frame.size.height / imageView.image.size.height);
	[self setZoomScale:fitScreenScale animated:YES];
	self.minimumZoomScale = fitScreenScale;
	self.maximumZoomScale = fitScreenScale;
	imageView.center = self.center;
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
