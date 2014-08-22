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

#define TEXTFIELD_SCROLL_UP_HEIGHT (self.view.frame.size.height == 568.0f ? 70 : 70)
#define SCROLLVIEW_CONTENT_HEIGHT (self.view.frame.size.height == 568.0f ? 568 : 568)
#define SCROLLVIEW_HEIGHT (self.view.frame.size.height == 568.0f ? 568 : 480)



@interface AddEventViewController ()<UITextFieldDelegate, LocationSearchDelegate, UITableViewDataSource, UITableViewDelegate>
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
    
    mainString = @"";
    inviteesArrayForCoreData = [[NSMutableArray alloc] init];
    
    //set backgrounf color
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"AddEvent_WhiteBG.png"]]];
    
    [self.titleTextField setDelegate:self];
    [self.inviteeTextField setDelegate:self];
    [self.urlTextfield setDelegate:self];
    [self.notesTextField setDelegate:self];
    self.titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Title" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.inviteeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Who's going?" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.notesTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Notes" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.urlTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"URL" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}


- (void)viewDidLayoutSubviews
{
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setBounces:YES];
    [self.scrollView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.height, SCROLLVIEW_HEIGHT)];
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
    [self.inviteeTextField resignFirstResponder];
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
    [self.inviteeTextField resignFirstResponder];
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
    //save
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Events" inManagedObjectContext:context];
    [newEvent setValue:self.titleTextField.text forKey:@"title"];
    [newEvent setValue:[NSNumber numberWithFloat:self.latitude] forKey:@"lat"];
    [newEvent setValue:[NSNumber numberWithFloat:self.longtitude] forKey:@"long"];
    [newEvent setValue:self.startLabel.text forKey:@"startDate"];
    [newEvent setValue:self.endsLabel.text forKey:@"endDate"];
    [newEvent setValue:[NSKeyedArchiver archivedDataWithRootObject:inviteesArrayForCoreData] forKey:@"invitees"];
    [newEvent setValue:self.urlTextfield.text forKey:@"url"];
    [newEvent setValue:self.notesTextField.text forKey:@"notes"];
    [newEvent setValue:self.locationLabel.text forKey:@"location"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    // Fetch the events from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Events"];
    titleArray = [[NSMutableArray alloc] init];
    NSString *string;
    string = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSLog(@"String title: %@", string);
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
    [self.inviteeTextField resignFirstResponder];
    [self.urlTextfield resignFirstResponder];
    [self.notesTextField resignFirstResponder];
    return YES;
}

