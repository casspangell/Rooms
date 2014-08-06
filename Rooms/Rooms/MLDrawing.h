//
//  MLDrawing.h
//  Examples
//
//  Created by Cass Pangell on 7/24/14.
//  Copyright (c) 2014 com.estimote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLDrawing : UIView {
    CGRect rectangle;
    float diameter;
    float lineWidth;
}

- (id)initWithFrame:(CGRect)frame andDiameter:(double)dmeter andLineWidth:(double)lWidth;

@end
