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
@property (strong, nonatomic) IBOutlet UITextField *inviteeTextField;
@property (strong, nonatomic) IBOutlet UITextField *urlTextfield;
@property (strong, nonatomic) IBOutlet UITextField *notesTextField;
@property (strong, nonatomic) IBOutlet UILabel *startLabel;
@property (strong, nonatomic) IBOutlet UILabel *endsLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)locationSearchClicked:(id)sender;
- (IBAction)startsButtonClicked:(id)sender;
- (IBAction)endsButtonClicked:(id)sender;
- (IBAction)DoneButtonClicked:(id)sender;

@property (nonatomic, strong) NSString *LocationSelectedString;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longtitude;


@end
