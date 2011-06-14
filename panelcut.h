//
//  panelcut.h
//  ComicViewer
//
//  Created by VincentLee on 2011/6/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface panelcut : NSObject {
	
	NSMutableArray* corners;
	
}

@property (nonatomic,retain) NSMutableArray* corners;


- (void) panel:(UIImage*) img;

@end


@interface cord : NSObject
{
	int x,y;
	int h,w;
}

-(void) setXY :(int) n_x : (int) n_y;
-(void) setHW :(int) n_h : (int) n_w;

-(CGRect) makeRect;
-(int)  getY;
-(int)  getX;

@property int x;
@property int y;
@property int h;
@property int w;


@end

