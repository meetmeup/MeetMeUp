//
//  EventListViewController.m
//  MeetMeUp
//
//  Created by Tanya on 10/22/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "EventListViewController.h"
#import "AsyncImageView.h"
#import "EventDetailsViewController.h"

@interface EventListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *titleArray;
    NSArray *timeArray;
}

@end

@implementation EventListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleArray = [NSArray arrayWithObjects:@"Meeting with ustwo", @"Lunch with friends", @"Clubbing!", nil];
    timeArray = [NSArray arrayWithObjects:@"10:00AM", @"12:00PM", @"10:00PM", nil];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0f/255.0f green:153.0/255.0f blue:51.0f/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    [self setTitle:@"Your Events"];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self prefersStatusBarHidden];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // allocate the cell:
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        AsyncImageView *asyncImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(15, 11, 28, 28)];
        [asyncImageView loadImageWithTypeFromURL:[NSURL URLWithString:@"https://foursquare.com/img/categories/food/default_64.png"] contentMode:UIViewContentModeScaleAspectFit imageNameBG:nil];
        [cell.contentView addSubview:asyncImageView];
        
        UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 8, 235, 20)];
        [cellTextLabel setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0/255.0f alpha:1.0f]];
        [cellTextLabel setFont:[UIFont fontWithName:@"Helvetica-Medium" size:16.0f]];
        [cellTextLabel setTag:1];
        [cell.contentView addSubview:cellTextLabel];
        
        UILabel *cellDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 25, 235, 20)];
        [cellDetailLabel setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0/255.0f alpha:1.0f]];
        [cellDetailLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:12.0f]];
        [cellDetailLabel setTag:2];
        [cell.contentView addSubview:cellDetailLabel];
        
    }
    
    [(UILabel *) [cell.contentView viewWithTag:1] setText:[titleArray objectAtIndex:indexPath.row]];
    [(UILabel *)[cell.contentView viewWithTag:2] setText:[timeArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EventDetailsViewController *eventDetailsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventsdetail"];
    [self.navigationController pushViewController:eventDetailsViewController animated:YES];
}

@end
