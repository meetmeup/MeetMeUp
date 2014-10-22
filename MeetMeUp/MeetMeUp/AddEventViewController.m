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
#import "AsyncImageView.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "SendNotificationProxy.h"
#import "AlertViewCreator.h"
#import "KeychainItemWrapper.h"
#import "InviteeViewController.h"

#define TEXTFIELD_SCROLL_UP_HEIGHT (self.view.frame.size.height > 480.0f ? 20 : 20)
//#if (self.view.frame.size.height == 480.0f)
//#define TEXTFIELD_SCROLL_UP_HEIGHT 20
//#elif
//#define TEXTFIELD_SCROLL_UP_HEIGHT 40
//#else
//#define TEXTFIELD_SCROLL_UP_HEIGHT 60
//#endif

//#elif

#define SCROLLVIEW_CONTENT_HEIGHT /*(self.view.frame.size.height == 568.0f ? 568 : 568)*/ 0
#define SCROLLVIEW_HEIGHT (self.view.frame.size.height == 568.0f ? 568 : 480)



@interface AddEventViewController ()<inviteeDelegate, UITextFieldDelegate, LocationSearchDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIDatePicker *datePicker;
    UIView *datePickerView;
    NSString *dateSelected;
    int keyboardHeight;
    NSMutableArray *inviteesSearchArray;
    NSMutableArray *inviteesImageSearchArray;
    UITableView *friendsChoicesTableView;
    NSMutableArray *titleArray;
    DatePickerCreator *datePickerCreator;
    NSMutableArray *inviteesArrayForCoreData;
    BOOL nameTypeAllowed;
    NSString *mainString;
    NSArray *invitedFriendsArray;
    NSArray *invitedFriendsTokenArray;
    CGRect keyboardRect;
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

- (CGFloat) textfieldScrollUpHeight
{
    if (self.view.frame.size.height == 480.f)
    {
        return 90;
    }
    else if (self.view.frame.size.height == 568.0f)
    {
        return 40;
    }
    return 60;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainString = @"";
    inviteesArrayForCoreData = [[NSMutableArray alloc] init];
    
    //set backgrounf color
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"AddEvent_WhiteBG.png"]]];
    
    [self.titleTextField setDelegate:self];
    [self.urlTextfield setDelegate:self];
    [self.notesTextField setDelegate:self];
    self.titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Title" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.notesTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Notes" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.urlTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"URL" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    //get keyboard size
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

- (void)keyboardWillChange:(NSNotification *)notification {
    keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
}

- (void)viewDidLayoutSubviews
{
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setBounces:YES];
    [self.scrollView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, SCROLLVIEW_CONTENT_HEIGHT)];
}

- (IBAction)cancelButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)locationSearchClicked:(id)sender
{
#warning show indicator
    [self dismissDatePicker];
    LocationSearchViewController *locationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"locationsearchview"];
    locationViewController.locationSearchViewControllerDelegate = self;
    [self presentViewController:locationViewController animated:YES completion:^{
    }];
}

-(void)locationSearchViewControllerDismissed:(NSString *)venueName andLatitude:(CGFloat)latitude andLongtitude:(CGFloat)longtitude
{
    [self.locationLabel setTextColor:[UIColor blackColor]];
    [self.locationLabel setText:venueName];
    
    //set latitude and longtitude
    self.latitude = latitude;
    self.longtitude = longtitude;
}

- (IBAction)startsButtonClicked:(id)sender
{
    //reisgn textFields
    [self.titleTextField resignFirstResponder];
    [self.urlTextfield resignFirstResponder];
    [self.notesTextField resignFirstResponder];
    
    for (UIView *subview in [self.view subviews]) {
        if (subview == datePickerView) {
            [subview removeFromSuperview];
        }
    }
    
    datePickerCreator = [[DatePickerCreator alloc] init];
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
    [self.urlTextfield resignFirstResponder];
    [self.notesTextField resignFirstResponder];
    
    for (UIView *subview in [self.view subviews]) {
        if (subview == datePickerView) {
            [subview removeFromSuperview];
        }
    }
    
    datePickerCreator = [[DatePickerCreator alloc] init];
    datePickerView = [[UIView alloc] init];
    datePickerView = [datePickerCreator createDatePickerWithViewController:self withTag:1];
    [self.view addSubview:datePickerView];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd, yyyy  HH:mm"];
    dateSelected = [dateFormatter stringFromDate:date];

}

