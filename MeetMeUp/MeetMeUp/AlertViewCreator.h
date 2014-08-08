//
//  AlertViewCreator.h
//  MeetMeUp
//
//  Created by Tanya on 8/8/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertViewCreator : NSObject

- (UIView *) createAlertViewWithViewController:(UIViewController *)viewController andText:(NSString *)alertText;

@end
