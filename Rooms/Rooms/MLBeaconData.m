//
//  MLBeaconData.m
//  Rooms
//
//  Created by Cass Pangell on 8/1/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import "MLBeaconData.h"

@implementation MLBeaconData

-(void)setBeaconInDict:(ESTBeacon*)beacon{
    NSLog(@"beacon %@", beacon);
    
  /*  if ([self isBeaconAlreadyInDict:beacon]) {
        NSString *majorMinor = [NSString stringWithFormat:@"%@-%@", beacon.major, beacon.minor];
        NSLocale* currentLocale = [NSLocale currentLocale];
        NSString* timestamp = [[NSDate date] descriptionWithLocale:currentLocale];
        
       // [beaconDict setObject:timestamp forKey:majorMinor];
        
        NSLog(@"beacon is in dict");
    }*/

}

-(NSMutableDictionary*)getBeaconDict{
    return beaconDict;
}

-(BOOL)isBeaconAlreadyInDict:(ESTBeacon*)beacon{

    NSString *majorMinor = [NSString stringWithFormat:@"%@-%@", beacon.major, beacon.minor];
    
    NSLog(@"isInDict? %@", [beaconDict objectForKey:majorMinor]);
    
    if ([beaconDict objectForKey:majorMinor]) {
        [self setBeaconInDict:beacon];
        return YES;
    }else{
        return NO;
    }
}



@end
