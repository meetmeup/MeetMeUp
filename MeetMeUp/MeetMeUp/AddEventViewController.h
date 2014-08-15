//
//  AddEventViewController.h
//  MeetMeUp
//
//  Created by Tanya on 8/15/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddEventViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *startTimeTextField;
@property (strong, nonatomic) IBOutlet UITextField *endTimeTextField;
@property (strong, nonatomic) IBOutlet UITextField *inviteeTextField;
@property (strong, nonatomic) IBOutlet UITextField *urlTextfield;
@property (strong, nonatomic) IBOutlet UITextField *notesTextField;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)locationSearchClicked:(id)sender;

@end
