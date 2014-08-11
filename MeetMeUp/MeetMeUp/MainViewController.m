//
//  MainViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/7/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "MainViewController.h"

#define SIDE_BUTTON_HEIGHT 58
#define SIDE_BUTTON_WIDTH 160

#define CURRENT_MONTH_LABEL_Y 75

#define ADD_EVENT_BUTTON_HEIGHT 40

#define TABLE_VIEW_VIEW_HEIGHT 300

@interface MainViewController ()
{
    VRGCalendarView *calendar;
}

@end

@implementation MainViewController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //whole scrollView set
    [self.wholeScreenScrollView setContentSize:CGSizeMake(320, 1000)];
    [self.wholeScreenScrollView setBounces:YES];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Main_BG.jpg"]]];
    
    //set translucent navigation bar
    [self.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    
    //set settings bar button image
    UIImage *settingsImage = [[UIImage imageNamed:@"Main_SettingsIcon2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.SettingsBarButtonItem setImage:settingsImage];
    
    //tell app delegate user is signed in
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //create AddEvent Button
    UIButton *addEventButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 358, self.wholeScreenScrollView.frame.size.width, ADD_EVENT_BUTTON_HEIGHT)];
//    [addEventButton setBackgroundColor:[UIColor whiteColor]];
    [addEventButton setImage:[UIImage imageNamed:@"Main_AddEventButton.png"] forState:UIControlStateNormal];
    [addEventButton addTarget:self action:@selector(addEventButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [addEventButton setHighlighted:NO];
    [self.wholeScreenScrollView addSubview:addEventButton];
    
    //create calendar
    calendar = [[VRGCalendarView alloc] init];
    [calendar setFrame:CGRectMake(0, 0, self.view.frame.size.width, calendar.bounds.size.height)];
    calendar.delegate = self;
    calendar.layer.masksToBounds = NO;
    calendar.layer.cornerRadius = 8; // if you like rounded corners
    calendar.layer.shadowOffset = CGSizeMake(5, 5);
    calendar.layer.shadowRadius = 5;
    calendar.layer.shadowOpacity = 0.5;
    [self.wholeScreenScrollView addSubview:calendar];
    
    UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CURRENT_MONTH_LABEL_Y, SIDE_BUTTON_WIDTH, SIDE_BUTTON_HEIGHT)];
    [nextMonthButton setTitle:@"" forState:UIControlStateNormal];
    [nextMonthButton setBackgroundColor:[UIColor clearColor]];
    [nextMonthButton addTarget:self action:@selector(nextMonthButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.wholeScreenScrollView addSubview:nextMonthButton];
    
    UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(320-SIDE_BUTTON_WIDTH, CURRENT_MONTH_LABEL_Y, SIDE_BUTTON_WIDTH, SIDE_BUTTON_HEIGHT)];
    [previousMonthButton setTitle:@"" forState:UIControlStateNormal];
    [previousMonthButton setBackgroundColor:[UIColor clearColor]];
    [previousMonthButton addTarget:self action:@selector(previousMonthButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.wholeScreenScrollView addSubview:previousMonthButton];
    
    //create tableView view
    UIView *tableviewView = [[UIView alloc] initWithFrame:CGRectMake(0, addEventButton.frame.size.height + addEventButton.frame.origin.y, self.view.frame.size.width, TABLE_VIEW_VIEW_HEIGHT)];
    [self.wholeScreenScrollView addSubview:tableviewView];
}

- (void)nextMonthButtonClicked
{
    [calendar showNextMonth];
}

- (void)previousMonthButtonClicked
{
    [calendar showPreviousMonth];
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [currentCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    int currentMonth = [components month];
    
    if (month == currentMonth)
    {
        NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
        [calendarView markDates:dates];
    }
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSLog(@"Selected date = %@",date);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)logoutClicked:(id)sender
{
    //tell app delegate user in not logged in
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [FBSession.activeSession closeAndClearTokenInformation];
        [[FBSession activeSession] close];
        
        [self.signUpViewController dismissViewControllerAnimated:YES completion:^{
            
        }];

    }];
}

- (IBAction)settingsButtonClicked:(id)sender
{
    
}
@end
