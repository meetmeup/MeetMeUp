//
//  LocationSearchTableViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/15/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "LocationSearchTableViewController.h"

@interface LocationSearchTableViewController ()<UISearchBarDelegate>
{
}

@end

@implementation LocationSearchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"AddEvent_SearchBarCancel.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setImage:image];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"        "];
    
    [self prefersStatusBarHidden];
    [self.searchBar becomeFirstResponder];
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:@"Find a location"];
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
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
    
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    else
    {
//        
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
//        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
//        
//        UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 300, 20)];
//        [cellTextLabel setText:@""];
//        [cellTextLabel setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0/255.0f alpha:1.0f]];
//        [cellTextLabel setFont:[UIFont fontWithName:@"Helvetica-Medium" size:16.0f]];
//        [cell.contentView addSubview:cellTextLabel];
    }
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
