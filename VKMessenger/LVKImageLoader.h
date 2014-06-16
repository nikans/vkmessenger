//
//  LVKImageLoader.h
//  VKMessenger
//
//  Created by Eliah Nikans on 6/16/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/SDWebImageManager.h>

@interface LVKImageLoader : NSObject <SDWebImageManagerDelegate>

+ (instancetype)sharedImageLoader;

@end
