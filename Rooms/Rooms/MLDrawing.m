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

- (id)initWithFrame:(CGRect)frame andDiameter:(double)dmeter andLineWidth:(double)lWidth andColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        diameter = dmeter;
        lineWidth = lWidth;
        colorRef = color;

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setColor{
    
}

- (void)drawRect:(CGRect)rect {
    const float* colors = CGColorGetComponents(colorRef.CGColor);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 2.0);
    CGContextSetRGBFillColor(contextRef, colors[0], colors[1], colors[2], colors[3]);
    CGRect circlePoint = (CGRectMake(0, 0, diameter, diameter));
    CGContextFillEllipseInRect(contextRef, circlePoint);
    
}

@end
