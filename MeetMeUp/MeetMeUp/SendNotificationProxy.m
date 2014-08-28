//
//  SendNotificationProxy.m
//  MeetMeUp
//
//  Created by Tanya on 8/26/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "SendNotificationProxy.h"

@implementation SendNotificationProxy

- (void) sendNotificationWithTitle:(NSString *)titleString andLocation:(NSString *)locationString andLatitude:(float)longtitude andLatitude:(float)latitude andStartDate:(NSString *)startDateString andEndDate:(NSString *)endDateString andURL:(NSString *)urlString andNotes:(NSString *)notesString andInvitees:(NSArray *)inviteesUsernameArray andInviter:(NSString *)inviterUsername
{
    //create user image name
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddhhmmssSSS"];
    NSString *dateString = [dateFormat stringFromDate:today];
    
    NSMutableString *postString = [[NSMutableString alloc] init];
    for (NSString *thing in inviteesUsernameArray) {
        [postString appendFormat:@"unique=%@&title=%@&location=%@&lat=%f&long=%f&start=%@&end=%@&url=%@&notes=%@&invitees[]=%@&inviter=%@",dateString,titleString, locationString, latitude, longtitude, startDateString, endDateString, urlString, notesString, [thing stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], inviterUsername];
    }
    
    NSData* data = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL* url = [NSURL URLWithString:@"http://www.loadfree2u.net/meetmeup/send-notification.php"];
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
