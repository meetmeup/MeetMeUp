//
//  GetFacebookImageURL.h
//  MeetMeUp
//
//  Created by Tanya on 8/8/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetFacebookImageURL : NSObject

- (NSMutableData *) getFacebookProfileImageFromUerID:(NSString *)idString;

@end
