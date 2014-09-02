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
#define IsIphone5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@interface AcceptAlertViewCreator()
{
    UIView *alertView;
}

@end

@implementation AcceptAlertViewCreator

- (UIView *) createAlertViewWithViewController:(UIViewController *)viewController andText:(NSString *)alertText
{

    UIView *shadowView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [shadowView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f]];
    
    UIImageView *alertBGImageView = [[UIImageView alloc] init];
    UIImage *alertViewBGImage = [UIImage imageNamed:@"AcceptAlert_BG.png"];
    [alertBGImageView setImage:alertViewBGImage];
    [alertBGImageView setFrame:CGRectMake((viewController.view.frame.size.width - alertViewBGImage.size.width)/2, 0 - alertViewBGImage.size.height, alertViewBGImage.size.width, alertViewBGImage.size.height)];
    [alertBGImageView setContentMode:UIViewContentModeScaleAspectFit];
    alertView = [[UIView alloc] init];
    [alertView setFrame:alertBGImageView.frame];
    [alertView setBackgroundColor:[UIColor colorWithPatternImage:alertBGImageView.image]];
    
    CGRect alertLabelFrame = CGRectMake(alertBGImageView.frame.origin.x + 10, 17, alertBGImageView.frame.size.width - 36, 150);
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:alertLabelFrame];
    [alertLabel setBackgroundColor:[UIColor clearColor]];
    [alertLabel setText:alertText];
    [alertLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    [alertLabel setFont:[UIFont fontWithName:@"Helvetica-Regular" size:10.0f]];
    [alertLabel setTextAlignment:NSTextAlignmentCenter];
    [alertLabel setNumberOfLines:0];
    [alertLabel sizeToFit];
    [alertView addSubview:alertLabel];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(alertBGImageView.frame.origin.x + 7, alertBGImageView.frame.origin.y + 122, 123, 48)];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setShowsTouchWhenHighlighted:YES];
    [cancelButton addTarget:viewController action:@selector(invitationCancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    [cancelButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [alertView addSubview:cancelButton];
    
    UIButton *acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(alertBGImageView.frame.origin.x + 140, alertBGImageView.frame.origin.y + 122, 123, 48)];
    [acceptButton setBackgroundColor:[UIColor clearColor]];
    [acceptButton setShowsTouchWhenHighlighted:YES];
    [acceptButton addTarget:viewController action:@selector(invitationAcceptButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
    [acceptButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    [acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alertView addSubview:acceptButton];
    
    
    
    float heightIncrement = 300.0;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [alertView setFrame:CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y + heightIncrement, alertView.frame.size.width, alertView.frame.size.height)];
                         [shadowView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.70f]];
                         [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, cancelButton.frame.origin.y + 210, cancelButton.frame.size.width, cancelButton.frame.size.height)];
                         [acceptButton setFrame:CGRectMake(acceptButton.frame.origin.x, acceptButton.frame.origin.y + 210, acceptButton.frame.size.width, acceptButton.frame.size.height)];
//                         [alertTextView setFrame:CGRectMake(alertBGImageView.frame.origin.x + 10, 17 + 70, alertBGImageView.frame.size.width - 50, 200)];
                         CGRect alertLabelNewFrame = alertLabel.frame;
                         alertLabelNewFrame.origin.y = 17 + 59;
                         [alertLabel setFrame:alertLabelNewFrame];
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [shadowView addSubview:alertView];

    
    return shadowView;
    
}




@end
