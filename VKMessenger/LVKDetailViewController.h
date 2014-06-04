//
//  LVKDetailViewController.h
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>
#import "LVKHistoryCollection.h"
#import "LVKDialog.h"
#import "LVKLongPollNewMessage.h"

@interface LVKDetailViewController : UITableViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) LVKDialog *dialog;

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *textField;

-(IBAction) textFieldDoneEditing:(id)sender;

@end
