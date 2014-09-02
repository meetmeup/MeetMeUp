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

@interface MainViewController : UIViewController<VRGCalendarViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSString *uniqueEventID;

@property (strong, nonatomic) UIViewController *signUpViewController;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *SettingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIButton *notificationsButton;


@property (nonatomic, retain, getter = selectedDate) NSDate *selectedDate;


- (IBAction)logoutClicked:(id)sender;
- (IBAction)settingsButtonClicked:(id)sender;

@end
