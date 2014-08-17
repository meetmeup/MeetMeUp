//
//  AddFriendsViewController.h
//  MeetMeUp
//
//  Created by Tanya on 8/17/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddFriendsViewController : UIViewController

@property (nonatomic, strong) NSString *addFriendsBy;

@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)dismissVIewController:(id)sender;

@end
