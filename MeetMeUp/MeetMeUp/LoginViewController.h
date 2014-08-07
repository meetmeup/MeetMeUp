//
//  LoginViewController.h
//  MeetMeUp
//
//  Created by Tanya on 8/5/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)SignInClicked:(id)sender;
- (IBAction)newUserClicked:(id)sender;


@end
