//
//  LocationSearchViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/17/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import "LocationSearchViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationSearchProxy.h"
#import "WholescreenActivityIndicatorCreator.h"
#import "LocationSearchProxy.h"
#import "AddEventViewController.h"

#define CLIENT_ID @"N4LUEASDYAPDDOCZMRNZ4Z044XTO53QOBRB3BKUSGBEP1CIJ"
#define CLIENT_SECRET_ID @"2IPCGOJXHQCVAEUXT5VJY0RUQN0M5LDPZPZRPQJZUAITI2MG"
#define VERSION 20140806

@interface LocationSearchViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, LocationSearchProxyDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    UIActivityIndicatorView *activityIndicator;
    NSMutableArray *searchLocationResultArray;
}

@end

@implementation LocationSearchViewController

@synthesize locationSearchViewControllerDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    WholescreenActivityIndicatorCreator *wholeScreenActivityCreator = [[WholescreenActivityIndicatorCreator alloc] init];
    activityIndicator = [[UIActivityIndicatorView alloc] init];
    activityIndicator = [wholeScreenActivityCreator createActivityindicator];
    [self.tableView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [self performSelector:@selector(searchLocationQueryWithString:) withObject:nil afterDelay:0.0];
}

-(void)searchProxy:(LocationSearchProxy *)searchProxy retrievedSearchResults:(NSMutableArray *)searchResultsArray
{
    searchLocationResultArray = searchResultsArray;
    NSLog(@"searchresult: %@", searchLocationResultArray);
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set navigation bar accessories
    [[[self navigationController] navigationBar] setTintColor:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]}];

    
    UIImage *image = [UIImage imageNamed:@"AddEvent_SearchBarCancel.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setImage:image];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"        "];
    
    [self prefersStatusBarHidden];
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:@"Find a location"];
}

#pragma mark - searchLocationQueryWithString
- (void) searchLocationQueryWithString:(NSString *)queryString
{
    NSLog(@"query:%@", queryString);
    if (queryString == nil)
    {
        queryString = @"";
    }
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
    NSLog(@"%@", [NSString stringWithFormat:@"latitude: %f longitude: %f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude]);
    
    //check if location services enabled
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"Location services disabled."
                                                           message:@"To re-enable, please go to Settings and turn on Location Service."
                                                          delegate:nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //get currect version
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            LocationSearchProxy *locationSearchProxy = [[LocationSearchProxy alloc] init];
            [locationSearchProxy setDelegate:self];
            [locationSearchProxy searchLocationWithClientID:CLIENT_ID andClientSecret:CLIENT_SECRET_ID andSearchText:queryString andLatitude:locationManager.location.coordinate.latitude andLongtitude:locationManager.location.coordinate.longitude andVersion:dateString andViewController:self];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityIndicator stopAnimating];
            });
            
        });
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchBar.text = @"";
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
#warning foursquare rate per hour
#warning try when no internet connection
#warning activity indicator
    WholescreenActivityIndicatorCreator *wholeScreenActivityCreator = [[WholescreenActivityIndicatorCreator alloc] init];
    activityIndicator = [[UIActivityIndicatorView alloc] init];
    activityIndicator = [wholeScreenActivityCreator createActivityindicator];
    [self.tableView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [self performSelector:@selector(searchLocationQueryWithString:) withObject:searchBar.text afterDelay:0.0];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([searchLocationResultArray count] == 0)
    {
        return 0;
    }
    return [searchLocationResultArray count];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // allocate the cell:
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 300, 20)];
        [cellTextLabel setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0/255.0f alpha:1.0f]];
        [cellTextLabel setFont:[UIFont fontWithName:@"Helvetica-Medium" size:16.0f]];
        [cellTextLabel setTag:1];
        [cell.contentView addSubview:cellTextLabel];
        
        UILabel *cellDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 300, 20)];
        [cellDetailLabel setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0/255.0f alpha:1.0f]];
        [cellDetailLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:12.0f]];
        [cellDetailLabel setTag:2];
        [cell.contentView addSubview:cellDetailLabel];
        
    }

    [(UILabel *) [cell.contentView viewWithTag:1] setText:[[searchLocationResultArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
    [(UILabel *)[cell.contentView viewWithTag:2] setText:[NSString stringWithFormat:@"%@, %@, %@", [[searchLocationResultArray objectAtIndex:indexPath.row] objectForKey:@"address"], [[searchLocationResultArray objectAtIndex:indexPath.row] objectForKey:@"city"], [[searchLocationResultArray objectAtIndex:indexPath.row] objectForKey:@"country"]]];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if ([self.locationSearchViewControllerDelegate respondsToSelector:@selector(locationSearchViewControllerDismissed:andLatitude:andLongtitude:)])
    {
        [self.locationSearchViewControllerDelegate locationSearchViewControllerDismissed:[[searchLocationResultArray objectAtIndex:indexPath.row] objectForKey:@"name"] andLatitude:[[[searchLocationResultArray objectAtIndex:indexPath.row] objectForKey:@"lat"] floatValue] andLongtitude:[[[searchLocationResultArray objectAtIndex:indexPath.row] objectForKey:@"lng"] floatValue]];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)dismissVIewController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)navigateButtonClicked:(id)sender
{
    WholescreenActivityIndicatorCreator *wholeScreenActivityCreator = [[WholescreenActivityIndicatorCreator alloc] init];
    activityIndicator = [[UIActivityIndicatorView alloc] init];
    activityIndicator = [wholeScreenActivityCreator createActivityindicator];
    [self.tableView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [self performSelector:@selector(searchLocationQueryWithString:) withObject:nil];
}
@end
