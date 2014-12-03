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
#import <UIButton+WebCache.h>
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
    
    UIButton *avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,36,36)];
    [avatarButton setImageWithURL:self.message.user.photo_100 forState:UIControlStateNormal];
    [avatarButton addTarget:self action:@selector(pushToUserVC) forControlEvents:UIControlEventTouchUpInside];
    avatarButton.layer.cornerRadius = 18.0f;
    avatarButton.layer.masksToBounds = YES;
    
    UIView *avatarButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
    avatarButtonView.bounds = CGRectOffset(avatarButtonView.bounds, -11, 1);
    [avatarButtonView addSubview:avatarButton];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:avatarButtonView];
    
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

- (void)pushToUserVC
{
    LVKUser *user = [message user];
    
    UIStoryboard *storyboard = nil;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    
    LVKUserViewController *userViewController = [storyboard instantiateViewControllerWithIdentifier:@"userViewController"];
    [userViewController setUser:user];
    
    [[self navigationController] pushViewController:userViewController animated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//}

@end
