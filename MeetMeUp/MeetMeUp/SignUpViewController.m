//
//  SignUpViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/5/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "SignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImagePickHelper.h"
#import "SignUpProxy.h"
#import "AlertViewCreator.h"
#import "ViewToImageConverter.h"
#import "SmallActivityIndicatorCreator.h"

#define PROFILE_BUTTON_WIDTH self.profilePicture.bounds.size.width
#define PROFILE_BUTTON_HEIGHT self.profilePicture.bounds.size.height
#define TEXTFIELD_SCROLL_UP_HEIGHT 10
#define ALERT_VIEW_HEIGHT 45
#define ALERT_VIEW_HIDE_FRAME CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, 0)
#define ALERT_VIEW_SHOW_FRAME CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, ALERT_VIEW_HEIGHT)


@interface SignUpViewController ()
{
    UIButton *profileImageButton;
    
    //profile image user selected from picker
    UIImage *imageSelected;
    
    //create alertView
    UIView *alertView;
}

@end

@implementation SignUpViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        //checks if user press home button
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(applicationWillResign)
         name:UIApplicationWillResignActiveNotification
         object:nil];
    }
    return self;
}

//dismiss sign up view controller when user press home button
- (void) applicationWillResign{
    [self dismissViewControllerAnimated:YES completion:^{
        //make app delegate know user is logged in
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLoggedIn"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [FBSession.activeSession closeAndClearTokenInformation];
            [[FBSession activeSession] close];
        }];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    //set delegates
    [self.emailTextField setDelegate:self];
    [self.usernameTextfield setDelegate:self];
    [self.passwordTextfield setDelegate:self];
    
    //sigh up with email
    if (self.interfaceCount == 1)
    {
        [self.profilePicture removeFromSuperview];
        profileImageButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 46, PROFILE_BUTTON_WIDTH, PROFILE_BUTTON_HEIGHT)];
        [profileImageButton setImage:[UIImage imageNamed:@"SignUp_CameraIcon.png"] forState:UIControlStateNormal];
        [profileImageButton addTarget:self action:@selector(selectProfileImage) forControlEvents:UIControlEventTouchUpInside];
        profileImageButton.clipsToBounds = YES;
        profileImageButton.layer.cornerRadius = PROFILE_BUTTON_WIDTH/2.0f;
        [self.view addSubview:profileImageButton];
    }
    //sign up with facebook
    else
    {
        //set all important facebook fetch from previous viewcontroller
        [self.emailTextField setText:self.email];
        [self.usernameTextfield setText:self.username];
        self.profilePicture.profileID = self.profileIDs;

        imageSelected = self.profileImageFromURL;
        
        self.profilePicture.layer.cornerRadius = PROFILE_BUTTON_WIDTH/2.0f;
        self.profilePicture.backgroundColor = [UIColor whiteColor];
        
        //create select profile image button incase user doesn't want to use their profile picture in facebook
        profileImageButton = [[UIButton alloc] initWithFrame:CGRectMake(75, 46, PROFILE_BUTTON_WIDTH, PROFILE_BUTTON_HEIGHT)];
        [profileImageButton addTarget:self action:@selector(selectProfileImage) forControlEvents:UIControlEventTouchUpInside];
        [profileImageButton setBackgroundColor:[UIColor clearColor]];
        profileImageButton.clipsToBounds = YES;
        profileImageButton.layer.cornerRadius = PROFILE_BUTTON_WIDTH/2.0f;
        [self.view addSubview:profileImageButton];
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.emailTextField)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - TEXTFIELD_SCROLL_UP_HEIGHT), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if (textField == self.usernameTextfield)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - TEXTFIELD_SCROLL_UP_HEIGHT*2), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if (textField == self.passwordTextfield)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - TEXTFIELD_SCROLL_UP_HEIGHT*3), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.emailTextField)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + TEXTFIELD_SCROLL_UP_HEIGHT), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if (textField == self.usernameTextfield)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + TEXTFIELD_SCROLL_UP_HEIGHT*2), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if (textField == self.passwordTextfield)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + TEXTFIELD_SCROLL_UP_HEIGHT*3), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

#pragma mark - cancel clicked
- (IBAction)cancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 //nothing
                             }];
}

#pragma mark - select profile image
-(void)selectProfileImage
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Change Profile Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose from Library", nil];
    
    sheet.delegate = self;
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showInView:self.view];
}

//check if user put in right email format
- (BOOL)validateEmail:(NSString *)emailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
}

//check if username in right format
- (BOOL) validateUsername:(NSString *)usernameString
{
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz0123456789_."];
    characterSet = [characterSet invertedSet];
    
    NSRange range = [usernameString rangeOfCharacterFromSet:characterSet];
    if (range.location != NSNotFound) {
        return NO;
    }
    return YES;
}


- (IBAction)signupClicked:(id)sender
{

    //create AlertView
    AlertViewCreator *alertViewCreator = [[AlertViewCreator alloc] init];
    alertView = [[UIView alloc] init];
    
    if ([self.emailTextField.text isEqualToString:@""])
    {
        alertView = [alertViewCreator createAlertViewWithViewController:self andText:@"Please enter a valid email address."];
        [self.view addSubview:alertView];
    }
    else if (![self validateEmail:self.emailTextField.text])
    {
        alertView = [alertViewCreator createAlertViewWithViewController:self andText:@"Please enter a valid email address."];
        [self.view addSubview:alertView];
    }
    else if ([self.usernameTextfield.text isEqualToString:@""])
    {
        alertView = [alertViewCreator createAlertViewWithViewController:self andText:@"Please choose a username."];
        [self.view addSubview:alertView];
    }
    else if (![self validateUsername:self.usernameTextfield.text])
    {
        alertView = [alertViewCreator createAlertViewWithViewController:self andText:@"Please enter a valid username."];
        [self.view addSubview:alertView];
    }
    else if ([self.passwordTextfield.text length] < 6)
    {
        alertView = [alertViewCreator createAlertViewWithViewController:self andText:@"Passwords must be at least 6 characters."];
        [self.view addSubview:alertView];
    }
    else if ([self.passwordTextfield.text isEqualToString:@""])
    {
        alertView = [alertViewCreator createAlertViewWithViewController:self andText:@"Please create a password."];
        [self.view addSubview:alertView];
    }
    else
    {
#pragma mark - sign up proxy
        
        SmallActivityIndicatorCreator *smallActivityIndicator = [[SmallActivityIndicatorCreator alloc] init];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] init];
        activityIndicator = [smallActivityIndicator createActivityindicator];
        [self.signUpButton addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        //make activity indicator run for 2 second.... HEHE
        [self performSelector:@selector(SignUpProxy) withObject:nil afterDelay:1.0];
    }
}

- (void)SignUpProxy
{
    SignUpProxy *signUpProxy = [[SignUpProxy alloc] init];
    [signUpProxy signUpUserWithEmail:self.emailTextField.text username:self.usernameTextfield.text password:self.passwordTextfield.text photo:imageSelected andViewController:self];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    if(buttonIndex == 0)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:^{
            }];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Your camera is not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    }
    if(buttonIndex == 1)
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:^{
        }];
    }

}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    imageSelected = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    ////////////////// **CROP IMAGE TO DESIRED SIZE ** ///////////////////////
    CGSize itemSize = CGSizeMake(340, 340); // give any size you want to give
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [imageSelected drawInRect:imageRect];
    imageSelected = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //////////////////////////////////////////////////////////////////////////
    
    [profileImageButton setImage:imageSelected forState:UIControlStateNormal];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
