//
//  MLVisualViewController.m
//  Rooms
//
//  Created by Cass Pangell on 8/5/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import "MLVisualViewController.h"
#import "MLDrawing.h"

@interface MLVisualViewController (){
    NSMutableArray *hours;
    NSMutableArray *minutes;
    NSMutableArray *seconds;
}

@end

@implementation MLVisualViewController

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
    
    days = [[NSMutableArray alloc] init];

    numbers = [[NSMutableArray alloc] init];
    hours = [[NSMutableArray alloc] init];
    minutes = [[NSMutableArray alloc] init];
    seconds = [[NSMutableArray alloc] init];
    
    [self getBeacons];
    
    [self getNumbers];

}

-(void) viewDidAppear:(BOOL)animated{
    [self createDrawing];
    
  /*  for (int i=0; i<[hours count]; i++) {
        [self performSelector:@selector(createDrawing:) withObject:[hours objectAtIndex:i] afterDelay:2.0];
        [self performSelector:@selector(test) withObject:nil afterDelay:2.0];
    }
   */
}

-(void)test{
   // NSLog(@"test");
}

-(void)parse:(NSString*)time{
    NSArray *pieces = [time componentsSeparatedByString:@","];
    NSString *day = [pieces objectAtIndex:0];
    [days addObject:day];
    
    NSString *monthDay = [pieces objectAtIndex:1];
    NSString *yearAtTime = [pieces objectAtIndex:2];
   // NSLog(@"%@ %@ %@", day, monthDay, yearAtTime);
    NSArray *parseYearAtTime = [ yearAtTime componentsSeparatedByString:@" "];

    NSString *thetime = [parseYearAtTime objectAtIndex:3];
    NSArray *arrayNum = [thetime componentsSeparatedByString:@":"];
    NSString *hour = [arrayNum objectAtIndex:0];
    NSString *min = [arrayNum objectAtIndex:1];
    NSString *sec = [arrayNum objectAtIndex:2];
    [numbers addObject:thetime];
    
}

-(void)getNumbers{
    //NSLog(@"=> %@", numbers);

    for (int i=0; i<[numbers count]; i++) {
        NSArray *parse = [[numbers objectAtIndex:i] componentsSeparatedByString:@":"];
        [hours addObject:[parse objectAtIndex:0]];
        [minutes addObject:[parse objectAtIndex:1]];
        [seconds addObject:[parse objectAtIndex:2]];
    }
}

-(void)getBeacons{
    beacons = [[NSArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"beacons"]];
    
    for (int i=0; i<[beacons count]; i++) {
        NSString *key = [beacons objectAtIndex:i];
        timestampArray = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@-time", key]];
    }
    
    for (int i=0; i<[timestampArray count]; i++) {
        [self parse:[timestampArray objectAtIndex:i]];
    }
    

}

-(void)createDrawing {
 
    NSMutableDictionary *daysDict = [[NSMutableDictionary alloc] initWithDictionary:[self countDays]];
    NSLog(@"days %@", [daysDict description]);
    UIColor *color;
    
    for(NSString *key in [daysDict allKeys]) {
        NSNumber *num = [daysDict objectForKey:key];
        
        if ([key isEqualToString:@"Tuesday"]) {
            color = [UIColor orangeColor];
        }else if ([key isEqualToString:@"Wednesday"]) {
            color = [UIColor greenColor];
        }else if([key isEqualToString:@"Thursday"]) {
            color = [UIColor blueColor];
        }else if([key isEqualToString:@"Friday"]) {
            color = [UIColor purpleColor];
        }else if([key isEqualToString:@"Monday"]) {
            color = [UIColor yellowColor];
        }
        
        [self setDiameter:[num intValue]];
        lWidth = 10.0;
        
        drawing = [[MLDrawing alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-(mdiameter/2), (self.view.frame.size.height/2)-(mdiameter/2), mdiameter, mdiameter) andDiameter:mdiameter andLineWidth:lWidth andColor:color];
        
        [self.view addSubview:drawing];
        
        [UIView animateWithDuration:2 animations:^(void) {
            drawing.transform = CGAffineTransformMakeScale(5, 5);
        }];
 
       [UIView animateWithDuration:2 animations:^(void) {
            drawing.alpha = 0;
        }];
    }
}

-(NSMutableDictionary*)countDays{
    NSMutableDictionary *daysOfWeekDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *daysOfWeekArray = [[NSMutableArray alloc] init];
    [daysOfWeekArray insertObject:[NSNumber numberWithInt:0] atIndex:0];
    [daysOfWeekArray addObject:@"color"];
    int num = 0;
    
    for (int i=0; i<[days count]; i++) {
        NSString *day = [days objectAtIndex:i];

        if ([day isEqualToString:@"Tuesday"]) {

            NSNumber *number = [daysOfWeekDict objectForKey:@"Tuesday"];
            num = [number intValue];
            [daysOfWeekDict setObject:[NSNumber numberWithInt:num+1] forKey:@"Tuesday"];

        }else if ([day isEqualToString:@"Wednesday"]) {
            
            NSNumber *number = [daysOfWeekDict objectForKey:@"Wednesday"];
            num = [number intValue];
            [daysOfWeekDict setObject:[NSNumber numberWithInt:num+1] forKey:@"Wednesday"];
 
        }else if ([day isEqualToString:@"Thursday"]) {
            
            NSNumber *number = [daysOfWeekDict objectForKey:@"Thursday"];
            num = [number intValue];
            [daysOfWeekDict setObject:[NSNumber numberWithInt:num+1] forKey:@"Thursday"];

        }else if ([day isEqualToString:@"Friday"]) {
            
            NSNumber *number = [daysOfWeekDict objectForKey:@"Friday"];
            num = [number intValue];
            [daysOfWeekDict setObject:[NSNumber numberWithInt:num+1] forKey:@"Friday"];

        }else{
            NSNumber *number = [daysOfWeekDict objectForKey:@"Monday"];
            num = [number intValue];
            [daysOfWeekDict setObject:[NSNumber numberWithInt:num+1] forKey:@"Monday"];
        }
        
        
    }
    
    for(NSString *key in [daysOfWeekDict allKeys]) {
      //  NSLog(@"%@",[daysOfWeekDict objectForKey:key]);
    }
    
    return daysOfWeekDict;
}

-(void)setDiameter:(double)dmeter{
    mdiameter = dmeter;
}

-(double)getDiameter{
    return mdiameter;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [days count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [days count];
}

#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellIdentifier"];
    }

    cell.detailTextLabel.text = [days objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [days objectAtIndex:section];
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