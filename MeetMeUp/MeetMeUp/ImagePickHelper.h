//
//  ImagePickHelper.h
//  MeetMeUp
//
//  Created by Tanya on 8/8/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagePickHelper : NSObject<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (UIImage *) getImageFromLibrayFromViewController:(UIViewController *)viewController;

@end
