//
//  LVKUserPickerViewController.h
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>
#import <UIImageView+WebCache.h>
#import "UIViewController+NetworkNotifications.h"
#import "LVKDialogViewController.h"
#import "LVKUsersCollection.h"

@interface LVKUserPickerViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIViewController *callerViewController;

- (IBAction)closeModal:(id)sender;

@end
