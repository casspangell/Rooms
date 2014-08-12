//
//  ViewController.h
//  Rooms
//
//  Created by Cass Pangell on 7/28/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeacon.h"

@interface ViewController : UIViewController <ESTBeaconDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate> {
    NSUserDefaults *defaults;
    NSMutableDictionary *beaconData;
}

@property (nonatomic) IBOutlet UITableView *beaconTable;
@property (nonatomic) IBOutlet UITableView *stashedBeaconTable;

@property (nonatomic, strong) NSMutableArray *beaconsArray;
@property (nonatomic) NSMutableArray *savedBeaconsArray;
@property (nonatomic) NSMutableArray *foundBeaconsArray;
@property (nonatomic, strong) NSMutableArray *beacons;

@property (nonatomic) NSMutableArray *clockIn;

@property (nonatomic, strong) NSArray *defaultsArray;
@property (nonatomic) IBOutlet UILabel *selectLabel;

-(void)addBeaconToArray:(ESTBeacon*)beacon;
-(NSMutableArray*)getInternalBeacons;

@end
