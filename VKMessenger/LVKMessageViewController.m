//
//  LVKMessageViewController.m
//  VKMessenger
//
//  Created by Leonid Repin on 05.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMessageViewController.h"
#import "LVKUserViewController.h"
#import "LVKMessage.h"
#import "LVKMessageCollectionViewDelegate.h"
#import "LVKDefaultMessagesCollectionView.h"

@interface LVKMessageViewController ()

@end

@implementation LVKMessageViewController

@synthesize message;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    self.collectionViewDelegate = [[LVKMessageCollectionViewDelegate alloc] initWithData:self.message];

    self.collectionView.delegate = self.collectionViewDelegate;
    self.collectionView.dataSource = self.collectionViewDelegate;
    self.collectionView.isFullWidth = YES;
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.message = nil;
    self.collectionView = nil;
    self.collectionViewDelegate = nil;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showUserInfo"]) {
        LVKUser *object = [message user];
        
        [(LVKUserViewController *)[segue destinationViewController] setUser:object];
    }
}

@end
