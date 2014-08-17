//
//  AddFriendsProxy.h
//  MeetMeUp
//
//  Created by Tanya on 8/17/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  AddFriendsProxyDelegate;

@interface AddFriendsProxy : NSObject

@property (nonatomic, weak) id<AddFriendsProxyDelegate> delegate;

- (void) retrievedUserByUsingUsernameOrEmail:(NSString *)searchByString withUserOrEmail:(NSString *)userOrEmail;

@end

@protocol AddFriendsProxyDelegate <NSObject>

@optional
- (void) AddFriends:(AddFriendsProxy *)searchProxy retrievedSearchUser:(NSString *)username andUserProfile:(NSString *)profileURL;

@end
