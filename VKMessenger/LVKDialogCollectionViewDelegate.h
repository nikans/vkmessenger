//
//  LVKDialogCollectionViewDelegate.h
//  VKMessenger
//
//  Created by Eliah Nikans on 6/10/14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LVKMessage.h"

@interface LVKDialogCollectionViewDelegate : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) LVKMessage *data;

- (id)initWithData:(LVKMessage *)_data;

@end
