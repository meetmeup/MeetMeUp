//
//  AcceptAlertViewCreator.m
//  MeetMeUp
//
//  Created by Tanya on 8/27/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "AcceptAlertViewCreator.h"

#define ALERT_VIEW_HEIGHT 121
#define ALERT_VIEW_WIDTH 286.5
#define ALERT_VIEW_COLOR [UIColor colorWithRed:250.0f/255.0f green:63.0f/255.0f blue:82.0f/255.0f alpha:0.90f]
#define ALERT_VIEW_HIDE_FRAME CGRectMake(17, viewController.view.bounds.origin.y-ALERT_VIEW_HEIGHT, ALERT_VIEW_WIDTH, ALERT_VIEW_HEIGHT)
#define ALERT_VIEW_SHOW_FRAME CGRectMake(17, viewController.view.bounds.origin.y, ALERT_VIEW_WIDTH, ALERT_VIEW_HEIGHT)

@interface AcceptAlertViewCreator()
{
    UIView *alertView;
}

@end

@implementation AcceptAlertViewCreator

- (UIView *) createAlertViewWithViewController:(UIViewController *)viewController andText:(NSString *)alertText
{
    alertView = [[UIView alloc] init];
    [alertView setFrame:ALERT_VIEW_HIDE_FRAME];
    
    UIImageView *alertBGImageView = [[UIImageView alloc] init];
    [alertBGImageView setImage:[UIImage imageNamed:@"AcceptAlert_BG.png"]];
    [alertBGImageView setFrame:CGRectMake(17, 25, ALERT_VIEW_WIDTH, ALERT_VIEW_HEIGHT)];
    [alertBGImageView setContentMode:UIViewContentModeScaleAspectFit];
    [alertView setBackgroundColor:[UIColor colorWithPatternImage:alertBGImageView.image]];
    
    
    UILabel *alertViewLabel = [[UILabel alloc] init];
    [alertViewLabel setFrame:CGRectMake(viewController.view.bounds.origin.x, 15, ALERT_VIEW_WIDTH, ALERT_VIEW_HEIGHT)];
    [alertViewLabel setTextAlignment:NSTextAlignmentCenter];
    [alertViewLabel setTextColor:[UIColor whiteColor]];
    [alertViewLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [alertViewLabel setText:alertText];
    [alertView addSubview:alertViewLabel];
    
    CGPoint originalCenter = alertView.center;
    
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         CGPoint center = alertView.center;
//                         center.y += ALERT_VIEW_HEIGHT;
//                         alertView.center = center;
//                     }
//                     completion:^(BOOL finished){
//                         [UIView animateWithDuration:0.3 delay:1.5 options:UIViewAnimationOptionTransitionNone animations:^{
//                             alertView.center = originalCenter;
//                         } completion:nil];
//                         
//                     }];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGPoint center = alertView.center;
                         center.y += ALERT_VIEW_HEIGHT  + 25;
                         alertView.center = center;
                     }
                     completion:^(BOOL finished){
                         
                     }];

    
    return alertView;
}

@end
