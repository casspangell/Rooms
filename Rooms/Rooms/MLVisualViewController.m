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
    NSMutableArray *colors;
    int counter;
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
    self.view.backgroundColor = [UIColor blackColor];
    self.stashTable.delegate = self;
    self.stashTable.dataSource = self;
    
    colors = [NSMutableArray array];
    counter = 0;
    
    float INCREMENT = 0.075;
    for (float hue = 0.0; hue < 1.0; hue += INCREMENT) {
        UIColor *color = [UIColor colorWithHue:hue
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [colors addObject:color];
    }
    
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
    [NSTimer scheduledTimerWithTimeInterval:4
                                     target:self
                                   selector:@selector(createDrawing)
                                   userInfo:nil
                                    repeats:YES];
    
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


//Draws different colored circles based on a count from dictionary
-(void)createDrawing {
 
    NSMutableDictionary *daysDict = [[NSMutableDictionary alloc] initWithDictionary:[self countDays]];
    NSLog(@"days %@", [daysDict description]);
    NSArray *sortedArr = [self sortKeysOnTheBasisOfCount:daysDict];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    UIColor *color;
    int count = 0;
    counter ++;
    
    for (int i=0; i<[sortedArr count]; i++) {
      
        NSString *day = [sortedArr objectAtIndex:i];
        NSNumber *num = [daysDict valueForKey:[sortedArr objectAtIndex:i]];

        [arr addObject:num];
        count ++;
        
        if (counter > [colors count]-1) {
            counter = 0;
        }
        
        NSLog(@"count %d", counter);
       
        if([day isEqualToString:@"Monday"]) {
            color = [colors objectAtIndex:counter];

        }else if ([day isEqualToString:@"Tuesday"]) {

            color = [colors objectAtIndex:counter];

        }else if ([day isEqualToString:@"Wednesday"]) {
            color = [colors objectAtIndex:counter];
  
        }else if([day isEqualToString:@"Thursday"]) {
            color = [colors objectAtIndex:counter];
        
        }else if([day isEqualToString:@"Friday"]) {
            color = [colors objectAtIndex:counter];

        }

        counter++;
        [self setDiameter:[num intValue]];
        lWidth = 40.0;
        
        drawing = [[MLDrawing alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-(mdiameter/2), (self.view.frame.size.height/2)-(mdiameter/2), mdiameter, mdiameter) andDiameter:mdiameter andLineWidth:lWidth andColor:color];
        drawing.alpha = 0;
        
        pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        [self.view addGestureRecognizer:swipeGesture];
        [self.view addGestureRecognizer:pinchGesture];
        [self.view addGestureRecognizer:singleTapGesture];
        [self.view addSubview:drawing];
        
        drawing.transform = CGAffineTransformMakeScale(.25, .25);
        [UIView animateWithDuration:2*count animations:^(void) {
            drawing.alpha = 1;
            drawing.transform = CGAffineTransformMakeScale(1, 1);
        }];

       [UIView animateWithDuration:4 animations:^(void) {
            drawing.contentMode = UIViewContentModeScaleAspectFit;
        }];
    }
    
}

-(NSArray*) sortKeysOnTheBasisOfCount:(NSDictionary*)dict{

    NSArray * sortArray = [dict keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        
        //First value is greather than the second.
        if ([obj1 intValue] > [obj2 intValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        //First value is less than the second.
        if ([obj1 intValue] < [obj2 intValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        //Both the values are same
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSArray* reversedArray = [[sortArray reverseObjectEnumerator] allObjects];
  
    return reversedArray;
}

-(NSMutableDictionary*)countDays{
    NSMutableDictionary *daysOfWeekDict = [[NSMutableDictionary alloc] init];
    NSMutableArray *daysOfWeekArray = [[NSMutableArray alloc] init];
    [daysOfWeekArray insertObject:[NSNumber numberWithInt:0] atIndex:0];
    //[daysOfWeekArray addObject:@"color"];
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

#pragma mark - Gestures
-(void)handlePinch:(UIPinchGestureRecognizer*)recognizer {
    
    [UIView animateWithDuration:1 animations:^(void) {
        CGAffineTransform transform = CGAffineTransformMakeScale(recognizer.scale, recognizer.scale);
        self.view.transform = transform;
    }];
}

- (void)handleSwipe:(UISwipeGestureRecognizer*)swipe{
    [self performSegueWithIdentifier:@"homeSegue" sender:self];
}

-(void)handleSingleTap:(UISwipeGestureRecognizer*)tap{

    //nothing yet
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
