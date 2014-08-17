//
//  LocationSearchProxy.h
//  MeetMeUp
//
//  Created by Tanya on 8/16/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationSearchProxyDelegate;

@interface LocationSearchProxy : NSObject

@property (nonatomic, weak) id<LocationSearchProxyDelegate> delegate;

- (void) searchLocationWithClientID:(NSString *)clientIDString andClientSecret:(NSString *)clientSecretString andSearchText:(NSString *)searchString andLatitude:(CGFloat)latitude andLongtitude:(CGFloat)longtitude andVersion:(NSString *)versionString andViewController:(UIViewController *)viewController;

@end

@protocol LocationSearchProxyDelegate <NSObject>

@optional
- (void) searchProxy:(LocationSearchProxy *)searchProxy retrievedSearchResults:(NSMutableArray *)searchResultsArray;

@end
