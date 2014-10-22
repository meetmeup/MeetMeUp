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
#import "AddFriendsViewController.h"
#import "ReachabilityCheckHelper.h"
#import "AlertViewCreator.h"
#import "AlertViewStillCreator.h"
#import "NotificationsViewController.h"
#import "AsyncImageView.h"
#import "EventListViewController.h"

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


@interface MainViewController ()<SWTableViewCellDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    VRGCalendarView *calendar;
    NSDate *currentMonth;
    NSMutableArray *datesInMonthArray;
    UITableView *eventTableView;
}

@end

@implementation MainViewController

@synthesize notificationsButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSInteger notification = [[NSUserDefaults standardUserDefaults] integerForKey:@"notification"];
    if (notification == 0)
    {
        [notificationsButton setImage:[UIImage imageNamed:@"Main_Notifications.png"] forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Main_BG.jpg"]]];
    
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
    
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 35, 24, 24)];
    [settingsButton setImage:[UIImage imageNamed:@"Main_Settings.png"] forState:UIControlStateNormal];
    [settingsButton setShowsTouchWhenHighlighted:YES];
    [self.view addSubview:settingsButton];
    
    UIButton *addFriendsButton = [[UIButton alloc] initWithFrame:CGRectMake(26, 35, 24, 24)];
    [addFriendsButton setImage:[UIImage imageNamed:@"Main_AddFriends.png"] forState:UIControlStateNormal];
    [addFriendsButton setShowsTouchWhenHighlighted:YES];
    [addFriendsButton addTarget:self action:@selector(addfriendsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addFriendsButton];
    
    notificationsButton = [[UIButton alloc] initWithFrame:CGRectMake(145, 35, 24, 24)];
    NSInteger notification = [[NSUserDefaults standardUserDefaults] integerForKey:@"notification"];
    
    if (notification > 0)
    {
        [notificationsButton setImage:[UIImage imageNamed:@"Main_NotificationsWithDot.png"] forState:UIControlStateNormal];
    }
    else
    {
        [notificationsButton setImage:[UIImage imageNamed:@"Main_Notifications.png"] forState:UIControlStateNormal];
    }
    
    [notificationsButton setShowsTouchWhenHighlighted:YES];
    [notificationsButton addTarget:self action:@selector(notificationsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notificationsButton];
    
    UIButton *previousMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CURRENT_MONTH_LABEL_Y, SIDE_BUTTON_WIDTH, SIDE_BUTTON_HEIGHT)];
    [previousMonthButton setTitle:@"" forState:UIControlStateNormal];
    [previousMonthButton setBackgroundColor:[UIColor clearColor]];
    [previousMonthButton addTarget:self action:@selector(previousMonthButtonClicked) forControlEvents:UIControlEventTouchUpInside];
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
    
    ReachabilityCheckHelper *reachabilityChecker = [[ReachabilityCheckHelper alloc] init];
    
    if (![reachabilityChecker connected])
    {
        //alertview if no internet connection
        AlertViewStillCreator *alertViewCreator = [[AlertViewStillCreator alloc] init];
        [self.view addSubview:[alertViewCreator createAlertViewWithViewController:self andText:@"Please connect to the internet."]];
    }
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
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, 100, 40)];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [dateLabel setText:[NSString stringWithFormat:@"%@", [datesInMonthArray objectAtIndex:indexPath.row]]];
    [dateLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    [dateLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:43.0f]];
    [sectionView addSubview:dateLabel];
    
    UILabel *eventTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 13.5, SELF_WIDTH - 150, 30)];
    [eventTitleLabel setText:@"There are 3 events"];
    [eventTitleLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    [eventTitleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17.0f]];
    [sectionView addSubview:eventTitleLabel];
    
    UILabel *dateDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 33, SELF_WIDTH - 150, 25)];
    [dateDetailLabel setText:@"Friday, 22nd October 2014"];
    [dateDetailLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    [dateDetailLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:12.0f]];
    [sectionView addSubview:dateDetailLabel];
    
    UIButton *moreInfoButton = [[UIButton alloc] initWithFrame:CGRectMake(eventTitleLabel.frame.origin.x + eventTitleLabel.frame.size.width + 9, eventTitleLabel.frame.origin.y + 10, 24, 24)];
    [moreInfoButton setTag:indexPath.row];
    [moreInfoButton setImage:[UIImage imageNamed:@"Main_InfoButton.png"] forState:UIControlStateNormal];
    [moreInfoButton setSelected:YES];
    [moreInfoButton addTarget:self action:@selector(moreInfoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *avatarArray = [NSArray arrayWithObjects:@"http://media.gizmodo.co.uk/wp-content/uploads/2013/09/bill-gates-mistake.jpg", @"http://i2.cdn.turner.com/cnn/dam/assets/121003065321-steve-jobs-smiling-story-top.jpg", @"https://pbs.twimg.com/profile_images/2463814324/s388hotz4y325sky2mev_400x400.jpeg", @"http://i.dailymail.co.uk/i/pix/2014/05/25/article-2638617-1E338DB700000578-671_634x844.jpg", @"Main_MoreInvitees.png", nil];
    
    for (int i = 0; i < [avatarArray count]; i++)
    {
        AsyncImageView *userProfileImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(50*(i+1), 65, 30, 30)];
        [userProfileImage loadImageWithTypeFromURL:[NSURL URLWithString:[avatarArray objectAtIndex:i]] contentMode:UIViewContentModeScaleAspectFill imageNameBG:nil];
        [userProfileImage setContentMode:UIViewContentModeScaleAspectFill];
        [userProfileImage.layer setCornerRadius:userProfileImage.frame.size.height/2.0f];
        [userProfileImage.layer setMasksToBounds:YES];
        [sectionView addSubview:userProfileImage];
    }
    
    UIButton *sectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sectionView.frame.size.width, sectionView.frame.size.height)];
    [sectionButton setTag:indexPath.row];
    [sectionButton addTarget:self action:@selector(sectionClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sectionButton setBackgroundColor:[UIColor clearColor]];
    [sectionView addSubview:sectionButton];
    
    [cell.contentView addSubview:sectionView];
    [cell.contentView addSubview:moreInfoButton];
    
    return cell;
}

