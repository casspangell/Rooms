//
//  ViewController.m
//  Rooms
//
//  Created by Cass Pangell on 7/28/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import "ViewController.h"
#import "ESTBeaconManager.h"

@interface ViewController () <ESTBeaconManagerDelegate>{
    NSMutableArray *beaconsPrevSaved;
}

@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _savedBeaconsArray = [[NSMutableArray alloc] init];
    self.beaconTable.delegate = self;
    self.beaconTable.dataSource = self;
    
    _selectLabel.text = @"Current beacons in stash.";
    
    //Check if beacon is already saved
    ESTBeacon *beacon = [[ESTBeacon alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];
    beaconsPrevSaved = [[NSMutableArray alloc] init];
    NSLog(@"%@", [defaults objectForKey:@"beacons"]);
    
    
    //NSLog(@"Saved beacons %@", [defaults objectForKey:[NSString stringWithFormat:@"%@", selectedBeacon.minor]]);
    
    /*
     * BeaconManager setup.
     */
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    self.beaconRegion = [[ESTBeaconRegion alloc] initWithProximityUUID:self.beacon.proximityUUID
                                                                 major:[self.beacon.major unsignedIntValue]
                                                                 minor:[self.beacon.minor unsignedIntValue]
                                                            identifier:@"RegionIdentifier"];
    [self.beaconManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void) fade {
    [UIView animateWithDuration:.1 animations:^(void) {
        [_selectLabel setAlpha:.3];
        [_beaconTable setAlpha:.3];
    }];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved!" message:@"Beacon is now active." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

-(void) fadeOn {
    [UIView animateWithDuration:.3 animations:^(void) {
        [_selectLabel setAlpha:1];
        [_beaconTable setAlpha:1];
    }];
}

-(void)addBeaconToArray:(ESTBeacon*)beacon{
    NSLog(@"beacon %@", beacon);
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *beacons = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"beacons"]];
    
    NSLog(@"%@", beacons);
    [beacons addObject:[NSString stringWithFormat:@"%@-%@", beacon.major, beacon.minor]];
    
    [defaults setObject:beacons forKey:@"beacons"];
    NSLog(@"beacons %@", [defaults objectForKey:@"beacons"]);
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self fadeOn];
    
    
    [_beaconTable reloadData];
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
        return [_savedBeaconsArray count];
    }
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    
    ESTBeacon *beacon = [[ESTBeacon alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];
    
    _foundBeaconsArray = [[NSMutableArray alloc] init];

    if (indexPath.section == 0) {
        
        for (int i=0; i<[_beaconsArray count]; i++) {
            [_foundBeaconsArray addObject:[_beaconsArray objectAtIndex:i]];
        }
        
        // NSLog(@"found %@", _foundBeaconsArray);
        
        beacon = [_foundBeaconsArray objectAtIndex:indexPath.row];
    }else{
        beacon = [_savedBeaconsArray objectAtIndex:indexPath.row];
        cell.userInteractionEnabled = NO;
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@", beacon.major, beacon.minor];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %.2f", [beacon.distance floatValue]];
    
    cell.imageView.image = [UIImage imageNamed:@"beacon"];
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    
    if (section == 0 && ([_beaconsArray count] > 0)) {
        return @"Found beacon - Tap to activate.";
        
    }else{
        return @"Saved Beacons";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESTBeacon *selectedBeacon = [_beaconsArray objectAtIndex:indexPath.row];
    
    
    /*
    [_foundBeaconsDic setObject:selectedBeacon.major forKey:selectedBeacon.minor];

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_foundBeaconsDic];
    [defaults setObject:data forKey:@"beacons"];
    [defaults synchronize];
    */
    //NSLog(@"dict %@", [_foundBeaconsDic description]);
    
   // [defaults setObject:selectedBeacon.major forKey:[NSString stringWithFormat:@"beacon-%@", selectedBeacon.minor]];
    
    
    if ([_beaconsArray count] > 0) {
        if ([_savedBeaconsArray containsObject:selectedBeacon]) {
            //NSLog(@"beacon already saved");
        }else{
            //NSLog(@"need to save beacon");
            [_savedBeaconsArray addObject:selectedBeacon];
            
            NSString *major = [NSString stringWithFormat:@"%@", selectedBeacon.major];
            NSString *minor = [NSString stringWithFormat:@"%@", selectedBeacon.minor];
            [beaconsPrevSaved addObject:[NSString stringWithFormat:@"%@-%@", major, minor ]];

            //[defaults setObject:beaconsPrevSaved forKey:@"beacons"];
            //NSLog(@"NSUserDefaults %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
            
            [self addBeaconToArray:selectedBeacon];
        }
    }
    
    
    [self fade];
}

#pragma mark - ESTBeaconManager delegate
//Detects all beacons in range
- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    if (beacons.count > 0)
    {
        _beaconsArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[beacons count]; i++) {
            ESTBeacon *beacon = [beacons objectAtIndex:i];
            
            if ([beacon.distance isEqualToNumber:[NSNumber numberWithDouble:-1.00]]) {
                //don't add to array
            }else{
                [_beaconsArray addObject:[beacons objectAtIndex:i]];
            }
        }
        
        [_beaconTable reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
