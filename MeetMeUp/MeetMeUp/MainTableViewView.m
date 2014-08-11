//
//  MainTableViewView.m
//  MeetMeUp
//
//  Created by Tanya on 8/11/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "MainTableViewView.h"

@implementation MainTableViewView

- (UIView *) createMainTableViewWithRect:(CGRect) rect
{
    UIView *view = [[UIView alloc] initWithFrame:rect];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.frame = CGRectMake(0, 10, 320, 100);
    [view addSubview:tableView];
    
    return view;
}

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:@"MyCell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"MyCell"];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else
    {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
        //                            reuseIdentifier:@"MyCell"];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"MyCell"];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        //NSURL * imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://skenebilcenter.inapp.se/%@", [thumbArray objectAtIndex:indexPath.row]]];
        
//        AsyncImageView *asyncImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        asyncImage.tag = ASYNC_IMAGE_TAG;
//        [cell addSubview:asyncImage];
//        [asyncImage loadImageWithTypeFromURL:[NSURL URLWithString:[photo objectAtIndex:indexPath.row]] contentMode:UIViewContentModeScaleAspectFit imageNameBG:nil];
//        
//        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 17, 165, 20)];
//        [nameLabel setText:[name objectAtIndex:indexPath.row]];
//        [nameLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:17.0f]];
//        [nameLabel setTextColor:[UIColor colorWithRed:255.0f/255.0f green:173.0f/255.0f blue:173.0f/255.0f alpha:1.0f]];
//        [cell addSubview:nameLabel];
//        
//        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 43, 165, 20)];
//        [priceLabel setText:[NSString stringWithFormat:@"฿ %@", [price objectAtIndex:indexPath.row]]];
//        [priceLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15.0f]];
//        [priceLabel setTextColor:[UIColor colorWithRed:122.0f/255.0f green:176.0f/255.0f blue:152.0f/255.0f alpha:1.0f]];
//        [cell addSubview:priceLabel];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ProductDetailViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
//    [self.navigationController pushViewController:detailView animated:YES];
}


@end
