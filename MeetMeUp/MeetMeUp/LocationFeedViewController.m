//
//  LocationFeedViewController.m
//  MeetMeUp
//
//  Created by Tanya on 10/24/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "LocationFeedViewController.h"

@interface LocationFeedViewController ()

@end

@implementation LocationFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navigationBarSettings];

}

- (void) navigationBarSettings
{
    //setting navigation bar title color
    [[[self navigationController] navigationBar] setTintColor:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]}];
    
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *addEventButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"+"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(flipView:)];
    
    [addEventButton setImage:[[UIImage imageNamed:@"LocationFeed_Addevent.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.navigationItem.rightBarButtonItem = addEventButton;
    self.title = @"Find your friends";
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0f/255.0f green:153.0/255.0f blue:51.0f/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self setTitle:@"Your Events"];
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self prefersStatusBarHidden];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}


@end
