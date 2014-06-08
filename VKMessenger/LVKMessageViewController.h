//
//  LVKMessageViewController.h
//  VKMessenger
//
//  Created by Leonid Repin on 05.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>
#import <UIImageView+WebCache.h>
#import "LVKMessage.h"

@interface LVKMessageViewController : UIViewController

@property (strong, nonatomic) LVKMessage *message;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UITextView *messageText;

@end
