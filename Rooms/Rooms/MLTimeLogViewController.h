//
//  MLTimeLogViewController.h
//  Rooms
//
//  Created by Cass Pangell on 8/1/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLTimeLogViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    NSMutableArray *stashArray;

}
@property (nonatomic) IBOutlet UITableView *stashTableView;
-(void)addBeaconToStash:(NSString*)beaconData;

@end
