//
//  MLTimeLogViewController.h
//  Rooms
//
//  Created by Cass Pangell on 8/1/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLTimeLogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    NSArray *beacons;
    NSArray *keys;
    NSMutableArray *timestampArray;

}
@property (nonatomic) IBOutlet UITableView *stashTable;
-(void)addBeaconToStash:(NSString*)beaconData;

@end
