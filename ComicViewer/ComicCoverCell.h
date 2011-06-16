//
//  ComicCoverCell.h
//  ComicViewer
//
//  Created by Penn Su on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AQGridViewCell.h"

@interface ComicCoverCell : AQGridViewCell {

    UIImageView *imageView;
}

@property (nonatomic, retain) UIImage *image;

- (id) initWithFrame: (CGRect) frame imageFrame: (CGRect) imageFrame overlayFrame: (CGRect) overlayFrame title: (NSString*)title reuseIdentifier: (NSString *) aReuseIdentifier;

@end
