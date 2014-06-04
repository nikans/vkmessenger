//
//  LVKWelcomeViewController.m
//  VKMessenger
//
//  Created by Leonid Repin on 05.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKWelcomeViewController.h"
#import "LVKAppDelegate.h"

@interface LVKWelcomeViewController ()

@end

@implementation LVKWelcomeViewController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAuthSucceeded:)
                                                 name:@"authSucceeded"
                                               object:nil];
    [self loadMainNavigationViewController];
}

- (void)receiveAuthSucceeded:(NSNotification *)notification
{
    [self loadMainNavigationViewController];
}

- (void)loadMainNavigationViewController
{
    if([VKSdk isLoggedIn])
    {
        UIViewController *viewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"mainNavigationViewController"];
        [(LVKAppDelegate *)[[UIApplication sharedApplication] delegate] presentViewController:viewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPress:(id)sender
{
    [(LVKAppDelegate *)[[UIApplication sharedApplication] delegate] authorize];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
