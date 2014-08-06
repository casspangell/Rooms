//
//  MLDrawing.m
//  Examples
//
//  Created by Cass Pangell on 7/24/14.
//  Copyright (c) 2014 com.estimote. All rights reserved.
//

#import "MLDrawing.h"
#import "MLVisualViewController.h"

@implementation MLDrawing

- (id)initWithFrame:(CGRect)frame andDiameter:(double)dmeter andLineWidth:(double)lWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        diameter = dmeter;
        lineWidth = lWidth;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    
   // NSLog(@"diameter %f", diameter);
   // NSLog(@"line width: %f", lineWidth);
    
    /* CGContextRef context = UIGraphicsGetCurrentContext();
     CGContextSetLineWidth(context, lineWidth);
     CGContextSetStrokeColorWithColor(context,
     [UIColor blueColor].CGColor);
     rectangle = CGRectMake(0,0,diameter,diameter);
     
     CGContextAddEllipseInRect(context, rectangle);
     CGContextStrokePath(context);*/
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 2.0);
    CGContextSetRGBFillColor(contextRef, 0, 0, 1.0, 1.0);
    CGContextSetRGBStrokeColor(contextRef, 0, 0, 1.0, 1.0);
    CGRect circlePoint = (CGRectMake(0, 0, diameter, diameter));
    
    CGContextFillEllipseInRect(contextRef, circlePoint);
    
}

@end
