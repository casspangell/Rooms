//
//  MLTimeLogViewController.m
//  Rooms
//
//  Created by Cass Pangell on 8/1/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import "MLTimeLogViewController.h"

@interface MLTimeLogViewController ()

@end

@implementation MLTimeLogViewController

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
    self.stashTable.delegate = self;
    self.stashTable.dataSource = self;
    
    beacons = [[NSArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"beacons"]];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0
                                     target:self
                                   selector:@selector(reloadTable)
                                   userInfo:nil
                                    repeats:YES];
}

-(void)reloadTable{
    [self.stashTable reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [beacons count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* key = [NSString stringWithFormat:@"%@-time", [beacons objectAtIndex:section]];

    timestampArray = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return [timestampArray count];
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }
        NSArray* reversedArray = [[timestampArray reverseObjectEnumerator] allObjects];
        cell.detailTextLabel.text = [reversedArray objectAtIndex:indexPath.row];

    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSArray *parse = [[beacons objectAtIndex:section] componentsSeparatedByString:@"-"];
    NSString *beacon = [NSString stringWithFormat:@"Major: %@, Minor: %@", [parse objectAtIndex:0], [parse objectAtIndex:1]];

    return beacon;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 44;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
