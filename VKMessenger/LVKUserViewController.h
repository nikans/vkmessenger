//
//  LVKUserViewController.h
//  VKMessenger
//
//  Created by Leonid Repin on 08.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIImageView+WebCache.h>
#import "LVKUser.h"

@interface LVKUserViewController : UIViewController

@property (strong, nonatomic) LVKUser *user;
@property (strong, nonatomic) IBOutlet UIImageView *photo;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end
