//
//  LoginViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/5/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet FBLoginView *fbLoginView;

@end

@implementation LoginViewController

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
    
    
    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"];
    
    if (!isLoggedIn)
    {
        [_fbLoginView setReadPermissions:@[@"email", @"public_profile"]];
        [_fbLoginView setDelegate:self];
        [[self view] addSubview:_fbLoginView];
        
        for (id obj in _fbLoginView.subviews)
        {
            if ([obj isKindOfClass:[UIButton class]])
            {
                UIButton * loginButton =  obj;
                UIImage *loginImage = [UIImage imageNamed:@"Login_SignInFacebook.png"];
                [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
                [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
                [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
                [loginButton sizeToFit];
            }
            if ([obj isKindOfClass:[UILabel class]])
            {
                UILabel * loginLabel =  obj;
                loginLabel.text = @"";
            }
        }
    }
    else if (isLoggedIn)
    {
        
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)SignInClicked:(id)sender {
    
    SignUpViewController *signUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    //sign up with email
    signUpViewController.interfaceCount = 1;
    [self presentViewController:signUpViewController animated:YES completion:^{
        NSLog(@"signUpViewController got presented");
    }];
}

#pragma mark - facebook get user info
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    //tell appdelegate user signed in
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoggedIn"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    SignUpViewController *signUpViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    signUpViewController.profileIDs = user.id;
    signUpViewController.email = [user objectForKey:@"email"];
    //sign up with facebook
    signUpViewController.interfaceCount = 0;
    
    if (user.username == nil)
    {
        signUpViewController.username = @"";
        [self presentViewController:signUpViewController animated:YES completion:^{
            NSLog(@"signUpViewController got presented");
        }];
    }
    else
    {
        signUpViewController.username = user.username;
        [self presentViewController:signUpViewController animated:YES completion:^{
            NSLog(@"signUpViewController got presented");
        }];
    }
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    
    NSLog(@"ALREADY LOGGED IN");
    
    for (id obj in _fbLoginView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage = [UIImage imageNamed:@"Login_SignInFacebook.png"];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton sizeToFit];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
        }
    }

}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    for (id obj in _fbLoginView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            UIImage *loginImage = [UIImage imageNamed:@"Login_SignInFacebook.png"];
            [loginButton setBackgroundImage:loginImage forState:UIControlStateNormal];
            [loginButton setBackgroundImage:nil forState:UIControlStateSelected];
            [loginButton setBackgroundImage:nil forState:UIControlStateHighlighted];
            [loginButton sizeToFit];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"";
        }
    }
}


// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    
    NSLog(@"ERROR");
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
