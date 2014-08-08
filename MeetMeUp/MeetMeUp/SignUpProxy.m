//
//  SignUpProxy.m
//  MeetMeUp
//
//  Created by Tanya on 8/8/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import "SignUpProxy.h"

@implementation SignUpProxy

//upload data user to server
- (void) signUpUserWithEmail:(NSString *)email username:(NSString *)username password:(NSString *)password photo:(UIImage *)photo
{
    //set header string
    NSString *headerString = @"http://www.loadfree2u.net/meetmeup/";
    
    //create user image name
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd-hh-mm-ss-SSS"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSString *photoURLString = [NSString stringWithFormat:@"%@%@", headerString, dateString];
    
    //set post string
    NSString *postString = [NSString stringWithFormat:@"email=%@&username=%@&password=%@&photourl=%@", email, username, password, photoURLString];
    NSData* data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@meetmeup_userSignIn.php", headerString]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:data];
    
    __block NSString *resultString;
    
    NSURLSessionDataTask* dataTask = [defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           
                                                           if(error == nil)
                                                           {
                                                               resultString = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
                                                               NSLog(@"Data: %@",resultString);
                                                           }
                                                           
                                                           
                                                       }];
    [dataTask resume];
}

@end
