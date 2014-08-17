//
//  ImageResizer.h
//  MeetMeUp
//
//  Created by Tanya on 8/12/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageResizer : NSObject

- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
