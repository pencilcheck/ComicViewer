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
}

-(void) setXY :(int) n_x : (int) n_y;
-(int)  getY;
-(int)  getX;

@property int x;
@property int y;

@end

