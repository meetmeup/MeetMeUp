//
//  NotificationsViewController.m
//  MeetMeUp
//
//  Created by Tanya on 9/2/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "NotificationsViewController.h"
#import "NotificationProxy.h"
#import "KeychainItemWrapper.h"

@interface NotificationsViewController ()<NotificationProxyDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *eventTitleArray;
    NSArray *eventLocationNameArray;
    NSArray *eventLatitudeArray;
    NSArray *eventLongtitudeArray;
    NSArray *eventStartArray;
    NSArray *eventEndArray;
    NSArray *eventInviterArray;
    NSArray *eventURLArray;
    NSArray *eventNotesArray;
    NSArray *eventUniqueIDArray;
    UIButton *acceptButton;
    UIButton *cancelButton;
}

@end

@implementation NotificationsViewController

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
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"notification"];
    
    //set navigation bar accessories
    [[[self navigationController] navigationBar] setTintColor:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]}];
    
    [self prefersStatusBarHidden];
    
    [self loadNotifications];
}

- (void) loadNotifications
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"loginData" accessGroup:nil];
    NSString *usernameString = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    
    NotificationProxy *notificationProxy = [[NotificationProxy alloc] init];
    [notificationProxy setDelegate:self];
    [notificationProxy getNotificationWithUsername:usernameString];
}

-(void)notificationProxyDidFinishLoad:(NSArray *)inviterArray event:(NSArray *)eventNameArray location:(NSArray *)eventLocationArray startDateArray:(NSArray *)startArray endDateArray:(NSArray *)endArray latitude:(NSArray *)latArray longtitude:(NSArray *)longArray uniqueID:(NSArray *)uniqueIDArray eventURL:(NSArray *)urlArray eventNotes:(NSArray *)notesArray
{
    eventInviterArray = inviterArray;
    eventTitleArray = eventNameArray;
    eventLocationNameArray = eventLocationArray;
    eventStartArray = startArray;
    eventEndArray = endArray;
    eventLatitudeArray = latArray;
    eventLongtitudeArray = longArray;
    eventUniqueIDArray = uniqueIDArray;
    eventURLArray = urlArray;
    eventNotesArray = notesArray;
    
    [self.tableView reloadData];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [eventInviterArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 9, 230, 20)];
        [cellTextLabel setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0/255.0f alpha:1.0f]];
        [cellTextLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:12.0f]];
        [cellTextLabel setTag:1];
        [cellTextLabel setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:cellTextLabel];
        
//        AsyncImageView *asyncImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(25, 6, 32, 32)];
//        [asyncImage.layer setCornerRadius:asyncImage.frame.size.height/2.0f];
//        [asyncImage setTag:2];
//        [cell.contentView addSubview:asyncImage];
        
        acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(210, cellTextLabel.frame.size.height + cellTextLabel.frame.origin.y + 10, 35, 22)];
        [acceptButton setImage:[UIImage imageNamed:@"Notifications_Unaccept.png"] forState:UIControlStateNormal];
        [acceptButton setImage:[UIImage imageNamed:@"Notifications_accepted.png"] forState:UIControlStateHighlighted];
        [acceptButton addTarget:self action:@selector(notificationAccepted) forControlEvents:UIControlEventTouchUpInside];
//        [acceptButton setShowsTouchWhenHighlighted:YES];
        [acceptButton setTag:2];
        [cell.contentView addSubview:acceptButton];
        
        cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(255, 45, 35, 22)];
        [cancelButton setImage:[UIImage imageNamed:@"Notifications_uncancel.png"] forState:UIControlStateNormal];
        [cancelButton setImage:[UIImage imageNamed:@"Notifications_canceled"] forState:UIControlStateHighlighted];
        [cancelButton addTarget:self action:@selector(notificationCanceled) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton setShowsTouchWhenHighlighted:YES];
        [cancelButton setTag:3];
        [cell.contentView addSubview:cancelButton];
        
    }
    
    NSString *cellTextString = [NSString stringWithFormat:@"%@ invited you to %@ at %@ on %@.", [eventInviterArray objectAtIndex:indexPath.row], [eventTitleArray objectAtIndex:indexPath.row], [eventLocationNameArray objectAtIndex:indexPath.row], [eventStartArray objectAtIndex:indexPath.row]];
    [(UILabel *) [cell.contentView viewWithTag:1] setText:cellTextString];
    [(UILabel *) [cell.contentView viewWithTag:1] setNumberOfLines:0];
    [(UILabel *) [cell.contentView viewWithTag:1] sizeToFit];

    [(UIButton *) [cell.contentView viewWithTag:2] setFrame:CGRectMake(210, [cell.contentView viewWithTag:1].frame.size.height + [cell.contentView viewWithTag:1].frame.origin.y + 10, 35, 22)];
    [(UIButton *) [cell.contentView viewWithTag:3] setFrame:CGRectMake(255, [cell.contentView viewWithTag:1].frame.size.height + [cell.contentView viewWithTag:1].frame.origin.y + 10, 35, 22)];
//    NSURL *url = [NSURL URLWithString:[inviteesImageSearchArray objectAtIndex:indexPath.row]];
//    [(AsyncImageView *) [cell.contentView viewWithTag:2] loadImageWithTypeFromURL:url contentMode:UIViewContentModeScaleAspectFill imageNameBG:nil];
    
    return cell;
}

- (void) notificationAccepted
{
    [acceptButton setImage:[UIImage imageNamed:@"Notifications_accepted.png"] forState:UIControlStateNormal];
}

- (void) notificationCanceled
{
    [cancelButton setImage:[UIImage imageNamed:@"Notifications_canceled"] forState:UIControlStateNormal];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 9, 230, 20)];
    [cellTextLabel setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0/255.0f alpha:1.0f]];
    [cellTextLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:12.0f]];
    [cellTextLabel setTag:1];
    [cellTextLabel setBackgroundColor:[UIColor redColor]];
    
    acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(210, cellTextLabel.frame.size.height + cellTextLabel.frame.origin.y + 10, 35, 22)];
    [acceptButton setImage:[UIImage imageNamed:@"Notifications_Unaccept.png"] forState:UIControlStateNormal];
    [acceptButton setImage:[UIImage imageNamed:@"Notifications_accepted.png"] forState:UIControlStateHighlighted];
    [acceptButton addTarget:self action:@selector(notificationAccepted) forControlEvents:UIControlEventTouchUpInside];
    [acceptButton setTag:2];
    
    NSString *cellTextString = [NSString stringWithFormat:@"%@ invited you to %@ at %@ on %@.", [eventInviterArray objectAtIndex:indexPath.row], [eventTitleArray objectAtIndex:indexPath.row], [eventLocationNameArray objectAtIndex:indexPath.row], [eventStartArray objectAtIndex:indexPath.row]];
    [cellTextLabel setText:cellTextString];
    [cellTextLabel setNumberOfLines:0];
    [cellTextLabel sizeToFit];
    
    [acceptButton setFrame:CGRectMake(210, cellTextLabel.frame.size.height + cellTextLabel.frame.origin.y + 10, 35, 22)];
    
    return acceptButton.frame.size.height + acceptButton.frame.origin.y + 9;
}


@end
