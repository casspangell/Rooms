//
//  SettingsViewController.m
//  Rooms
//
//  Created by Cass Pangell on 8/12/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () {
    NSMutableArray *optionsArray;
}

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ESTBeacon *beacon = [[NSUserDefaults standardUserDefaults] objectForKey:_beaconMajorMinor];
    _settingsLabel.text = [NSString stringWithFormat:@"Settings for %@ beacon:", _beaconMajorMinor];
    NSLog(@"beacon %@", _beaconMajorMinor);
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGesture];
    
    self.settingsTable.delegate = self;
    self.settingsTable.dataSource = self;
    
    optionsArray = [[NSMutableArray alloc] initWithObjects:@"Remove beacon from stash", @"Delete beacon data history", nil];

}

#pragma mark - Segue
- (void)handleSwipe:(UISwipeGestureRecognizer*)swipe{
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self performSegueWithIdentifier:@"homeSegue" sender:self];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [optionsArray count];
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.textLabel.text = [optionsArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *message;
    
    if (indexPath.row == 0){
        NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"beacons"];
        [arr removeObject:_beaconMajorMinor];
        [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"beacons"];
        message = [NSString stringWithFormat:@"Beacon %@ removed from stash.", _beaconMajorMinor];
    }
    
    if (indexPath.row == 1) {

        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@-time", _beaconMajorMinor]];
        message = [NSString stringWithFormat:@"Beacon's %@ data history removed from stash.", _beaconMajorMinor];
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-time", _beaconMajorMinor]]);
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
