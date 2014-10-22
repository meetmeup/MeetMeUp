//
//  AddFriendsViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/17/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "AddFriendsProxy.h"
#import "WholescreenActivityIndicatorCreator.h"
#import "AsyncImageView.h"
#import "AlertViewCreator.h"
#import "KeychainItemWrapper.h"

#define MASKVIEW_Y (self.view.frame.size.height == 568.0f ? 0 : 35)


@interface AddFriendsViewController ()<UISearchBarDelegate, AddFriendsProxyDelegate>
{
    UIActivityIndicatorView *activityindicatorView;
    UIView *MaskView;
    NSString *friendUsername;
    NSString *friendPhotoURL;
    NSString *friendDevicetoken;
    UIButton *addFriendButton;
}

@end

@implementation AddFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{

    [self.searchBar becomeFirstResponder];
}

#define IS_IOS7 (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set delegates
    [self.searchBar setDelegate:self];
        
    //set navigation bar accessories
    [[[self navigationController] navigationBar] setTintColor:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]}];

    [self prefersStatusBarHidden];
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:[NSString stringWithFormat:@"Search friends %@", self.addFriendsBy]];
}

#warning in delegate method save username and userprofileurl in nsuserdefaults or keychain ***

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"loginData" accessGroup:nil];
    NSString *usernameString = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    
    if (![self.searchBar.text isEqualToString:usernameString])
    {
        [UIView animateWithDuration:0.2 animations:^{
            [MaskView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height + 1, self.view.frame.size.width, self.view.frame.size.height)];
        } completion:^(BOOL finished) {
            [MaskView removeFromSuperview];
        }];
        
        
        [self.searchBar resignFirstResponder];
        WholescreenActivityIndicatorCreator *activityIndicatorCreator = [[WholescreenActivityIndicatorCreator alloc] init];
        activityindicatorView = [[UIActivityIndicatorView alloc] init];
        activityindicatorView = [activityIndicatorCreator createActivityindicator];
        [self.view addSubview:activityindicatorView];
        [activityindicatorView startAnimating];
        
        if ([self.addFriendsBy isEqualToString:@"username"])
        {
            AddFriendsProxy *addFriendsProxy = [[AddFriendsProxy alloc] init];
            [addFriendsProxy setDelegate:self];
            [addFriendsProxy retrievedUserByUsingUsernameOrEmail:self.addFriendsBy withUserOrEmail:self.searchBar.text];
        }
        else if ([self.addFriendsBy  isEqualToString:@"facebook"])
        {
            
        }
        else if ([self.addFriendsBy isEqualToString:@"email"])
        {
            AddFriendsProxy *addFriendsProxy = [[AddFriendsProxy alloc] init];
            [addFriendsProxy setDelegate:self];
            [addFriendsProxy retrievedUserByUsingUsernameOrEmail:self.addFriendsBy withUserOrEmail:self.searchBar.text];
        }
    }
    else
    {
        AlertViewCreator *alertViewCreator = [[AlertViewCreator alloc] init];
        [self.view addSubview:[alertViewCreator createAlertViewWithViewController:self andText:@"You can't add yourself as a friend"]];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    
    UIImage *image = [UIImage imageNamed:@"AddEvent_SearchBarCancel.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UIView* view = self.searchBar.subviews[0];
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@"        " forState:UIControlStateNormal];
            [cancelButton setImage:image forState:UIControlStateNormal];
        }
    }
    
    return YES;
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)dismissVIewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)AddFriends:(AddFriendsProxy *)searchProxy retrievedSearchUser:(NSString *)username andUserProfile:(NSString *)profileURL andUserDeviceToken:(NSString *)deviceToken
{
    [activityindicatorView stopAnimating];
    
    NSLog(@"username: %@", username);
    NSLog(@"url: %@", profileURL);
    
    friendPhotoURL = profileURL;
    friendUsername = username;
    friendDevicetoken = deviceToken;
    
    MaskView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height + 1, self.view.frame.size.width, self.view.frame.size.height)];
    [MaskView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.9f]];
    
    UIImageView *userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MaskView.frame.origin.x + 50, self.view.frame.origin.y + 64 - MASKVIEW_Y, 220, 220)];
    [userImageView setImage:[UIImage imageNamed:@"SignUp_UserIcon.png"]];
    [MaskView addSubview:userImageView];
    
    if ([username isEqualToString:@"0"])
    {
        UILabel *userUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaskView.frame.origin.x + 0, self.view.frame.origin.y + 310 + MASKVIEW_Y, 320, 21)];
        [userUsernameLabel setText:@"User not found."];
        [userUsernameLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
        [userUsernameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
        [userUsernameLabel setTextAlignment:NSTextAlignmentCenter];
        [MaskView addSubview:userUsernameLabel];
    }
    else
    {
        AsyncImageView *userProfileImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(MaskView.frame.origin.x + 50, self.view.frame.origin.y + 64 - MASKVIEW_Y, 220, 220)];
        [userProfileImage loadImageWithTypeFromURL:[NSURL URLWithString:friendPhotoURL] contentMode:UIViewContentModeScaleAspectFill imageNameBG:nil];
        [userProfileImage setContentMode:UIViewContentModeScaleAspectFill];
        [userProfileImage.layer setCornerRadius:userProfileImage.frame.size.height/2.0f];
        [userProfileImage.layer setMasksToBounds:YES];
        [MaskView addSubview:userProfileImage];
        
        
        UILabel *userUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaskView.frame.origin.x + 0, self.view.frame.origin.y + 310 - MASKVIEW_Y, 320, 21)];
        [userUsernameLabel setText:username];
        [userUsernameLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
        [userUsernameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
        [userUsernameLabel setTextAlignment:NSTextAlignmentCenter];
        [MaskView addSubview:userUsernameLabel];
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        NSMutableArray *savedFriendsArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"USER_FRIENDS_ARRAY"]];
        
        //check if aready in added friends list
        BOOL alreadyAdded = [savedFriendsArray containsObject:friendUsername];
        
        if (alreadyAdded)
        {
            //is already you friend
            UILabel *isAlreadyFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y + 335 - MASKVIEW_Y, 320, 40)];
            [isAlreadyFriendLabel setText:@"is already your friend."];
            [isAlreadyFriendLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0f]];
            [isAlreadyFriendLabel setTextAlignment:NSTextAlignmentCenter];
            [isAlreadyFriendLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
            [MaskView addSubview:isAlreadyFriendLabel];
        }
        else if (!alreadyAdded)
        {
            addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(MaskView.frame.origin.x + 80, self.view.frame.origin.y + 349 - MASKVIEW_Y, 160, 40)];
            [addFriendButton setUserInteractionEnabled:YES];
            [addFriendButton setTitle:@"" forState:UIControlStateNormal];
            [addFriendButton setImage:[UIImage imageNamed:@"AddFriends_AddFriendButton.png"] forState:UIControlStateNormal];
            [addFriendButton addTarget:self action:@selector(addFriendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [addFriendButton setShowsTouchWhenHighlighted:YES];
            [MaskView addSubview:addFriendButton];
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [MaskView setFrame:CGRectMake(0, 90, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [self.view addSubview:MaskView];
    }];
}

#pragma mark - addfriend button clicked
- (void) addFriendButtonClicked
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *savedFriendsArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"USER_FRIENDS_ARRAY"]];
    NSMutableArray *savedFriendPhotoArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"USER_PHOTO_ARRAY"]];
    NSMutableArray *savedDeviceTokenArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"USER_DEVICE_TOKEN_ARRAY"]];

    
    [savedFriendsArray addObject:friendUsername];
    [savedFriendPhotoArray addObject:friendPhotoURL];
    [savedDeviceTokenArray addObject:friendDevicetoken];
    
    [[NSUserDefaults standardUserDefaults] setObject:savedFriendsArray forKey:@"USER_FRIENDS_ARRAY"];
    [[NSUserDefaults standardUserDefaults] setObject:savedFriendPhotoArray forKey:@"USER_PHOTO_ARRAY"];
    [[NSUserDefaults standardUserDefaults] setObject:savedDeviceTokenArray forKey:@"USER_DEVICE_TOKEN_ARRAY"];
    [userDefaults synchronize];
    
    [addFriendButton setImage:[UIImage imageNamed:@"AddFriends_AddFriendButtonClicked.png"] forState:UIControlStateNormal];
    [addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addFriendButton setUserInteractionEnabled:NO];
}



@end
