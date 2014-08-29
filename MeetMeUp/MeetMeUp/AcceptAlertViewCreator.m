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
    for (UIView *view in viewController.view.subviews)
    {
        [view setUserInteractionEnabled:NO];
    }
    
    UIView *shadowView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [shadowView setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.70f]];
    
    UIImageView *alertBGImageView = [[UIImageView alloc] init];
    UIImage *alertViewBGImage = [UIImage imageNamed:@"AcceptAlert_BG.png"];
    [alertBGImageView setImage:alertViewBGImage];
    [alertBGImageView setFrame:CGRectMake((viewController.view.frame.size.width - alertViewBGImage.size.width)/2, 0 - alertViewBGImage.size.height, alertViewBGImage.size.width, alertViewBGImage.size.height)];
    [alertBGImageView setContentMode:UIViewContentModeScaleAspectFit];
    alertView = [[UIView alloc] init];
    [alertView setFrame:alertBGImageView.frame];
    [alertView setBackgroundColor:[UIColor colorWithPatternImage:alertBGImageView.image]];
    
    UITextView *alertViewLabel = [[UITextView alloc] init];
    [alertViewLabel setTextAlignment:NSTextAlignmentCenter];
    [alertViewLabel setText:alertText];
    [alertViewLabel sizeToFit];
    [alertViewLabel setFrame:CGRectMake(viewController.view.bounds.origin.x + 25, 17, 70, 50)];
    [alertViewLabel setTextColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:1.0f]];
    [alertViewLabel setBackgroundColor:[UIColor redColor]];
    [alertViewLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [alertView addSubview:alertViewLabel];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(alertBGImageView.frame.origin.x + 7, alertBGImageView.frame.origin.y + 122, 123, 48)];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setShowsTouchWhenHighlighted:YES];
    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    [cancelButton setTitleColor:[UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [alertView addSubview:cancelButton];
    
    UIButton *acceptButton = [[UIButton alloc] initWithFrame:CGRectMake(alertBGImageView.frame.origin.x + 140, alertBGImageView.frame.origin.y + 122, 123, 48)];
    [acceptButton setBackgroundColor:[UIColor clearColor]];
    [acceptButton setShowsTouchWhenHighlighted:YES];
    [acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
    [acceptButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    [acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [alertView addSubview:acceptButton];
    
    
    
    float heightIncrement = 300.0;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [alertView setFrame:CGRectMake(alertView.frame.origin.x, alertView.frame.origin.y + heightIncrement, alertView.frame.size.width, alertView.frame.size.height)];
                         [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, cancelButton.frame.origin.y + 210, cancelButton.frame.size.width, cancelButton.frame.size.height)];
                         [acceptButton setFrame:CGRectMake(acceptButton.frame.origin.x, acceptButton.frame.origin.y + 210, acceptButton.frame.size.width, acceptButton.frame.size.height)];
                         [alertViewLabel setFrame:CGRectMake(viewController.view.bounds.origin.x + 15, 17 + 70, 276 - (15*2), 25)];
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [shadowView addSubview:alertView];

    
    return shadowView;
    
}



@end
