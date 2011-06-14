//
//  panelcut.m
//  ComicViewer
//
//  Created by VincentLee on 2011/6/14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "panelcut.h"


@implementation panelcut

@synthesize corners;

- (void) panel:(UIImage*) img{
    NSLog(@"panel starts cutting");
    CGImageRef cgImage = [img CGImage];
    int height=CGImageGetHeight(cgImage);
    int width=CGImageGetWidth(cgImage);
    CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
    CFDataRef bitmapData = CGDataProviderCopyData(provider);
    NSData *myData = (NSData *)bitmapData;
    
    int dataSize=[myData length]/4;
    
    unsigned int v[dataSize];
    [myData getBytes:v length:[myData length]];
	//    
	//    NSMutableArray* array= [[NSMutableArray alloc ] init];
	//    
	//    for (int i=0; i<dataSize; i++) {
	//        [array addObject:(id) v[i]];
	//    }
    
    //int l_w = 20;
    //int l_h = 20;
	
	// cut straight line
    
	bool found = YES;
	int horizontaCount = 0;
	NSMutableArray* horr = [[NSMutableArray alloc] init];
	
    for (int h=0; h<height; h++){
        bool empty = YES;
        for (int s=0; s<width; s++){
            unsigned int pixel = v[(width*h+s)];
            if(pixel < 4286578688){
                empty = NO;
            }
        }
        if(!empty){
            found = NO;
			//NSLog(@"black @ h = %d",h);
        }
        if(empty&&!found){
            //NSLog(@"found %d",h);
			horizontaCount++;
			cord* newcord = [[cord alloc] init];
			[newcord setXY:0 :h];
			[horr addObject:newcord];
			[newcord release];
			found = YES;
        }
    }
	
	
	//NSMutableArray* 
	corners = [[NSMutableArray alloc] init];
	
	// these are LOWER LEFT corners
	int vertiCount = 0;
	
	for (int strp=0; strp<horizontaCount; strp++) {
		int upbond,lowbond;
		if(strp==0){
			upbond = 0;
			lowbond = [[horr objectAtIndex:0] getY];
		}else {
			upbond = [[horr objectAtIndex:(strp-1)] getY];
			lowbond = [[horr objectAtIndex:strp] getY];
		}
		
		found = YES;
		for (int w=0; w<width; w++){
			bool empty = YES;
			for (int s=upbond; s<lowbond; s++){
				unsigned int pixel = v[(w+s*height)];
				if(pixel < 4286578688){
					empty = NO;
				}
			}
			if(!empty){
				found = NO;
				//NSLog(@"black @ h = %d",h);
			}
			if(empty&&!found){
				//NSLog(@"found %d",h);
				vertiCount++;
				cord* newcord = [[cord alloc] init];
				[newcord setXY:w :lowbond];
				[corners addObject:newcord];
				[newcord release];
				found = YES;
			}
			
		}
	}
	
	NSLog(@"h = %d",horizontaCount);
	NSLog(@"w = %d",vertiCount);
	NSLog(@"%d",[corners count]);
}

@end


@implementation cord

@synthesize x;
@synthesize y;

-(void) setXY :(int) n_x : (int) n_y {
	x = n_x;
	y = n_y;
}
-(int)  getY{
	return y;
}
-(int)  getX{
	return x;
}
@end