#pragma mark - didBeginEditing
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self dismissDatePicker];
    
    if (textField == self.inviteeTextField)
    {
        //invitee textfield accessory view
        friendsChoicesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.inviteeTextField.frame.size.height + self.inviteeTextField.frame.origin.y + 5, 320, 100)];
        [friendsChoicesTableView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
        [friendsChoicesTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [friendsChoicesTableView setDelegate:self];
        [friendsChoicesTableView setDataSource:self];
        [textField setInputAccessoryView:friendsChoicesTableView];
        
        if (self.view.frame.size.height != 568.0f)
        {
            [self.scrollView setContentOffset:CGPointMake(0, 100)];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.scrollView.frame.origin.x , (self.scrollView.frame.origin.y - 150), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            textField.returnKeyType = UIReturnKeyDefault;
        }
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.scrollView.frame.origin.x , (self.scrollView.frame.origin.y - 150), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            textField.returnKeyType = UIReturnKeyDefault;
        }
    }
    if (textField == self.urlTextfield)
    {
        if (self.view.frame.size.height != 568.0f)
        {
            [self.scrollView setContentOffset:CGPointMake(0, 70)];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.scrollView.frame.origin.x , (self.scrollView.frame.origin.y - TEXTFIELD_SCROLL_UP_HEIGHT*2), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            textField.returnKeyType = UIReturnKeyDefault;
        }
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.scrollView.frame.origin.x , (self.scrollView.frame.origin.y - TEXTFIELD_SCROLL_UP_HEIGHT*2), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            textField.returnKeyType = UIReturnKeyDefault;
        }
    }
    if (textField == self.notesTextField)
    {
        if (self.view.frame.size.height != 568.0f)
        {
            [self.scrollView setContentOffset:CGPointMake(0, 70)];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.scrollView.frame.origin.x , (self.scrollView.frame.origin.y - TEXTFIELD_SCROLL_UP_HEIGHT*3), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            textField.returnKeyType = UIReturnKeyDefault;
        }
        else
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationBeginsFromCurrentState:YES];
            self.view.frame = CGRectMake(self.scrollView.frame.origin.x , (self.scrollView.frame.origin.y - TEXTFIELD_SCROLL_UP_HEIGHT*3), self.view.frame.size.width, self.view.frame.size.height);
            [UIView commitAnimations];
            textField.returnKeyType = UIReturnKeyDefault;
        }
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
        self.view.frame = CGRectMake(self.view.frame.origin.x , (self.view.frame.origin.y + 150), self.view.frame.size.width, self.view.frame.size.height);
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
    inviteesSearchArray = [[NSMutableArray alloc] init];
    inviteesImageSearchArray = [[NSMutableArray array] init];
    
    if (textField == self.inviteeTextField)
    {
        [self.inviteeTextField setInputAccessoryView:friendsChoicesTableView];
        NSString *searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        int seperatorFound = [[searchText componentsSeparatedByString:@","] count]-1;
        
        if (seperatorFound == 0)
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *savedFriendsArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"USER_FRIENDS_ARRAY"]];
            NSMutableArray *savedFriendsPhotoArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"USER_PHOTO_ARRAY"]];
            
            for (NSString *str in savedFriendsArray)
            {
                if (savedFriendsArray.count > 0)
                {
                    NSRange stringRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (stringRange.location != NSNotFound)
                    {
                        [inviteesSearchArray addObject:str];
                        NSUInteger index = [savedFriendsArray indexOfObject:str];
                        [inviteesImageSearchArray addObject:[savedFriendsPhotoArray objectAtIndex:index]];
                    }
                }
            }
        }
        else if (seperatorFound != 0)
        {
            NSArray *array = [searchText componentsSeparatedByString:@","];
            NSLog(@"array: %@", array);
            
            NSString *lastObject = [array objectAtIndex:[array count]-1];
            NSLog(@"last object: %@", lastObject);
            
            NSString *check = [lastObject substringToIndex:1];
            if ([check isEqualToString:@" "])
            {
                lastObject = [lastObject substringWithRange:NSMakeRange(1, [lastObject length]-1)];
            }

            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSMutableArray *savedFriendsArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"USER_FRIENDS_ARRAY"]];
            NSMutableArray *savedFriendsPhotoArray = [[NSMutableArray alloc] initWithArray:[userDefaults objectForKey:@"USER_PHOTO_ARRAY"]];
            
            for (NSString *str in savedFriendsArray)
            {
                if (savedFriendsArray.count > 0)
                {
                    NSRange stringRange = [str rangeOfString:lastObject options:NSCaseInsensitiveSearch];
                    if (stringRange.location != NSNotFound)
                    {
                        [inviteesSearchArray addObject:str];
                        NSUInteger index = [savedFriendsArray indexOfObject:str];
                        [inviteesImageSearchArray addObject:[savedFriendsPhotoArray objectAtIndex:index]];
                    }
                }
            }
        }
    }
    [friendsChoicesTableView reloadData];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [inviteesSearchArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *cellTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 11, 300, 20)];
        [cellTextLabel setTextColor:[UIColor colorWithRed:44.0/255.0f green:44.0/255.0f blue:44.0/255.0f alpha:1.0f]];
        [cellTextLabel setFont:[UIFont fontWithName:@"Helvetica-Medium" size:16.0f]];
        [cellTextLabel setTag:1];
        [cell.contentView addSubview:cellTextLabel];
        
        AsyncImageView *asyncImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(25, 6, 32, 32)];
        [asyncImage.layer setCornerRadius:asyncImage.frame.size.height/2.0f];
        [asyncImage setTag:2];
        [cell.contentView addSubview:asyncImage];
        
    }
    
    [(UILabel *) [cell.contentView viewWithTag:1] setText:[inviteesSearchArray objectAtIndex:indexPath.row]];
    NSURL *url = [NSURL URLWithString:[inviteesImageSearchArray objectAtIndex:indexPath.row]];
    [(AsyncImageView *) [cell.contentView viewWithTag:2] loadImageWithTypeFromURL:url contentMode:UIViewContentModeScaleAspectFit imageNameBG:nil];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [inviteesArrayForCoreData addObject:[inviteesSearchArray objectAtIndex:indexPath.row]];
    
    NSString *entryString = [inviteesSearchArray objectAtIndex:indexPath.row];
    entryString = [entryString stringByAppendingString:@", "];
    entryString = [@"@" stringByAppendingString:entryString];
    
    //use mainString when update textField
    mainString = [mainString stringByAppendingString:entryString];
    
    
    [self.inviteeTextField setText:mainString];
    [self.inviteeTextField setTextColor:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f]];
    
    [friendsChoicesTableView reloadData];

    
}

@end
