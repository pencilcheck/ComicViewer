//
//  Segmentation.h
//  ImageProcessing
//
//  Created by Eric on 2011/6/12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Segmentation : NSObject {
    NSMutableArray* panelArray;
}

@property (nonatomic,retain) NSMutableArray* panelArray;

-(void)panel:(UIImage*)img;

@end
