//
//  MainTableViewView.h
//  MeetMeUp
//
//  Created by Tanya on 8/11/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainTableViewView : NSObject<UITableViewDataSource, UITableViewDelegate>

- (UIView *) createMainTableViewWithRect:(CGRect) rect;

@end
