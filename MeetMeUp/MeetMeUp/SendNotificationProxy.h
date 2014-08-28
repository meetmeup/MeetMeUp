//
//  SendNotificationProxy.h
//  MeetMeUp
//
//  Created by Tanya on 8/26/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendNotificationProxy : NSObject<NSURLSessionDelegate>

- (void) sendNotificationWithTitle:(NSString *)titleString andLocation:(NSString *)locationString andLatitude:(float)longtitude andLatitude:(float)latitude andStartDate:(NSString *)startDateString andEndDate:(NSString *)endDateString andURL:(NSString *)urlString andNotes:(NSString *)notesString andInvitees:(NSArray *)inviteesUsernameArray andInviter:(NSString *)inviterUsername;

@end
