//
//  EventDetailsViewController.m
//  MeetMeUp
//
//  Created by Tanya on 10/22/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "EventDetailsViewController.h"
#import "EventDetailsMapViewController.h"

@interface EventDetailsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *titleArray;
    NSArray *detailsArray;
}

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    self.title = @"Event Details";
    
    titleArray = [NSArray arrayWithObjects:@"Title", @"Where?", @"Starts", @"Ends", @"Who's going?", @"URL", @"Notes", nil];
    detailsArray = [NSArray arrayWithObjects:@"Meeting with ustwo", @"ustwo", @"10:00AM", @"11:00AM", @"stevejobs, billgates, emmawatson", @"www.ustwo.com", @"BE ON TIME!", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // allocate the cell:
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 235, 20)];
        [cellTextLabel setTextColor:[UIColor colorWithRed:255.0/255.0f green:153.0/255.0f blue:51.0/255.0f alpha:1.0f]];
        [cellTextLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:9.0f]];
        [cellTextLabel setTag:1];
        [cell.contentView addSubview:cellTextLabel];
        
        UILabel *cellDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 235, 20)];
        [cellDetailLabel setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0/255.0f alpha:1.0f]];
        [cellDetailLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15.0f]];
        [cellDetailLabel setTag:2];
        [cell.contentView addSubview:cellDetailLabel];
        
    }
    
    if (indexPath.row != 1)
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    
    [(UILabel *) [cell.contentView viewWithTag:1] setText:[titleArray objectAtIndex:indexPath.row]];
    [(UILabel *)[cell.contentView viewWithTag:2] setText:[detailsArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        EventDetailsMapViewController *eventMapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"eventdetailsmap"];
        [self.navigationController pushViewController:eventMapViewController animated:YES];
    }
}
@end
