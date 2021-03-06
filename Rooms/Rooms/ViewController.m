//
//  ViewController.m
//  Rooms
//
//  Created by Cass Pangell on 7/28/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ESTBeaconManager.h"
#import "MLTimeLogViewController.h"
#import "MLVisualViewController.h"
#import "SettingsViewController.h"
#import "CustomTableViewCell.h"

#import <AudioToolbox/AudioServices.h>

@interface ViewController () <ESTBeaconManagerDelegate>{
    NSMutableArray *beaconsPrevSaved;
    int beaconflag;
    ESTBeacon *pingBeacon;
}



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.MainController = self;
    
    _savedBeaconsArray = [[NSMutableArray alloc] init];
    self.beaconTable.delegate = self;
    self.beaconTable.dataSource = self;
    self.stashedBeaconTable.delegate = self;
    self.stashedBeaconTable.dataSource = self;
    
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:self.beacon.proximityUUID
                                                                 major:[self.beacon.major unsignedIntValue]
                                                                 minor:[self.beacon.minor unsignedIntValue]
                                                            identifier:@"RegionIdentifier"];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.beaconTable reloadData];
}

-(void) fade:(BOOL)didSave {
    [UIView animateWithDuration:.1 animations:^(void) {
        [_selectLabel setAlpha:.3];
        [_beaconTable setAlpha:.3];
    }];
    
    if (didSave) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Beacon is now stashed. To remove beacon, tap it below." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Beacon is already stashed." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
}

-(void) fadeOn {
    [UIView animateWithDuration:.3 animations:^(void) {
        [_selectLabel setAlpha:1];
        [_beaconTable setAlpha:1];
    }];
}

#pragma mark - Beacon Management
-(void)addBeaconToArray:(ESTBeacon*)beacon{
    NSLog(@"beacon adding to array %@", beacon);
    
    defaults = [NSUserDefaults standardUserDefaults];
    _beacons = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"beacons"]];
    
    NSLog(@"current beacons saved %@", _beacons);
    [_beacons addObject:[NSString stringWithFormat:@"%@-%@", beacon.major, beacon.minor]];
    
    [defaults setObject:_beacons forKey:@"beacons"];
    NSLog(@"beacons added %@", [defaults objectForKey:@"beacons"]);
    
    [self.stashedBeaconTable reloadData];
    
}



-(NSMutableArray*)getInternalBeacons{
    defaults = [NSUserDefaults standardUserDefaults];
    _beacons = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"beacons"]];
    return _beacons;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self fadeOn];
    
    if (alertView.tag == 2) {

    }
    [_beaconTable reloadData];
}

#pragma mark - Segue
- (void)handleSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self performSegueWithIdentifier:@"visualDataSegue" sender:self];
    }else{
        [self performSegueWithIdentifier:@"seeBeaconStashData" sender:self];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"settingsSegue"]) {
        NSLog(@"sender %@", sender);
        SettingsViewController *destViewController = segue.destinationViewController;
        destViewController.beaconMajorMinor = sender;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _beaconTable){
        return [_beaconsArray count];
    
    }else{
        
        NSArray *beacons = [[NSArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"beacons"]];
        return [beacons count];
    }
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    CustomTableViewCell *cell = (CustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    ESTBeacon *beacon = [[ESTBeacon alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];

    //Load Found Beacons
    if (tableView == _beaconTable) {
        
        beacon = [_beaconsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@", beacon.major, beacon.minor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %.2f", [beacon.distance floatValue]];
        
        if (pingBeacon.major == beacon.major) {
            cell.imageView.image = [self changeBeaconState:cell];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"beacon"];
        }
        
        return cell;
        
        //Load Stashed Beacons
    }else if (tableView == _stashedBeaconTable){
        NSArray *beacons = [[NSArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"beacons"]];
        NSLog(@"beacons %@", beacons);
        beacon = [beacons objectAtIndex:indexPath.row];
        
        NSString *bstring = [beacons objectAtIndex:indexPath.row];
        NSArray *parse = [bstring componentsSeparatedByString:@"-"];
        
        cell.detailTextLabel.numberOfLines = 3;
        cell.detailTextLabel.text = @"Tap for settings.\rSwipe right to view visual data.\rSwipe left to view historical data.";
        cell.textLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@", [parse objectAtIndex:0], [parse objectAtIndex:1]];
        cell.imageView.image = nil;
         
         // Add utility buttons
         NSMutableArray *leftUtilityButtons = [NSMutableArray new];
         NSMutableArray *rightUtilityButtons = [NSMutableArray new];
         
         [leftUtilityButtons sw_addUtilityButtonWithColor:
          [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.7]
                                                     icon:[UIImage imageNamed:@"data.png"]];

         [rightUtilityButtons sw_addUtilityButtonWithColor:
          [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.7]
                                                      icon:[UIImage imageNamed:@"settings.png"]];

        
         cell.leftUtilityButtons = leftUtilityButtons;
         cell.rightUtilityButtons = rightUtilityButtons;
         cell.delegate = self;
         
         return cell;
     }else{
         return nil;
     }

}

