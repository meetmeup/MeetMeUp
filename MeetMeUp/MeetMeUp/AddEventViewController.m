//
//  AddEventViewController.m
//  MeetMeUp
//
//  Created by Tanya on 8/15/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "AddEventViewController.h"
#import "LocationSearchViewController.h"
#import "SmallActivityIndicatorCreator.h"
#import "DatePickerCreator.h"

@interface AddEventViewController ()<UITextFieldDelegate, LocationSearchDelegate>
{
    UIDatePicker *datePicker;
    UIView *datePickerView;
    NSString *dateSelected;
}

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
#warning show indicator
    LocationSearchViewController *locationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"locationsearchview"];
    locationViewController.locationSearchViewControllerDelegate = self;
    [self presentViewController:locationViewController animated:YES completion:^{
    }];
}

-(void)locationSearchViewControllerDismissed:(NSString *)venueName andLatitude:(CGFloat)latitude andLongtitude:(CGFloat)longtitude
{
    [self.locationLabel setTextColor:[UIColor blackColor]];
    [self.locationLabel setText:venueName];
    //get lat long here
}

- (IBAction)startsButtonClicked:(id)sender
{
    DatePickerCreator *datePickerCreator = [[DatePickerCreator alloc] init];
    datePickerView = [[UIView alloc] init];
    datePickerView = [datePickerCreator createDatePickerWithViewController:self withTag:0];
    [self.view addSubview:datePickerView];
}

- (IBAction)endsButtonClicked:(id)sender
{
    DatePickerCreator *datePickerCreator = [[DatePickerCreator alloc] init];
    datePickerView = [[UIView alloc] init];
    datePickerView = [datePickerCreator createDatePickerWithViewController:self withTag:1];
    [self.view addSubview:datePickerView];
}

- (void) dateSelected:(id)sender
{
    NSLog(@"hello %@", [sender date]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy  HH:mm"];
    dateSelected = [dateFormatter stringFromDate:[sender date]];
}

- (void) dismissDatePicker
{
    [UIView animateWithDuration:0.2 animations:^{
        [datePickerView setFrame:CGRectMake(0, self.view.frame.size.height + 1, self.view.frame.size.width, 258)];
    } completion:^(BOOL finished) {
        [datePickerView removeFromSuperview];
    }];
}

- (void) doneDatePicker:(id)sender
{
    if ([sender tag] == 0)
    {
        NSLog(@"start date selected: %@", dateSelected);
        [UIView animateWithDuration:0.2 animations:^{
            [datePickerView setFrame:CGRectMake(0, self.view.frame.size.height + 1, self.view.frame.size.width, 258)];
        } completion:^(BOOL finished) {
            [datePickerView removeFromSuperview];
            [self.startLabel setTextColor:[UIColor blackColor]];
            [self.startLabel setText:dateSelected];
        }];
    }
    else
    {
        NSLog(@"end date selected: %@", dateSelected);
        [UIView animateWithDuration:0.2 animations:^{
            [datePickerView setFrame:CGRectMake(0, self.view.frame.size.height + 1, self.view.frame.size.width, 258)];
        } completion:^(BOOL finished) {
            [datePickerView removeFromSuperview];
            [self.endsLabel setTextColor:[UIColor blackColor]];
            [self.endsLabel setText:dateSelected];
        }];
    }
}

-(void)datePicker:(DatePickerCreator *)datePicker dateSelected:(NSDate *)date
{
    NSLog(@"date: %@", date);
}

@end
