//
//  AddFriendsViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/17/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "AddFriendsProxy.h"

@interface AddFriendsViewController ()<UISearchBarDelegate, AddFriendsProxyDelegate>

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
}

#warning in delegate method save username and userprofileurl in nsuserdefaults or keychain ***

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
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
        
    }
}

-(void)AddFriends:(AddFriendsProxy *)searchProxy retrievedSearchUser:(NSString *)username andUserProfile:(NSString *)profileURL
{
    NSLog(@"username: %@", username);
    NSLog(@"url: %@", profileURL);
    
    UIView *MaskView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [MaskView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.6f]];
    
    
    [self.view addSubview:MaskView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
