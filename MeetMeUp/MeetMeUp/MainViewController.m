//
//  MainViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/7/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "MainViewController.h"
#import "ImageResizer.h"
#import "AppDelegate.h"
#import "SWTableViewCell.h"
#import "AddEventViewController.h"

#define SIDE_BUTTON_HEIGHT 58
#define SIDE_BUTTON_WIDTH 160

#define CURRENT_MONTH_LABEL_Y 70

#define ADD_EVENT_BUTTON_HEIGHT 40

#define TABLE_VIEW_VIEW_HEIGHT 300

#define SELF_WIDTH self.view.frame.size.width
#define SELF_HEIGHT self.view.frame.size.height
#define SELF_X self.view.frame.origin.x
#define SELF_Y self.view.frame.origin.y

#define   IsIphone5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface MainViewController ()<SWTableViewCellDelegate>
{
    VRGCalendarView *calendar;
    NSDate *currentMonth;
    NSMutableArray *datesInMonthArray;
    UITableView *eventTableView;
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

    CGFloat height;
    if (IsIphone5)
    {
        height = 210;
    }
    else
    {
        height = 143;
    }

    eventTableView = [[UITableView alloc] initWithFrame:CGRectMake(SELF_X, 360, SELF_WIDTH, height)];
    [eventTableView setUserInteractionEnabled:YES];
    [eventTableView setSectionHeaderHeight:150.0f];
    [eventTableView setDelegate:self];
    [eventTableView setDataSource:self];
    [eventTableView setSeparatorColor:[UIColor colorWithHexString:@"0xcfd4d8"]];
    [eventTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 320 , 2)];
    [self.view addSubview:eventTableView];
    
    //create calendar
    calendar = [[VRGCalendarView alloc] init];
    [calendar setFrame:CGRectMake(0, 0, self.view.frame.size.width, calendar.bounds.size.height)];
    calendar.delegate = self;
    calendar.layer.masksToBounds = NO;
    calendar.layer.cornerRadius = 8;
    calendar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    calendar.layer.shadowRadius = 5;
    calendar.layer.shadowOpacity = 0.5;
    [self.view addSubview:calendar];
    
    UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CURRENT_MONTH_LABEL_Y, SIDE_BUTTON_WIDTH, SIDE_BUTTON_HEIGHT)];
    [previousMonthButton setTitle:@"" forState:UIControlStateNormal];
    [previousMonthButton setBackgroundColor:[UIColor clearColor]];
    [previousMonthButton addTarget:self action:@selector(nextMonthButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousMonthButton];
    
    UIButton *nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(320-SIDE_BUTTON_WIDTH, CURRENT_MONTH_LABEL_Y, SIDE_BUTTON_WIDTH, SIDE_BUTTON_HEIGHT)];
    [nextMonthButton setTitle:@"" forState:UIControlStateNormal];
    [nextMonthButton setBackgroundColor:[UIColor clearColor]];
    [nextMonthButton addTarget:self action:@selector(nextMonthButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextMonthButton];
    
    //get date object index
    NSDate *today = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
    NSInteger day = [components day];
    
    //get dates to display in tableView
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange days = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:today];
    datesInMonthArray = [[NSMutableArray alloc] init];
    for (NSUInteger i = days.location; i < days.location + days.length; i++) {
        [datesInMonthArray addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    
    //tableview scroll to date
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:day-1 inSection:0];
    [eventTableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    [eventTableView reloadData];
}

- (void)nextMonthButtonClicked
{
    [calendar showNextMonth];
    
    //update tableview month dates
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange days = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:calendar.currentMonth];
    datesInMonthArray = [[NSMutableArray alloc] init];
    for (NSUInteger i = days.location; i < days.location + days.length; i++) {
        [datesInMonthArray addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    
    [eventTableView reloadData];
}

- (void)previousMonthButtonClicked
{
    [calendar showPreviousMonth];
    
    //update tableview month dates
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange days = [gregorian rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:calendar.currentMonth];
    datesInMonthArray = [[NSMutableArray alloc] init];
    for (NSUInteger i = days.location; i < days.location + days.length; i++) {
        [datesInMonthArray addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    
    [eventTableView reloadData];
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
    //get date object index
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger day = [components day];
    NSLog(@"day: %lu", (long)day-1);
    
    //tableview scroll to date
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:day-1 inSection:0];
    [eventTableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
    [eventTableView reloadData];
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

#pragma mark - secttings button clicked
- (IBAction)settingsButtonClicked:(id)sender
{
    
}

#pragma mark - number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datesInMonthArray count];
}

#pragma mark - cell for row at index
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
//
//    if (cell == nil) {
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//    }
//
//    [cell setBackgroundColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
//
//    UILabel *userDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, SELF_WIDTH-65, 25)];
//    [userDetailLabel setText:@"username commented \"i will e going there too lkwjelkjerlkjwelrkj \""];
//    [userDetailLabel setTextColor:[UIColor whiteColor]];
//    [userDetailLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:10.0f]];
//    [cell.contentView addSubview:userDetailLabel];
//    
//    NSArray *avatarArray = [NSArray arrayWithObjects:@"avatar1.jpg", @"avatar2.jpg", @"avatar3.jpg", @"avatar4.jpg", nil];
//    ImageResizer *imageResizer = [[ImageResizer alloc] init];
//    UIImage *avatarImage = [imageResizer imageWithImage:[UIImage imageNamed:[avatarArray objectAtIndex:indexPath.row]] scaledToSize:CGSizeMake(50, 50)];
//    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 25, 25)];
//    [avatarImageView setImage:avatarImage];
//    [avatarImageView.layer setCornerRadius:avatarImageView.frame.size.height/2];
//    avatarImageView.clipsToBounds = YES;
//    [cell.contentView addSubview:avatarImageView];
    
    //Create swipe
    
    static NSString *cellIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.leftUtilityButtons = [self leftButtons];
        cell.delegate = self;
    }
    
    //Create cell UI
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(SELF_X, SELF_Y, SELF_WIDTH, 110)];
    [sectionView setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *slider = [UIImage imageNamed:@"Main_SlideIcon.png"];
    UIImageView *sectionSliderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 45, slider.size.width, slider.size.height)];
    [sectionSliderImageView setImage:slider];
    [sectionView addSubview:sectionSliderImageView];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 100, 40)];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [dateLabel setText:[NSString stringWithFormat:@"%@", [datesInMonthArray objectAtIndex:indexPath.row]]];
    [dateLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    [dateLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:45.0f]];
    [sectionView addSubview:dateLabel];
    
    UILabel *eventTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(109, 13.5, SELF_WIDTH - 120, 30)];
    [eventTitleLabel setText:@"Meeting with mink nat mookklvklvlkvlkjdflkvjdlkfjvlkdfjv"];
    [eventTitleLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    [eventTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17.0f]];
    [sectionView addSubview:eventTitleLabel];
    
    UILabel *dateDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(109, 33, SELF_WIDTH-120, 25)];
    [dateDetailLabel setText:@"Friday, 2:00 PM"];
    [dateDetailLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    [dateDetailLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:12.0f]];
    [sectionView addSubview:dateDetailLabel];
    
    NSArray *avatarArray = [NSArray arrayWithObjects:@"avatar1.jpg", @"avatar2.jpg", @"avatar3.jpg", @"avatar4.jpg", @"Main_InviteIcon.png", nil];
    
    for (int i = 0; i < [avatarArray count]; i++)
    {
        ImageResizer *imageResizer = [[ImageResizer alloc] init];
        UIImage *avatarImage = [imageResizer imageWithImage:[UIImage imageNamed:[avatarArray objectAtIndex:i]] scaledToSize:CGSizeMake(70, 70)];
        UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50*(i+1), 65, 30, 30)];
        [avatarImageView setImage:avatarImage];
        [avatarImageView.layer setCornerRadius:avatarImageView.frame.size.height/2];
        avatarImageView.clipsToBounds = YES;
        [sectionView addSubview:avatarImageView];
    }
    
    UIButton *sectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sectionView.frame.size.width, sectionView.frame.size.height)];
    [sectionButton setTag:indexPath.row];
    [sectionButton addTarget:self action:@selector(sectionClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sectionButton setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:sectionButton];
    
    [cell.contentView addSubview:sectionView];
    
    return cell;
}

#pragma mark - number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}


#pragma mark - section clicked
- (void) sectionClicked:(id)sender
{
    UIButton *sectionClickedButton = (UIButton *)sender;
    NSLog(@"clicked %lu", (long)sectionClickedButton.tag);
}

#pragma mark - left utility
- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0]
                                                icon:[UIImage imageNamed:@"Main_AddEvent.png"]];

    
    return leftUtilityButtons;
}

#pragma mark - left utility event clicked
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    //add event button clicked
    if (index == 0)
    {
        AddEventViewController *addEventViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addevent"];
        [self presentViewController:addEventViewController animated:YES completion:^{
            
        }];
    }
}


@end
