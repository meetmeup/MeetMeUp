//
//  NotificationProxy.m
//  MeetMeUp
//
//  Created by Tanya on 9/3/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "NotificationProxy.h"

@implementation NotificationProxy


- (void) getNotificationWithUsername:(NSString *)username
{
    __block NSMutableArray *inviterArray = [[NSMutableArray alloc] init];
    __block NSMutableArray *eventNameArray = [[NSMutableArray alloc] init];
    __block NSMutableArray *eventLocationArray = [[NSMutableArray alloc] init];
    __block NSMutableArray *startArray = [[NSMutableArray alloc] init];
    __block NSMutableArray *endArray = [[NSMutableArray alloc] init];
    __block NSMutableArray *latArray = [[NSMutableArray alloc] init];
    __block NSMutableArray *longArray = [[NSMutableArray alloc] init];
    __block NSMutableArray *uniqueIDArray = [[NSMutableArray alloc] init];
    __block NSMutableArray *urlArray = [[NSMutableArray alloc] init];
    __block NSMutableArray *notesArray = [[NSMutableArray alloc] init];
    
    NSString *requestURL;
    
    requestURL = [NSString stringWithFormat:@"http://www.loadfree2u.net/meetmeup/meetmeup_notifications.php?username=%@", username];
    
    NSLog(@"url: %@", requestURL);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:[NSURL URLWithString:requestURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                
                NSArray* jsonRawResponse = [NSJSONSerialization
                                            JSONObjectWithData:data
                                            options:kNilOptions
                                            error:&error];
                
//                NSLog(@"resultString: %@", jsonRawResponse);
                
                //if no result
                if ([jsonRawResponse count] == 0)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([self.delegate respondsToSelector:@selector(notificationProxyDidFinishLoad:event:location:startDateArray:endDateArray:latitude:longtitude:uniqueID:eventURL:eventNotes:)])
                        {
                            [self.delegate notificationProxyDidFinishLoad:inviterArray event:eventNameArray location:eventLocationArray startDateArray:startArray endDateArray:endArray latitude:latArray longtitude:longArray uniqueID:uniqueIDArray eventURL:urlArray eventNotes:notesArray];
                        }
                    });
                }
                else
                {
                    NSDictionary *dictionaryResponse = [NSJSONSerialization
                                                        JSONObjectWithData:data
                                                        options:kNilOptions
                                                        error:&error];
                    
                    NSArray *eventDetailsArray = [dictionaryResponse objectForKey:@"meetmeup_user"];
                    
                    for (int i = 0; i < [eventDetailsArray count]; i++)
                    {
                        [eventNameArray addObject:[[eventDetailsArray objectAtIndex:i] objectForKey:@"event_title"]];
                        [eventLocationArray addObject:[[eventDetailsArray objectAtIndex:i] objectForKey:@"event_location"]];
                        [latArray addObject:[[eventDetailsArray objectAtIndex:i] objectForKey:@"event_lat"]];
                        [longArray addObject:[[eventDetailsArray objectAtIndex:i] objectForKey:@"event_long"]];
                        [startArray addObject:[[eventDetailsArray objectAtIndex:i] objectForKey:@"event_start"]];
                        [endArray addObject:[[eventDetailsArray objectAtIndex:i] objectForKey:@"event_end"]];
                        [inviterArray addObject:[[eventDetailsArray objectAtIndex:i] objectForKey:@"event_inviter"]];
                        [urlArray addObject:[[eventDetailsArray objectAtIndex:i] objectForKey:@"event_url"]];
                        [notesArray addObject:[[eventDetailsArray objectAtIndex:i] objectForKey:@"event_notes"]];
                        [uniqueIDArray addObject:[[eventDetailsArray objectAtIndex:i] objectForKey:@"event_uniqueid"]];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([self.delegate respondsToSelector:@selector(notificationProxyDidFinishLoad:event:location:startDateArray:endDateArray:latitude:longtitude:uniqueID:eventURL:eventNotes:)])
                        {
                            [self.delegate notificationProxyDidFinishLoad:inviterArray event:eventNameArray location:eventLocationArray startDateArray:startArray endDateArray:endArray latitude:latArray longtitude:longArray uniqueID:uniqueIDArray eventURL:urlArray eventNotes:notesArray];
                        }
                    });

                }
                
            }] resume];
}

@end
