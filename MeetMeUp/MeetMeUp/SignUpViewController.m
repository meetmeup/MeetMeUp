//
//  SignUpViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/5/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "SignUpViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface SignUpViewController ()

@end

@implementation SignUpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set delegates
    [self.emailTextField setDelegate:self];
    [self.usernameTextfield setDelegate:self];
    [self.passwordTextfield setDelegate:self];
    
    if (self.interfaceCount == 1)
    {
        //sign up with email
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
- (IBAction)cancelClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 //nothing
                             }];
}

- (IBAction)signupClicked:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
