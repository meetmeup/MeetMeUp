//
//  DatePickerCreator.h
//  MeetMeUp
//
//  Created by Tanya on 8/17/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatePickerCreator : NSObject

- (UIView *) createDatePickerWithViewController:(UIViewController *)viewController withTag:(int)tag;

@end
