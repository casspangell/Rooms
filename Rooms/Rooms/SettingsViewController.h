//
//  SettingsViewController.h
//  Rooms
//
//  Created by Cass Pangell on 8/12/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeacon.h"

@interface SettingsViewController : UIViewController <ESTBeaconDelegate>

@property (nonatomic, strong) NSString *beaconMajorMinor;
@property (nonatomic) IBOutlet UILabel *settingsLabel;

@end
