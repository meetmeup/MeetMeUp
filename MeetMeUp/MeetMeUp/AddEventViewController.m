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

#define TEXTFIELD_SCROLL_UP_HEIGHT (self.view.frame.size.height == 568.0f ? 50 : 70)


@interface AddEventViewController ()<UITextFieldDelegate, LocationSearchDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIDatePicker *datePicker;
    UIView *datePickerView;
    NSString *dateSelected;
    int keyboardHeight;
    NSMutableArray *inviteesSearchArray;
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
    //reisgn textFields
    [self.titleTextField resignFirstResponder];
    [self.inviteeTextField resignFirstResponder];
    [self.urlTextfield resignFirstResponder];
    [self.notesTextField resignFirstResponder];
    
    DatePickerCreator *datePickerCreator = [[DatePickerCreator alloc] init];
    datePickerView = [[UIView alloc] init];
    datePickerView = [datePickerCreator createDatePickerWithViewController:self withTag:0];
    [self.view addSubview:datePickerView];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy  HH:mm"];
    dateSelected = [dateFormatter stringFromDate:date];
}

- (IBAction)endsButtonClicked:(id)sender
{
    //reisgn textFields
    [self.titleTextField resignFirstResponder];
    [self.inviteeTextField resignFirstResponder];
    [self.urlTextfield resignFirstResponder];
    [self.notesTextField resignFirstResponder];
    
    DatePickerCreator *datePickerCreator = [[DatePickerCreator alloc] init];
    datePickerView = [[UIView alloc] init];
    datePickerView = [datePickerCreator createDatePickerWithViewController:self withTag:1];
    [self.view addSubview:datePickerView];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy  HH:mm"];
    dateSelected = [dateFormatter stringFromDate:date];
}

- (void) dateSelected:(id)sender
{
    NSLog(@"hello %@", [sender date]);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy  HH:mm"];
    dateSelected = [dateFormatter stringFromDate:[sender date]];
}

#pragma mark - dismiss date picker
- (void) dismissDatePicker
{
    [UIView animateWithDuration:0.2 animations:^{
        [datePickerView setFrame:CGRectMake(0, self.view.frame.size.height + 1, self.view.frame.size.width, 258)];
    } completion:^(BOOL finished) {
        [datePickerView removeFromSuperview];
    }];
}

#pragma mark - done date picker
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

#pragma mark - textViewShouldReturn
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.inviteeTextField)
    {
        [textField resignFirstResponder];
        [self.urlTextfield becomeFirstResponder];
    }
    else if (textField == self.urlTextfield)
    {
        [textField resignFirstResponder];
        [self.notesTextField becomeFirstResponder];
    }
    else if (textField == self.titleTextField)
    {
        [textField resignFirstResponder];
    }
    else if (textField == self.notesTextField)
    {
#warning if else check any field is missing...
#warning save in nsuserdefaults??
#warning update in main view controller
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
    return YES;
}

#pragma mark - didBeginEditing
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.inviteeTextField)
    {
        //invitee textfield accessory view
        CGPoint origin = CGPointMake(10, self.inviteeTextField.frame.size.height + self.inviteeTextField.frame.origin.y);
        UITableView *friendsChoicesTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, origin.y + 5, 300, 158)];
        [friendsChoicesTableView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.8f]];
        [friendsChoicesTableView.layer setCornerRadius:10.f];
        [friendsChoicesTableView.layer setMasksToBounds:YES];
        [friendsChoicesTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [friendsChoicesTableView setDelegate:self];
//        [friendsChoicesTableView setDataSource:self];
        [textField setInputAccessoryView:friendsChoicesTableView];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - 120), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        textField.returnKeyType = UIReturnKeyNext;
    }
    if (textField == self.urlTextfield)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - TEXTFIELD_SCROLL_UP_HEIGHT*2), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        textField.returnKeyType = UIReturnKeyNext;
    }
    if (textField == self.notesTextField)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - TEXTFIELD_SCROLL_UP_HEIGHT*3), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        textField.returnKeyType = UIReturnKeyDone;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.inviteeTextField)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + 120), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if (textField == self.urlTextfield)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + TEXTFIELD_SCROLL_UP_HEIGHT*2), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    if (textField == self.notesTextField)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + TEXTFIELD_SCROLL_UP_HEIGHT*3), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"string: %@", string);
    
    if (textField == self.inviteeTextField)
    {
        NSString *searchText = textField.text;
        NSError *error;
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"(@(\\w+))"
                                                                               options:0
                                                                                 error:&error];

        NSArray * matches = [regex matchesInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
        for (NSTextCheckingResult* match in matches ) {
            
            NSRange wordRange = [match rangeAtIndex:1];
            NSString* usernameSearch = [searchText substringWithRange:wordRange];
            NSLog(@"%@", usernameSearch);
            
            //get usernames added from nsuserdefaults
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *savedFriendsArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"USER_FRIENDS_ARRAY"]];
            
            NSLog(@"saved friends: %@", savedFriendsArray);
            
            inviteesSearchArray = [NSMutableArray array];
            
            for (NSString* item in savedFriendsArray)
            {
                if ([item rangeOfString:searchText].location != NSNotFound)
                {
                    [inviteesSearchArray addObject:item];
                    NSLog(@"invitees array: %@", inviteesSearchArray);
                }
            }
        }

    }
    
    return YES;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//{
//    return [inviteesSearchArray count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

@end