//Manage events objects
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

//-(void)setReceiveList:(NSArray*)list{
//    self.receive = [NSKeyedArchiver archivedDataWithRootObject:list];
//}
//
//-(NSArray*)getReceiveList{
//    return [NSKeyedUnarchiver unarchiveObjectWithData:self.receive];
//}

#pragma mark - Done button clicked
- (IBAction)DoneButtonClicked:(id)sender
{
    if ([self.titleTextField.text isEqualToString:@""])
    {
        AlertViewCreator *alertViewCreator = [[AlertViewCreator alloc] init];
        [self.view addSubview:[alertViewCreator createAlertViewWithViewController:self andText:@"What's the meetup called?"]];
    }
    else if ([self.locationLabel.text isEqualToString:@"Where?"] && self.latitude == 0 && self.longtitude == 0)
    {
        AlertViewCreator *alertViewCreator = [[AlertViewCreator alloc] init];
        [self.view addSubview:[alertViewCreator createAlertViewWithViewController:self andText:@"Where's the meetup?"]];
    }
    else if ([self.startLabel.text isEqualToString:@"Starts"])
    {
        AlertViewCreator *alertViewCreator = [[AlertViewCreator alloc] init];
        [self.view addSubview:[alertViewCreator createAlertViewWithViewController:self andText:@"When does the meetup start?"]];
    }
    else if ([self.endsLabel.text isEqualToString:@"Ends"])
    {
        AlertViewCreator *alertViewCreator = [[AlertViewCreator alloc] init];
        [self.view addSubview:[alertViewCreator createAlertViewWithViewController:self andText:@"When does the meetup end?"]];
    }
    else
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        
        // Create a new managed object
        NSManagedObject *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Events" inManagedObjectContext:context];
        [newEvent setValue:self.titleTextField.text forKey:@"title"];
        [newEvent setValue:[NSNumber numberWithFloat:self.latitude] forKey:@"lat"];
        [newEvent setValue:[NSNumber numberWithFloat:self.longtitude] forKey:@"long"];
        [newEvent setValue:self.startLabel.text forKey:@"startDate"];
        [newEvent setValue:self.endsLabel.text forKey:@"endDate"];
        [newEvent setValue:[NSKeyedArchiver archivedDataWithRootObject:invitedFriendsArray] forKey:@"invitees"];
        [newEvent setValue:[NSKeyedArchiver archivedDataWithRootObject:invitedFriendsTokenArray] forKey:@"devicetoken"];
        [newEvent setValue:self.urlTextfield.text forKey:@"url"];
        [newEvent setValue:self.notesTextField.text forKey:@"notes"];
        [newEvent setValue:self.locationLabel.text forKey:@"location"];
        
        NSError *error = nil;
        // Save the object to persistent store
        if (![context save:&error]) {
            NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        }
        
        // Fetch the events from persistent data store
        //    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        //    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Events"];
        //    titleArray = [[NSMutableArray alloc] init];
        //    NSString *string;
        //    string = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        
        KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"loginData" accessGroup:nil];
        NSString *usernameString = [keychain objectForKey:(__bridge id)kSecAttrAccount];
        
        //sending push to other invitees
        if ([self.urlTextfield.text isEqualToString:@""] && ![self.notesTextField.text isEqualToString:@""])
        {
            SendNotificationProxy *sendNotificationProxy = [[SendNotificationProxy alloc] init];
            [sendNotificationProxy sendNotificationWithTitle:self.titleTextField.text andLocation:self.locationLabel.text andLatitude:self.latitude andLatitude:self.longtitude andStartDate:self.startLabel.text andEndDate:self.endsLabel.text andURL:@"None" andNotes:self.notesTextField.text andInvitees:inviteesArrayForCoreData andInviter:usernameString];
        }
        else if (![self.urlTextfield.text isEqualToString:@""] && [self.notesTextField.text isEqualToString:@""])
        {
            SendNotificationProxy *sendNotificationProxy = [[SendNotificationProxy alloc] init];
            [sendNotificationProxy sendNotificationWithTitle:self.titleTextField.text andLocation:self.locationLabel.text andLatitude:self.latitude andLatitude:self.longtitude andStartDate:self.startLabel.text andEndDate:self.endsLabel.text andURL:self.urlTextfield.text andNotes:@"None" andInvitees:inviteesArrayForCoreData andInviter:usernameString];
        }
        else if ([self.urlTextfield.text isEqualToString:@""] && [self.notesTextField.text isEqualToString:@""])
        {
            SendNotificationProxy *sendNotificationProxy = [[SendNotificationProxy alloc] init];
            [sendNotificationProxy sendNotificationWithTitle:self.titleTextField.text andLocation:self.locationLabel.text andLatitude:self.latitude andLatitude:self.longtitude andStartDate:self.startLabel.text andEndDate:self.endsLabel.text andURL:@"None" andNotes:@"None" andInvitees:inviteesArrayForCoreData andInviter:usernameString];
        }
        else
        {
            SendNotificationProxy *sendNotificationProxy = [[SendNotificationProxy alloc] init];
            [sendNotificationProxy sendNotificationWithTitle:self.titleTextField.text andLocation:self.locationLabel.text andLatitude:self.latitude andLatitude:self.longtitude andStartDate:self.startLabel.text andEndDate:self.endsLabel.text andURL:self.urlTextfield.text andNotes:self.notesTextField.text andInvitees:inviteesArrayForCoreData andInviter:usernameString];
        }
    }
}

