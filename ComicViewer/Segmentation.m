//
//  Segmentation.m
//  ImageProcessing
//
//  Created by Eric on 2011/6/12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "Segmentation.h"


@implementation Segmentation

@synthesize panelArray;

- (void) panel:(UIImage*) img{
    
    CGImageRef cgImage = [img CGImage];
    int height=CGImageGetHeight(cgImage);
    int width=CGImageGetWidth(cgImage);
    CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
    CFDataRef bitmapData = CGDataProviderCopyData(provider);
    NSData *myData = (NSData *)bitmapData;
    
    int dataSize=[myData length];
    
    unsigned int *v = (unsigned int *) [myData bytes];
    
    // [myData getBytes:v length:[myData length]];
    
    
    
    
    
    //    NSLog(@"red %d,blue %d,green %d,",red,blue,green);
    //    
    //    NSMutableArray* array= [[NSMutableArray alloc ] init];
    //    
    //    for (int i=0; i<dataSize; i++) {
    //        [array addObject:(id) v[i]];
    //    }4278190080
    panelArray= [[NSMutableArray alloc]init ];
    
    int lastCutHeight=0;
    int whitePixel=0;
    for (int h=0; h<height; h++ ) {
        whitePixel=0;
        for (int w=0;w<width;w++){
            int i=h*width+w;
            unsigned int red = (v[i] & 0x0000FF);
            unsigned int green = (v[i] & 0x00FF00) >> 8;
            unsigned int blue = (v[i] & 0xFF0000) >> 16;
            float brightness=red*0.3+green*0.6+blue*0.1;
            
            if (brightness>240) {
                whitePixel++;
            }
        }
        //NSLog(@"whitepixel at line %d is %d",h,whitePixel);
        
        if (whitePixel>500) {
            if ((h-lastCutHeight)>200) {
                [panelArray addObject:[NSValue valueWithCGRect:CGRectMake(0, lastCutHeight, width, h-lastCutHeight)]];
                NSLog(@"%d",h);
            }
            
            lastCutHeight=h;
        }
        
    }
    
    
    //    
    //    int l_w = 20;
    //    int l_h = 20;
    //    bool foundCut = YES;
    //    
    //    for (int h=0; h<height; h++){
    //        bool allWhite = YES;
    //        for (int s=0; s<width; s++){
    //            unsigned int pixel = v[(width*h+s)];
    //            if(pixel < 4286578688){
    //                allWhite = NO;
    //            }
    //        }
    //        if(!allWhite){
    //            foundCut = NO;
    //        }
    //        if(allWhite&&!foundCut){
    //            NSLog(@"found %d",h);
    //            foundCut = YES;
    //        }
    //    }
    //    
    
    
}

@end