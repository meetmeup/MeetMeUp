//
//  SignUpProxy.h
//  MeetMeUp
//
//  Created by Tanya on 8/8/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUpProxy : NSObject<NSURLSessionDelegate>

- (void) signUpUserWithEmail:(NSString *)email username:(NSString *)username password:(NSString *)password photo:(UIImage *)photo;

@end
