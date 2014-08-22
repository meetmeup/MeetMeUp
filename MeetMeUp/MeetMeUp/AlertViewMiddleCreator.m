//
//  AlertViewMiddleCreator.m
//  MeetMeUp
//
//  Created by Tanya on 8/21/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "AlertViewMiddleCreator.h"

@implementation AlertViewMiddleCreator

- (UIView *) createAlertViewWithViewController:(UIViewController *)viewController andText:(NSString *)alertText
{
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, 568, 285)];
    [alertView setBackgroundColor:[UIColor colorWithRed:76.0f/255.0f green:76.0f/255.0f blue:76.0f/255.0f alpha:0.7f]];
    
    UILabel *firstLine = [[UILabel alloc] initWithFrame:CGRectMake(0, -1, alertView.frame.size.width, 20)];
    [firstLine setFont:[UIFont fontWithName:@"Helvetica-Medium" size:9.0f]];
    [firstLine setText:@"user has invited you to mink natt mook meeting in sunday"];
    [firstLine setTextColor:[UIColor whiteColor]];
    [alertView addSubview:firstLine];
//    
//    UILabel *secondLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, alertView.frame.size.width, 20)];
//    [firstLine setFont:[UIFont fontWithName:@"Helvetica-Medium" size:9.0f]];
//    [firstLine setText:@"user has invited you to mink natt mook meeting in sunday"];
//    [firstLine setTextColor:[UIColor whiteColor]];
//    [alertView addSubview:firstLine];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 42, alertView.frame.size.width, 20)];
    [textView setTextColor:[UIColor whiteColor]];
    [textView setText:@"username invited you to join \"Meeting with Mink Natt Mook\"\n on 14th December 2014,\n Up for it?"];
    [textView setFont:[UIFont fontWithName:@"Helvetica-Medium" size:9.0f]];
    [alertView addSubview:textView];
    
    UIButton *yesButton = [[UIButton alloc] initWithFrame:CGRectMake(155, 79, 50, 50)];
    [yesButton setImage:[UIImage imageNamed:@"Notification_AcceptButton.png"] forState:UIControlStateNormal];
    [yesButton setImage:[UIImage imageNamed:@"Notification_AcceptButtonClicked.png"] forState:UIControlStateHighlighted];
    [yesButton addTarget:viewController action:@selector(inviteAcceptedButtonClicked) forControlEvents:UIControlEventTouchDragInside];
    [alertView addSubview:yesButton];
    
    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(155, 79, 50, 50)];
    [noButton setImage:[UIImage imageNamed:@"Notification_NotAcceptButton.png"] forState:UIControlStateNormal];
    [noButton setImage:[UIImage imageNamed:@"Notification_NotAcceptButtonClicked.png"] forState:UIControlStateHighlighted];
    [noButton addTarget:viewController action:@selector(inviteNotAcceptedButtonClicked) forControlEvents:UIControlEventTouchDragInside];
    [alertView addSubview:noButton];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        [firstLine setFrame:CGRectMake(0, 42, alertView.frame.size.width, 20)];
    } completion:^(BOOL finished) {
        
    }];
    
    
    
    return alertView;
}

@end