-(UIImage*)changeBeaconState:(UITableViewCell*)cell{
    UIImage *beaconImage;

    if (beaconflag == 1){
        
        beaconImage = [UIImage imageNamed:@"redbeacon.png"];

    }else{
        
        beaconImage = [UIImage imageNamed:@"beacon"];
    }
    
    beaconflag = 0;
    
    return beaconImage;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (tableView == _beaconTable) {
        if ([_beaconsArray count] > 0) {
            return @"Found beacon - Tap to activate.";
        }else{
            return @"Searching...";
        }
        
    }else if (tableView == _stashedBeaconTable){

        if ([[self getInternalBeacons] count]>0){
            return @"Saved Beacons in Stash";
        }else{
            return @"No Beacons in Stash";
    }
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _beaconTable) {
        return 100;
    }else{
        return 100;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    return tableView.tableFooterView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESTBeacon *selectedBeacon = [_beaconsArray objectAtIndex:indexPath.row];

    defaults = [NSUserDefaults standardUserDefaults];
    NSArray *savedbeacons = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"beacons"]];

        if (tableView == _beaconTable) {
            if ([savedbeacons containsObject:[NSString stringWithFormat:@"%@-%@", selectedBeacon.major, selectedBeacon.minor]]) {
                NSLog(@"beacon already saved");
                [self fade:NO];
            }else{
                //NSLog(@"need to save beacon");
                [_savedBeaconsArray addObject:selectedBeacon];
                
                NSString *major = [NSString stringWithFormat:@"%@", selectedBeacon.major];
                NSString *minor = [NSString stringWithFormat:@"%@", selectedBeacon.minor];
                [beaconsPrevSaved addObject:[NSString stringWithFormat:@"%@-%@", major, minor]];
                
                [self addBeaconToArray:selectedBeacon];
                [self fade:YES];
            }
        }
        
        else{
           // ESTBeacon *selectedBeacon = [savedbeacons objectAtIndex:indexPath.row];
           // [self performSegueWithIdentifier:@"settingsSegue" sender:selectedBeacon];
        }
}

#pragma mark - SWCell delegates
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
            
        //Settings
        case 0:
        {
            NSIndexPath *cellIndexPath = [self.stashedBeaconTable indexPathForCell:cell];
            NSMutableArray *savedbeacons = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"beacons"]];
            ESTBeacon *selectedBeacon = [savedbeacons objectAtIndex:cellIndexPath.row];
            [self performSegueWithIdentifier:@"settingsSegue" sender:selectedBeacon];
            break;
        }
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [self.stashedBeaconTable indexPathForCell:cell];
            NSMutableArray *savedbeacons = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"beacons"]];
            ESTBeacon *selectedBeacon = [savedbeacons objectAtIndex:cellIndexPath.row];
            [self performSegueWithIdentifier:@"visualDataSegue" sender:selectedBeacon];
            break;
        }
        default:
            break;
    }
}

