//
//  NotificationProxy.h
//  MeetMeUp
//
//  Created by Tanya on 9/3/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NotificationProxyDelegate;

@interface NotificationProxy : NSObject
{
    id<NotificationProxyDelegate> delegate;
}

@property (nonatomic, assign) id<NotificationProxyDelegate> delegate;
- (void) getNotificationWithUsername:(NSString *)username;
@end

@protocol NotificationProxyDelegate <NSObject>

- (void) notificationProxyDidFinishLoad:(NSArray *)inviterArray event:(NSArray *)eventNameArray location:(NSArray *)eventLocationArray startDateArray:(NSArray *)startArray endDateArray:(NSArray *)endArray latitude:(NSArray *)latArray longtitude:(NSArray *)longArray uniqueID:(NSArray *)uniqueIDArray eventURL:(NSArray *)urlArray eventNotes:(NSArray *)notesArray;

@end
