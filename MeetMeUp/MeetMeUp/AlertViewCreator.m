//
//  AlertViewCreator.m
//  MeetMeUp
//
//  Created by Tanya on 8/8/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "AlertViewCreator.h"

#define ALERT_VIEW_HEIGHT 40
#define ALERT_VIEW_COLOR [UIColor colorWithRed:250.0f/255.0f green:63.0f/255.0f blue:82.0f/255.0f alpha:0.90f]
#define ALERT_VIEW_HIDE_FRAME CGRectMake(viewController.view.bounds.origin.x, viewController.view.bounds.origin.y-ALERT_VIEW_HEIGHT, viewController.view.bounds.size.width, ALERT_VIEW_HEIGHT)
#define ALERT_VIEW_SHOW_FRAME CGRectMake(viewController.view.bounds.origin.x, viewController.view.bounds.origin.y, viewController.view.bounds.size.width, ALERT_VIEW_HEIGHT)

@interface AlertViewCreator ()
{
    UIView *alertView;
}

@end

@implementation AlertViewCreator

- (UIView *) createAlertViewWithViewController:(UIViewController *)viewController andText:(NSString *)alertText
{
    alertView = [[UIView alloc] init];
    [alertView setBackgroundColor:ALERT_VIEW_COLOR];
    [alertView setFrame:ALERT_VIEW_HIDE_FRAME];
    
    
    UILabel *alertViewLabel = [[UILabel alloc] init];
    [alertViewLabel setFrame:CGRectMake(viewController.view.bounds.origin.x, 7, viewController.view.bounds.size.width, ALERT_VIEW_HEIGHT)];
    [alertViewLabel setTextAlignment:NSTextAlignmentCenter];
    [alertViewLabel setTextColor:[UIColor whiteColor]];
    [alertViewLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [alertViewLabel setText:alertText];
    [alertView addSubview:alertViewLabel];

    CGPoint originalCenter = alertView.center;
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGPoint center = alertView.center;
                         center.y += ALERT_VIEW_HEIGHT;
                         alertView.center = center;
                     }
                     completion:^(BOOL finished){
                         
                         [UIView animateWithDuration:3.0
                                          animations:^{
                                              alertView.center = originalCenter;
                                          }
                                          completion:^(BOOL finished){
                                              ;
                                          }];
                         
                     }];
    
    return alertView;
}

@end
