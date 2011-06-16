//
//  ComicCoverCell.m
//  ComicViewer
//
//  Created by Penn Su on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ComicCoverCell.h"


@implementation ComicCoverCell

@synthesize image;

- (id) initWithFrame: (CGRect) frame imageFrame: (CGRect) imageFrame overlayFrame: (CGRect) overlayFrame title: (NSString*)title reuseIdentifier: (NSString *) aReuseIdentifier
{
	self = [super initWithFrame: frame reuseIdentifier: aReuseIdentifier];
    
    
	if ( self != nil ) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        imageView = [[UIImageView alloc] initWithFrame: imageFrame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UIImageView* overlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BoxOverlay.png"]];
        overlay.frame = overlayFrame;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UILabel* titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        [titleLabel sizeToFit];
        CGRect titleFrame = titleLabel.frame;
        titleFrame.origin = CGPointMake(self.contentView.bounds.size.width / 2 - titleFrame.size.width / 2 -3, overlay.frame.size.height+1);
        titleLabel.frame = titleFrame;
        
        titleLabel.backgroundColor = [UIColor clearColor];
        
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        
        [self.contentView addSubview: imageView];
        [self.contentView addSubview: overlay];
        //[self.contentView addSubview: titleLabel];
        [titleLabel release];
        [overlay release];
    }
	
	return self;
}

- (UIImage *) image
{
    return ( imageView.image );
}

- (void) setImage: (UIImage *) anImage
{
    imageView.image = [anImage retain];
    [self setNeedsLayout];
}

- (void)dealloc {
    [imageView release];
    [super dealloc];
}
@end
