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

@interface AddFriendsViewController ()<UISearchBarDelegate, AddFriendsProxyDelegate>
{
    UIActivityIndicatorView *activityindicatorView;
    UIView *MaskView;
    NSString *friendUsername;
    NSString *friendPhotoURL;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set delegates
    [self.searchBar setDelegate:self];
    
    NSLog(@"by what: %@", self.addFriendsBy);
    
    //set navigation bar accessories
    [[[self navigationController] navigationBar] setTintColor:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]}];
    
    
    UIImage *image = [UIImage imageNamed:@"AddEvent_SearchBarCancel.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setImage:image];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"        "];
    
    [self prefersStatusBarHidden];
    [self.searchBar setDelegate:self];
    [self.searchBar becomeFirstResponder];
    [self.searchBar setPlaceholder:[NSString stringWithFormat:@"Search friends %@", self.addFriendsBy]];
}

#warning in delegate method save username and userprofileurl in nsuserdefaults or keychain ***

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
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

-(void)AddFriends:(AddFriendsProxy *)searchProxy retrievedSearchUser:(NSString *)username andUserProfile:(NSString *)profileURL
{
    [activityindicatorView stopAnimating];
    
    NSLog(@"username: %@", username);
    NSLog(@"url: %@", profileURL);
    
    friendPhotoURL = profileURL;
    friendUsername = username;
    
    MaskView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height + 1, self.view.frame.size.width, self.view.frame.size.height)];
    [MaskView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.9f]];
    
    NSURL *imageURL = [NSURL URLWithString:profileURL];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    if ([imageData length] == 0)
    {
        UIImage *image = [UIImage imageNamed:@"AddFriends_AvatarIcon.png"];
        UIImageView *userProfileImage = [[UIImageView alloc] initWithFrame:CGRectMake(MaskView.frame.origin.x + 50, self.view.frame.origin.y + 64, 220, 220)];
        [userProfileImage setImage:image];
        [userProfileImage setContentMode:UIViewContentModeScaleAspectFit];
        [MaskView addSubview:userProfileImage];
    }
    else
    {
        UIImageView *userProfileImage = [[UIImageView alloc] initWithFrame:CGRectMake(MaskView.frame.origin.x + 50, self.view.frame.origin.y + 64, 220, 220)];
        [userProfileImage setImage:[UIImage imageWithData:imageData]];
        [userProfileImage setContentMode:UIViewContentModeScaleAspectFit];
        [userProfileImage.layer setCornerRadius:userProfileImage.frame.size.height/2.0f];
        [userProfileImage.layer setMasksToBounds:YES];
        [MaskView addSubview:userProfileImage];
    }
    
    UILabel *userUsernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaskView.frame.origin.x + 0, self.view.frame.origin.y + 310, 320, 21)];
    [userUsernameLabel setText:username];
    [userUsernameLabel setTextColor:[UIColor blackColor]];
    [userUsernameLabel setFont:[UIFont fontWithName:@"Helvetica-Medium" size:16.0f]];
    [userUsernameLabel setTextAlignment:NSTextAlignmentCenter];
    [MaskView addSubview:userUsernameLabel];
    
    UIButton *addFriendButton = [[UIButton alloc] initWithFrame:CGRectMake(MaskView.frame.origin.x + 80, self.view.frame.origin.y + 349, 160, 40)];
    [addFriendButton setImage:[UIImage imageNamed:@"AddFriends_AddFriendButton.png"] forState:UIControlStateNormal];
    [addFriendButton addTarget:self action:@selector(addFriendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [MaskView addSubview:addFriendButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(MaskView.frame.origin.x + 80, self.view.frame.origin.y + 397, 160, 40)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [cancelButton setTitleColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:0.7f] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAddFriendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [MaskView addSubview:cancelButton];
    
    [UIView animateWithDuration:0.2 animations:^{
        [MaskView setFrame:[[UIScreen mainScreen] bounds]];
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
    
    [savedFriendsArray addObject:friendUsername];
    [savedFriendPhotoArray addObject:friendPhotoURL];
    
    [[NSUserDefaults standardUserDefaults] setObject:savedFriendsArray forKey:@"USER_FRIENDS_ARRAY"];
    [[NSUserDefaults standardUserDefaults] setObject:savedFriendPhotoArray forKey:@"USER_PHOTO_ARRAY"];
    [userDefaults synchronize];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void) cancelAddFriendButtonClicked
{
    [UIView animateWithDuration:0.2 animations:^{
        [MaskView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height + 1, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [MaskView removeFromSuperview];
    }];
}

@end