#pragma mark - ESTBeaconManager delegate
//Detects all beacons in range
- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    NSArray *savedbeacons = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"beacons"]];
    
    if (beacons.count > 0)
    {
        _beaconsArray = [[NSMutableArray alloc] init];
        
        //Adding beacons to UITableView
        for (int i=0; i<[beacons count]; i++) {
            ESTBeacon *beacon = [beacons objectAtIndex:i];
            
            //Beacon's distance is unknown
            if ([beacon.distance isEqualToNumber:[NSNumber numberWithDouble:-1.00]]) {
                //don't add to array
            }else{
                [_beaconsArray addObject:[beacons objectAtIndex:i]];
            }
            
            //If one of the stashed beacons is close, add the time to the dictionary
            for (int i=0; i< [savedbeacons count]; i++) {
                NSString *savedBeacon = [savedbeacons objectAtIndex:i];
                
                if ([savedBeacon isEqualToString:[NSString stringWithFormat:@"%@-%@", beacon.major, beacon.minor]]) {

                    if ([[self grabProximity:beacon.proximity] isEqualToString:@"Immediate"]) {
                        
                        NSLocale* currentLocale = [NSLocale currentLocale];

                        [self setBeaconInDict:beacon :[[NSDate date] descriptionWithLocale:currentLocale]];
                    }
                 
                //This beacon isn't stashed yet!
                }else{
                    if(![[self grabProximity:beacon.proximity] isEqualToString:@"Unknown"]){
                        //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                        
                    }
                }
            }
            
        }
        
        [_beaconTable reloadData];
    }
}

-(void)setBeaconInDict:(ESTBeacon*)beacon :(NSString*)timestamp
{
    pingBeacon = beacon;
    NSString *key = [NSString stringWithFormat:@"%@-%@-time", beacon.major, beacon.minor];
    
    NSArray *components = [timestamp componentsSeparatedByString:@"Mountain Daylight Time"];
    NSString *newTime = [components objectAtIndex:0];

    NSMutableArray *timestampArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
    //NSLog(@"timestampArray %@", timestampArray);
    
    //Does timestamp have any values to compare?
    if ([timestampArray count] > 0) {
        NSString *lastObj = [timestampArray objectAtIndex:[timestampArray count]-1];
        
        //5 second buffer
        if ([self compareTime:[self parseString:lastObj] :[self parseString:newTime]]) {
         [timestampArray addObject:newTime];
        AudioServicesPlaySystemSound (1052);
            beaconflag = 1;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:timestampArray forKey:key];
        //NSLog(@"dict1 %@", [[NSUserDefaults standardUserDefaults] objectForKey:key]);
        
    }else{
        
        [timestampArray addObject:newTime];
        [[NSUserDefaults standardUserDefaults] setObject:timestampArray forKey:key];
        beaconflag = 1;
        //NSLog(@"dict2 %@", [[NSUserDefaults standardUserDefaults] objectForKey:key]);
    }
}



-(NSArray*)parseString:(NSString*)comp{
    NSArray *comp2 = [comp componentsSeparatedByString:@"at "];
    NSString *string1 = [comp2 objectAtIndex:1];
    NSArray *comp3 = [string1 componentsSeparatedByString:@" "];
    NSString *string2 = [comp3 objectAtIndex:0];
    NSArray *comp4 = [string2 componentsSeparatedByString:@":"];
    
    return comp4;
}

#pragma mark - Time Buffer
-(BOOL)compareTime:(NSArray*)oldTime :(NSArray*)newTime{

    if ([[oldTime objectAtIndex:0] intValue] == [[newTime objectAtIndex:0] intValue]) {
        //same hour
        
        if ([[oldTime objectAtIndex:1] intValue] == [[newTime objectAtIndex:1] intValue]) {
           //same min
           
            int value = [[newTime objectAtIndex:2] intValue] - [[oldTime objectAtIndex:2] intValue];
            //same sec
            
            if (value > 10) {
                return YES;
            }else
                return NO;
        //Not the same minute
        }else
            return YES;
    
        //Time is not within x seconds of previous
    }else{
        return YES;
    }
}

- (NSString *)grabProximity:(CLProximity)proximity
{
    switch (proximity) {
        case CLProximityFar:
            return @"Far";
            break;
        case CLProximityNear:
            return @"Near";
            break;
        case CLProximityImmediate:
            return @"Immediate";
            break;
            
        default:
            return @"Unknown";
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
