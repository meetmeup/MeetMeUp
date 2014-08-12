//
//  MainViewController.h
//  MeetMeUp
//
//  Created by Tanya on 8/7/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "VRGCalendarView.h"

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<VRGCalendarViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIViewController *signUpViewController;
@property (strong, nonatomic) IBOutlet UIScrollView *wholeScreenScrollView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *SettingsBarButtonItem;

- (IBAction)logoutClicked:(id)sender;
- (IBAction)settingsButtonClicked:(id)sender;

@end
