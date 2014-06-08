//
//  LVKMessageViewController.m
//  VKMessenger
//
//  Created by Leonid Repin on 05.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMessageViewController.h"
#import "LVKUserViewController.h"

@interface LVKMessageViewController ()

@end

@implementation LVKMessageViewController

@synthesize message, photo, name, date, messageText;

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
        
    [name setText:[[message user] fullName]];
    [photo setImageWithURL:[[message user] getPhoto:100]];
    [date setText:[NSDateFormatter localizedStringFromDate:[message date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]];
    [messageText setText:[message body]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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