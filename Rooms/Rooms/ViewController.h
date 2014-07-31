//
//  ViewController.h
//  Rooms
//
//  Created by Cass Pangell on 7/28/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeacon.h"

@interface ViewController : UIViewController <ESTBeaconDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    NSUserDefaults *defaults;
}

@property (nonatomic) IBOutlet UITableView *beaconTable;
@property (nonatomic) IBOutlet UITableView *stashedBeaconTable;

@property (nonatomic, strong) NSMutableArray *beaconsArray;
@property (nonatomic) NSMutableArray *savedBeaconsArray;
@property (nonatomic) NSMutableArray *foundBeaconsArray;
@property (nonatomic) NSMutableArray *beacons;

@property (nonatomic, strong) NSArray *defaultsArray;
@property (nonatomic) IBOutlet UILabel *selectLabel;

- (id)initWithBeacon:(ESTBeacon *)beacon;
-(void)addBeaconToArray:(ESTBeacon*)beacon;
-(NSMutableArray*)getInternalBeacons;
@end
