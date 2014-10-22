//
//  InviteeViewController.h
//  MeetMeUp
//
//  Created by Tanya on 10/17/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InviteeTableView.h"

@protocol inviteeDelegate <NSObject>

- (void) inviteeViewControllerDismissed:(NSArray *)inviteesArray andToken:(NSArray *)tokenArray;

@end

@interface InviteeViewController : UIViewController
{
//    id myDelegate;
}

@property (nonatomic, assign) id<inviteeDelegate> myDelegate;
@property (strong, nonatomic) IBOutlet InviteeTableView *inviteeTableView;
- (IBAction)cancelClicked:(id)sender;
- (IBAction)doneClicked:(id)sender;


@end
