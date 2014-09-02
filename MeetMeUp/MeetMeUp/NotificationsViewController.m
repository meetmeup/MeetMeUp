//
//  NotificationsViewController.m
//  MeetMeUp
//
//  Created by Tanya on 9/2/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

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
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"notification"];
    
    //set navigation bar accessories
    [[[self navigationController] navigationBar] setTintColor:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]}];
    
    [self prefersStatusBarHidden];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