#pragma mark - more info clicked
- (void) moreInfoButtonClicked:(UIButton *)sender
{
    EventListViewController * eventViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventlist"];
//    [self presentViewController:eventViewController animated:YES completion:nil];
    [self.navigationController pushViewController:eventViewController animated:YES];

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
    ReachabilityCheckHelper *reachabilityChecker = [[ReachabilityCheckHelper alloc] init];
    
    
    if (![reachabilityChecker connected])
    {
        //do nothing..
    }
    else
    {
        //add event button clicked
        if (index == 0)
        {
            AddEventViewController *addEventViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addevent"];
            [self presentViewController:addEventViewController animated:YES completion:^{
                
            }];
        }
    }
}

#pragma mark - add friends clicked
- (void) addfriendsButtonClicked
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Find your friends by" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Username", @"Facebook", @"Email", nil];
    [actionSheet showInView:self.view];
}

- (void) notificationsButtonClicked
{
    NotificationsViewController *notificationView = [self.storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notificationView.prevViewController = self;
    [self presentViewController:notificationView animated:YES completion:nil];
}

-(void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ReachabilityCheckHelper *reachability = [[ReachabilityCheckHelper alloc] init];
    
    if (![reachability connected])
    {
        //do nothing..
    }
    else
    {
        if (buttonIndex == 0)
        {
            AddFriendsViewController *addFriendsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addfriends"];
            addFriendsViewController.addFriendsBy = @"username";
            [self presentViewController:addFriendsViewController animated:YES completion:nil];
        }
        else if (buttonIndex == 1)
        {
            AddFriendsViewController *addFriendsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addfriends"];
            addFriendsViewController.addFriendsBy = @"facebook";
            [self presentViewController:addFriendsViewController animated:YES completion:^{
                
            }];
        }
        else if (buttonIndex == 2)
        {
            AddFriendsViewController *addFriendsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addfriends"];
            addFriendsViewController.addFriendsBy = @"email";
            [self presentViewController:addFriendsViewController animated:YES completion:^{
                
            }];
        }
    }
}

- (void) invitationCancelButtonClicked
{
    UIView *topView = [[self.view subviews] lastObject];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [topView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [topView removeFromSuperview];
    }];
    
    NSInteger notification = [[NSUserDefaults standardUserDefaults] integerForKey:@"notification"];
    notification += 1;
    [[NSUserDefaults standardUserDefaults] setInteger:notification forKey:@"notification"];
    
    if (notification > 0)
    {
        [notificationsButton setImage:[UIImage imageNamed:@"Main_NotificationsWithDot.png"] forState:UIControlStateNormal];
    }
}

- (void) invitationAcceptButtonClicked
{
    UIView *topView = [[self.view subviews] lastObject];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [topView setAlpha:0.0];
    } completion:^(BOOL finished) {
        [topView removeFromSuperview];
    }];
}



@end
