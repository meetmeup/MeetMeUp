//
//  MainViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/7/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "MainViewController.h"
#import "ImageResizer.h"

#define SIDE_BUTTON_HEIGHT 58
#define SIDE_BUTTON_WIDTH 160

#define CURRENT_MONTH_LABEL_Y 75

#define ADD_EVENT_BUTTON_HEIGHT 40

#define TABLE_VIEW_VIEW_HEIGHT 300

#define SELF_WIDTH self.view.frame.size.width
#define SELF_HEIGHT self.view.frame.size.height
#define SELF_X self.view.frame.origin.x
#define SELF_Y self.view.frame.origin.y

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
    
    UITableView *eventTableView = [[UITableView alloc] initWithFrame:CGRectMake(SELF_X, addEventButton.frame.size.height+addEventButton.frame.origin.y, SELF_WIDTH, 600)];
    [eventTableView setUserInteractionEnabled:YES];
    [eventTableView setSectionHeaderHeight:150.0f];
    [eventTableView setDelegate:self];
    [eventTableView setDataSource:self];
    [eventTableView setSeparatorColor:[UIColor colorWithHexString:@"0xcfd4d8"]];
    [eventTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 320 , 1)];
    [self.wholeScreenScrollView addSubview:eventTableView];
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

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date
{
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

- (void) addEventButtonClicked
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark - cell for row at index
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];

    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    [cell setBackgroundColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];

    UILabel *userDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, SELF_WIDTH-65, 25)];
    [userDetailLabel setText:@"username commented \"i will e going there too lkwjelkjerlkjwelrkj \""];
    //    [dateDetailLabel setBackgroundColor:[UIColor redColor]];
    [userDetailLabel setTextColor:[UIColor whiteColor]];
    [userDetailLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:10.0f]];
    [cell.contentView addSubview:userDetailLabel];
    
    NSArray *avatarArray = [NSArray arrayWithObjects:@"avatar1.jpg", @"avatar2.jpg", @"avatar3.jpg", @"avatar4.jpg", nil];
    ImageResizer *imageResizer = [[ImageResizer alloc] init];
    UIImage *avatarImage = [imageResizer imageWithImage:[UIImage imageNamed:[avatarArray objectAtIndex:indexPath.row]] scaledToSize:CGSizeMake(50, 50)];
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 25, 25)];
    [avatarImageView setImage:avatarImage];
    [avatarImageView.layer setCornerRadius:avatarImageView.frame.size.height/2];
    avatarImageView.clipsToBounds = YES;
    [cell.contentView addSubview:avatarImageView];
    
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(SELF_X, SELF_Y, SELF_WIDTH, 110)];
    [sectionView setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *slider = [UIImage imageNamed:@"Main_SlideIcon.png"];
    UIImageView *sectionSliderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 26, slider.size.width, slider.size.height)];
    [sectionSliderImageView setImage:slider];
    [sectionView addSubview:sectionSliderImageView];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 15, sectionView.frame.size.width, 40)];
//    [dateLabel setBackgroundColor:[UIColor redColor]];
    [dateLabel setText:@"24"];
    [dateLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    [dateLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:45.0f]];
    [sectionView addSubview:dateLabel];
    
    UILabel *eventTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(109, 13.5, SELF_WIDTH - 120, 30)];
//    [eventTitleLabel setBackgroundColor:[UIColor redColor]];
    [eventTitleLabel setText:@"Meeting with mink nat mookklvklvlkvlkjdflkvjdlkfjvlkdfjv"];
    [eventTitleLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    [eventTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17.0f]];
    [sectionView addSubview:eventTitleLabel];
    
    UILabel *dateDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(109, 33, SELF_WIDTH-120, 25)];
    [dateDetailLabel setText:@"Friday, 2:00 PM"];
//    [dateDetailLabel setBackgroundColor:[UIColor redColor]];
    [dateDetailLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    [dateDetailLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:12.0f]];
    [sectionView addSubview:dateDetailLabel];
    
    NSArray *avatarArray = [NSArray arrayWithObjects:@"avatar1.jpg", @"avatar2.jpg", @"avatar3.jpg", @"avatar4.jpg", @"Main_InviteIcon.png", nil];

    for (int i = 0; i < [avatarArray count]; i++)
    {
        ImageResizer *imageResizer = [[ImageResizer alloc] init];
        UIImage *avatarImage = [imageResizer imageWithImage:[UIImage imageNamed:[avatarArray objectAtIndex:i]] scaledToSize:CGSizeMake(70, 70)];
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(44*(i+1), 65, 30, 30)];
        [avatarImageView setImage:avatarImage];
        [avatarImageView.layer setCornerRadius:avatarImageView.frame.size.height/2];
        avatarImageView.clipsToBounds = YES;
        [sectionView addSubview:avatarImageView];
    }
    
    UIButton *sectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sectionView.frame.size.width, sectionView.frame.size.height)];
    [sectionButton setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:sectionButton];
    
    return sectionView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(SELF_X, SELF_Y, SELF_WIDTH, 2)];
    [sectionFooterView setBackgroundColor:[UIColor colorWithHexString:@"0xcfd4d8"]];
    return sectionFooterView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

@end
