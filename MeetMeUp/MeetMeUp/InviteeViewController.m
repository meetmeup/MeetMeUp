//
//  InviteeViewController.m
//  MeetMeUp
//
//  Created by Tanya on 10/17/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "InviteeViewController.h"

@interface InviteeViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *savedFriendsArray;
    NSMutableArray *savedFriendsTokenArray;
    NSMutableArray *checkedArray;
}

@end

@implementation InviteeViewController

@synthesize myDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    //hide status bar
    [self prefersStatusBarHidden];
    
    //set navigation bar accessories
    [[[self navigationController] navigationBar] setTintColor:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]}];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    savedFriendsArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"USER_FRIENDS_ARRAY"]];
//    NSMutableArray *savedfriendsTokenArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"USER_DEVICE_TOKEN_ARRAY"]];
    savedFriendsTokenArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"USER_DEVICE_TOKEN_ARRAY"]];
    
    NSMutableArray *combined = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < savedFriendsArray.count; i++) {
        [combined addObject: @{@"name" : savedFriendsArray[i], @"token": savedFriendsTokenArray[i]}];
    }
    
    [combined sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    
    savedFriendsArray     = [combined valueForKey:@"name"];
    savedFriendsTokenArray = [combined valueForKey:@"token"];

    checkedArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [savedFriendsArray count]; i++)
    {
        [checkedArray addObject:@"0"];
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [savedFriendsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // allocate the cell:
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 300, 20)];
        [cellTextLabel setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0/255.0f alpha:1.0f]];
        [cellTextLabel setFont:[UIFont fontWithName:@"Helvetica-Medium" size:16.0f]];
        [cellTextLabel setTag:1];
        [cell.contentView addSubview:cellTextLabel];
        
        UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 12, 24, 24)];
        [checkButton setTag:2];
        [checkButton setUserInteractionEnabled:NO];
        [cell.contentView addSubview:checkButton];
        
    }
    
    [(UILabel *) [cell.contentView viewWithTag:1] setText:[savedFriendsArray objectAtIndex:indexPath.row]];
    
    if ([[checkedArray objectAtIndex:indexPath.row] isEqualToString:@"1"])
    {
        [(UIButton *) [cell.contentView viewWithTag:2] setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    else
    {
        [(UIButton *) [cell.contentView viewWithTag:2] setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[checkedArray objectAtIndex:indexPath.row] isEqualToString:@"0"])
    {
        [checkedArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }
    else if ([[checkedArray objectAtIndex:indexPath.row] isEqualToString:@"1"])
    {
        [checkedArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    [self.inviteeTableView reloadData];
}

- (IBAction)cancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneClicked:(id)sender
{
    if ([self.myDelegate respondsToSelector:@selector(inviteeViewControllerDismissed:andToken:)])
    {
        NSMutableArray *friendsArray = [[NSMutableArray alloc] init];
        NSMutableArray *tokensArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [savedFriendsArray count]; i++)
        {
            
            if ([[checkedArray objectAtIndex:i] isEqualToString:@"1"])
            {
                [friendsArray addObject:[savedFriendsArray objectAtIndex:i]];
                [tokensArray addObject:[savedFriendsTokenArray objectAtIndex:i]];
            }
        }
        [self.myDelegate inviteeViewControllerDismissed:friendsArray andToken:tokensArray];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
