//
//  AddFriendsProxy.m
//  MeetMeUp
//
//  Created by Tanya on 8/17/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import "AddFriendsProxy.h"

@implementation AddFriendsProxy

- (void) retrievedUserByUsingUsernameOrEmail:(NSString *)searchByString withUserOrEmail:(NSString *)userOrEmail
{
    __block NSString *retrievedUsernameString;
    __block NSString *retrievedUserProfileURLString;
    
    NSString *requestURL;
    
    requestURL = [NSString stringWithFormat:@"http://www.loadfree2u.net/meetmeup/meetmeup_searchusername.php?%@=%@", searchByString,userOrEmail];
    
    NSLog(@"url: %@", requestURL);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:[NSURL URLWithString:requestURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                //NSLog(@"RESPONSE: %@", searchLocationResultString);
                
                
                NSDictionary* jsonRawResponse = [NSJSONSerialization
                                                 JSONObjectWithData:data
                                                 options:kNilOptions
                                                 error:&error];
                
                NSArray *userDetailsArray = [jsonRawResponse objectForKey:@"meetmeup_user"];
                retrievedUsernameString = [[userDetailsArray objectAtIndex:0] objectForKey:@"user_username"];
                retrievedUserProfileURLString = [[userDetailsArray objectAtIndex:0] objectForKey:@"user_photo"];
                
    //download here
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.delegate respondsToSelector:@selector(AddFriends:retrievedSearchUser:andUserProfile:)])
        {
            [self.delegate AddFriends:self retrievedSearchUser:retrievedUsernameString andUserProfile:retrievedUserProfileURLString];
        }
    });
                
    }] resume];
}

@end
