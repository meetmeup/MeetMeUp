//
//  LoginViewController.h
//  MeetMeUp
//
//  Created by Tanya on 8/5/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<FBLoginViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)SignInClicked:(id)sender;
- (IBAction)newUserClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *HeaderImage;
@property (strong, nonatomic) IBOutlet UIImageView *userPassImage;
@property (strong, nonatomic) IBOutlet UIButton *signInImage;
@property (strong, nonatomic) IBOutlet FBLoginView *facebookImage;
@property (strong, nonatomic) IBOutlet UIButton *ForgotPasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

@end
