//
//  LoginProxy.h
//  MeetMeUp
//
//  Created by Tanya on 8/5/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginProxy : NSObject

- (void) loginWithUsername:(NSString *)username andPassword:(NSString *)password andViewController:(UIViewController *)viewController andDeviceToken:(NSString *)deviceToken;

@end