- (IBAction)inviteeButtonClicked:(id)sender
{
    InviteeViewController *inviteeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"inviteeview"];
    inviteeViewController.myDelegate = self;
    [self presentViewController:inviteeViewController animated:YES completion:nil];
}

- (void)inviteeViewControllerDismissed:(NSArray *)inviteesArray andToken:(NSArray *)tokenArray
{
//    NSLog(@"inviteesArray: %@", inviteesArray);
//    NSLog(@"token: %@", tokenArray);
    invitedFriendsArray = [NSArray arrayWithArray:inviteesArray];
    invitedFriendsTokenArray = [NSArray arrayWithArray:tokenArray];
    NSString *inviteesString = @"";
    
    for (int i = 0; i < [inviteesArray count]; i++)
    {
        inviteesString = [inviteesString stringByAppendingString:[NSString stringWithFormat:@"%@, ", [inviteesArray objectAtIndex:i]]];
    }
    [self.inviteeLabel setText:[NSString stringWithFormat:@"%@", inviteesString]];
    [self.inviteeLabel setTextColor:[UIColor blackColor]];
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
#warning if else check any field is missing...
#warning save in nsuserdefaults??
#warning update in main view controller
    [self.titleTextField resignFirstResponder];
    [self.urlTextfield resignFirstResponder];
    [self.notesTextField resignFirstResponder];
    return YES;
}

#pragma mark - didBeginEditing
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self dismissDatePicker];
    if (textField == self.urlTextfield)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 70)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
//        self.view.frame = CGRectMake(self.scrollView.frame.origin.x , (self.scrollView.frame.origin.y - keyboardHeight - [self textfieldScrollUpHeight]), self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - [self textfieldScrollUpHeight]), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        textField.returnKeyType = UIReturnKeyDefault;
    }
    if (textField == self.notesTextField)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 70)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y - [self textfieldScrollUpHeight] - 20), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        textField.returnKeyType = UIReturnKeyDefault;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.urlTextfield)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 70)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + [self textfieldScrollUpHeight]), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        textField.returnKeyType = UIReturnKeyDefault;
    }
    if (textField == self.notesTextField)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 70)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationBeginsFromCurrentState:YES];
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + [self textfieldScrollUpHeight] + 20), self.view.frame.size.width, self.view.frame.size.height);
        //(self.scrollView.frame.origin.y + keyboardHeight + [self textfieldScrollUpHeight] + 20)
        [UIView commitAnimations];
        textField.returnKeyType = UIReturnKeyDefault;
    }
}

@end
