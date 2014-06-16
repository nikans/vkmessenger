//
//  LVKDialogListControllerDelegate.h
//  VKMessenger
//
//  Created by Eliah Nikans on 6/16/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LVKDialogListControllerDelegate <NSObject>

- (void)setImage:(UIImage *)image forIdentifier:(NSString *)identifier;

@end
