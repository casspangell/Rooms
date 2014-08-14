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

#import <AudioToolbox/AudioServices.h>

@interface ViewController () <ESTBeaconManagerDelegate>{
    NSMutableArray *beaconsPrevSaved;
    int beaconflag;
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
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:self.beacon.proximityUUID
                                                                 major:[self.beacon.major unsignedIntValue]
                                                                 minor:[self.beacon.minor unsignedIntValue]
                                                            identifier:@"RegionIdentifier"];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
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
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
}



-(void)beaconSettings:(ESTBeacon*)beacon{
    NSLog(@"settings %@", beacon);

    
    /*NSMutableArray *beacons = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"beacons"]];
    [beacons removeObject:[NSString stringWithFormat:@"%@-%@", beacon.major, beacon.minor]];
    
    [[NSUserDefaults standardUserDefaults] setObject:beacons forKey:@"beacons"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Removed %@-%@", beacon.major, beacon.minor] message:@"Beacon history  will not be removed. You can re-add beacon at anytime. Go to Settings to delete beacon history." delegate:self cancelButtonTitle:@"Ok"otherButtonTitles: nil];
    [alert show];
    

    [self.beaconTable reloadData];
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);*/
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return [_beaconsArray count];
    
    }else{
        
        NSArray *beacons = [[NSArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"beacons"]];
        return [beacons count];
    }
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if(!_tableViewCell){
        _tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }

    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [_tableViewCell.contentView addGestureRecognizer:swipeGesture];
    
    UISwipeGestureRecognizer *swipeGestureL = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGestureL setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_tableViewCell.contentView addGestureRecognizer:swipeGestureL];
    
    ESTBeacon *beacon = [[ESTBeacon alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];
    
    _foundBeaconsArray = [[NSMutableArray alloc] init];

    //Load Found Beacons
    if (indexPath.section == 0) {
        
        for (int i=0; i<[_beaconsArray count]; i++) {
            [_foundBeaconsArray addObject:[_beaconsArray objectAtIndex:i]];
        }

        beacon = [_foundBeaconsArray objectAtIndex:indexPath.row];
        _tableViewCell.textLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@", beacon.major, beacon.minor];
        _tableViewCell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %.2f", [beacon.distance floatValue]];
        
        _tableViewCell.imageView.image = [self changeBeaconState:_tableViewCell];

    //Load Stashed Beacons
    }else{
        NSArray *beacons = [[NSArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"beacons"]];
        beacon = [beacons objectAtIndex:indexPath.row];
        
        NSString *bstring = [beacons objectAtIndex:indexPath.row];
        NSArray *parse = [bstring componentsSeparatedByString:@"-"];

        _tableViewCell.detailTextLabel.numberOfLines = 3;
        _tableViewCell.detailTextLabel.text = @"Tap for settings.\rSwipe right to view visual data.\rSwipe left to view historical data.";
        _tableViewCell.textLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@", [parse objectAtIndex:0], [parse objectAtIndex:1]];
        _tableViewCell.imageView.image = nil;
    }

    return _tableViewCell;
}

-(UIImage*)changeBeaconState:(UITableViewCell*)cell{
    UIImage *beaconImage;
    
    if (beaconflag == 1){
        
        beaconImage = [UIImage imageNamed:@"redbeacon.png"];

    }else{
        
        beaconImage = [UIImage imageNamed:@"beacon"];
    }
    
   /* cell.imageView.image = beaconImage;
    cell.imageView.alpha = 0;
    
    [UIView animateWithDuration:.5 animations:^{
        cell.imageView.alpha = 1;
        
    }];*/
    beaconflag = 0;
    
    return beaconImage;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        if ([_beaconsArray count] > 0) {
            return @"Found beacon - Tap to activate.";
        }else{
            return @"Searching...";
        }
        
    }else {

        if ([[self getInternalBeacons] count]>0){
            return @"Saved Beacons in Stash";
        }else{
            return @"No Beacons in Stash";
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 1) {
        return 100;//45
    }else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESTBeacon *selectedBeacon = [_beaconsArray objectAtIndex:indexPath.row];

    defaults = [NSUserDefaults standardUserDefaults];
    NSArray *savedbeacons = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"beacons"]];

        if (indexPath.section == 0) {
            if ([savedbeacons containsObject:[NSString stringWithFormat:@"%@-%@", selectedBeacon.major, selectedBeacon.minor]]) {
                NSLog(@"beacon already saved");
                [self fade:NO];
            }else{
                //NSLog(@"need to save beacon");
                [_savedBeaconsArray addObject:selectedBeacon];
                
                NSString *major = [NSString stringWithFormat:@"%@", selectedBeacon.major];
                NSString *minor = [NSString stringWithFormat:@"%@", selectedBeacon.minor];
                [beaconsPrevSaved addObject:[NSString stringWithFormat:@"%@-%@", major, minor ]];
                
                [self addBeaconToArray:selectedBeacon];
                [self fade:YES];
            }
        }
        
        else{
            ESTBeacon *selectedBeacon = [savedbeacons objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"settingsSegue" sender:selectedBeacon];
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
