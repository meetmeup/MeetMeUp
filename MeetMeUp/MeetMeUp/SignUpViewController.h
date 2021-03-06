//
//  SignUpViewController.h
//  MeetMeUp
//
//  Created by Tanya on 8/5/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController<FBLoginViewDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *profileIDs;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, readwrite) int interfaceCount;
@property (strong, nonatomic) UIImage *profileImageFromURL;



- (IBAction)cancelClicked:(id)sender;
- (IBAction)signupClicked:(id)sender;


@end
