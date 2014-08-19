//
//  DatePickerCreator.m
//  MeetMeUp
//
//  Created by Tanya on 8/17/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import "DatePickerCreator.h"

@implementation DatePickerCreator

- (UIView *) createDatePickerWithViewController:(UIViewController *)viewController withTag:(int)tag
{
//    UIView *wholePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, viewController.view.frame.size.height - 258, viewController.view.frame.size.width, 258)];
    UIView *wholePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, viewController.view.frame.size.height + 1, viewController.view.frame.size.width, 258)];
    [wholePickerView setBackgroundColor:[UIColor clearColor]];
    
    UIView *datePickerView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 310, 200)];
    [datePickerView setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:1.0f]];
    [datePickerView.layer setCornerRadius:10.0f];
    [datePickerView.layer setMasksToBounds:YES];

    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 300, 190)];
    [datePicker setBackgroundColor:[UIColor clearColor]];
    [datePicker.layer setCornerRadius:5.0f];
    [datePicker addTarget:viewController action:@selector(dateSelected:) forControlEvents:UIControlEventValueChanged];
    [wholePickerView addSubview:datePickerView];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(5, datePickerView.frame.origin.y + datePickerView.frame.size.height + 3, 152.5, 40)];
    [cancelButton setTag:tag];
    [cancelButton.layer setCornerRadius:10.0f];
    [cancelButton.layer setMasksToBounds:YES];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [cancelButton addTarget:viewController action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.9f]];
    [wholePickerView addSubview:cancelButton];
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(161.5, datePickerView.frame.origin.y + datePickerView.frame.size.height + 3, 152.5, 40)];
    [doneButton setTag:tag];
    [doneButton.layer setCornerRadius:10.0f];
    [doneButton.layer setMasksToBounds:YES];
    [doneButton addTarget:viewController action:@selector(doneDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor colorWithRed:249.0f/255.0f green:103.0f/255.0f blue:30.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];    [doneButton setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.9f]];
    [wholePickerView addSubview:doneButton];
    
    [datePickerView addSubview:datePicker];
    
    [UIView animateWithDuration:0.2 animations:^{
        [wholePickerView setFrame:CGRectMake(0, viewController.view.frame.size.height - 258, viewController.view.frame.size.width, 258)];
    } completion:^(BOOL finished) {
        
    }];
    
    return wholePickerView;
}



@end
