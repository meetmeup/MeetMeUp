//
//  LocationSearchViewController.h
//  MeetMeUp
//
//  Created by Tanya on 8/17/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationSearchDelegate <NSObject>

- (void) locationSearchViewControllerDismissed:(NSString *)venueName andLatitude:(CGFloat)latitude andLongtitude:(CGFloat)longtitude;

@end

@interface LocationSearchViewController : UIViewController
{
//    id locationSearchViewControllerDelegate;
}

@property (nonatomic, assign) id<LocationSearchDelegate>locationSearchViewControllerDelegate;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)dismissVIewController:(id)sender;
- (IBAction)navigateButtonClicked:(id)sender;


@end
