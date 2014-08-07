//
//  SignUpViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/5/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "SignUpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "ImagePickHelper.h"


@interface SignUpViewController ()
{
    UIButton *profileImageButton;
}

@end

@implementation SignUpViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set delegates
    [self.emailTextField setDelegate:self];
    [self.usernameTextfield setDelegate:self];
    [self.passwordTextfield setDelegate:self];
    
    if ([self.interfaceCount isEqualToString:@"1"])
    {
        //sign up with email
        [self.profilePicture removeFromSuperview];
        profileImageButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 46, 200, 200)];
        [profileImageButton setImage:[UIImage imageNamed:@"SignUp_CameraIcon.png"] forState:UIControlStateNormal];
        [profileImageButton addTarget:self action:@selector(selectProfileImage) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:profileImageButton];
    }
    else
    {
        //sign up with Facebook
        [self.emailTextField setText:self.email];
        [self.usernameTextfield setText:self.username];
        self.profilePicture.profileID = self.profileIDs;
        self.profilePicture.layer.cornerRadius = 100;
        self.profilePicture.backgroundColor = [UIColor whiteColor];
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
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - 30), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if (textField == self.usernameTextfield)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - 50), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if (textField == self.passwordTextfield)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - 70), self.view.frame.size.width, self.view.frame.size.height);
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
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + 30), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if (textField == self.usernameTextfield)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + 50), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if (textField == self.passwordTextfield)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + 70), self.view.frame.size.width, self.view.frame.size.height);
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

- (IBAction)signupClicked:(id)sender
{
#warning upload user data to server using signupproxy
    //make app delegate know user is logged in
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //open up MainViewController
    MainViewController *mainViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self presentViewController:mainViewController animated:YES completion:^{
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        //        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        //        {
        //            imagePicker = [[UIImagePickerController alloc] init];
        //            imagePicker.delegate = self;
        //            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//Photo from the camera
        //            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //
        //            [self presentModalViewController:imagePicker animated:YES];
        //
        //        }
        //        else
        //        {
        //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Camera not available" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        //            [alert show];
        //            //[alert release];
        //        }        
        
    }
    if(buttonIndex == 1)
    {
//        ImagePickHelper *imagePicker = [[ImagePickHelper alloc] init];
//        [profileImageButton setImage:[imagePicker getImageFromLibrayFromViewController:self] forState:UIControlStateNormal];
    }
    
}

@end
