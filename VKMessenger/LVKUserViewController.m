//
//  LVKUserViewController.m
//  VKMessenger
//
//  Created by Leonid Repin on 08.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKUserViewController.h"

@interface LVKUserViewController ()

@end

@implementation LVKUserViewController

@synthesize user, photo, name;

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
    
    [[self navigationItem] setTitle:[user fullName]];
    
    [name setText:[user fullName]];
    [photo setImageWithURL:[user getPhoto:200]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
