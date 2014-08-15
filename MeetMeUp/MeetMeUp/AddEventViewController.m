//
//  AddEventViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/15/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "AddEventViewController.h"
#import "LocationSearchTableViewController.h"

@interface AddEventViewController ()<UITextFieldDelegate>

@end

@implementation AddEventViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set backgrounf color
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Main_BG.jpg"]]];
    
    [self.titleTextField setDelegate:self];
    [self.startTimeTextField setDelegate:self];
    [self.endTimeTextField setDelegate:self];
    [self.inviteeTextField setDelegate:self];
    [self.urlTextfield setDelegate:self];
    [self.notesTextField setDelegate:self];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)locationSearchClicked:(id)sender
{
    LocationSearchTableViewController *locationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"locationsearch"];
    [self presentViewController:locationViewController animated:YES completion:^{
        
    }];
}
@end
