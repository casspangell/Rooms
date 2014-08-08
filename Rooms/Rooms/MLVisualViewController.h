//
//  MLVisualViewController.h
//  Rooms
//
//  Created by Cass Pangell on 8/5/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLDrawing.h"

@interface MLVisualViewController : UIViewController <UIGestureRecognizerDelegate> {
    NSArray *beacons;
    NSMutableArray *timestampArray;
    NSMutableArray *days;
    NSMutableArray *months;
    NSMutableArray *numbers;
    
    UIPinchGestureRecognizer *pinchGesture;
    UISwipeGestureRecognizer *swipeGesture;
    
    MLDrawing *drawing;
    double mdiameter;
    double lWidth;
}
@property (nonatomic) IBOutlet UITableView *stashTable;

-(void)setDiameter:(double)dmeter;
-(double)getDiameter;
-(void)createDrawing;

@end
