//
//  MLBeaconData.h
//  Rooms
//
//  Created by Cass Pangell on 8/1/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESTBeacon.h"

@interface MLBeaconData : NSObject {
    NSMutableDictionary *beaconDict;
}

-(void)setBeaconInDict:(ESTBeacon*)beacon;
-(NSMutableDictionary*)getBeaconDict;

@end
