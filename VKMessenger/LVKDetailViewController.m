//
//  LVKDetailViewController.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDetailViewController.h"
#import "LVKMessageViewController.h"

@interface LVKDetailViewController () {
    NSMutableArray *_objects;
}
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation LVKDetailViewController

@synthesize tableView, textField , dialog;

- (void)receiveNewMessage:(NSNotification *)notification
{
    LVKLongPollNewMessage *newMessageUpdate = [notification object];
    
    if([dialog isEqual:[newMessageUpdate dialog]])
    {
        NSArray *result = [_objects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(LVKMessage *message, NSDictionary *bindings) {
            return [message isEqual:[newMessageUpdate message]];
        }]];
        
        if(result.count == 0)
        {
            [_objects addObject:[newMessageUpdate message]];
            [self tableViewReloadDataWithScroll];
        }
    }
}

#pragma mark - Managing the detail item

- (void)setDialog:(LVKDialog *)newDialog
{
    if (dialog != newDialog) {
        dialog = newDialog;
    }
    
    [self loadData:0];

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)tableViewReloadDataWithScroll
{
    [tableView reloadData];
    int count = [_objects count]-1;
    if(count >= 0)
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)registerObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNewMessage:)
                                                 name:@"newMessage"
                                               object:nil];
}

- (void)loadData:(int)offset
{
    if(dialog)
    {
        VKRequest *history = [VKApi
                              requestWithMethod:@"messages.getHistory"
                              andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"60", @"count", [NSNumber numberWithInt:offset], @"offset", [dialog chatId], [dialog chatIdKey], nil]
                              andHttpMethod:@"GET"];
        [history executeWithResultBlock:^(VKResponse *response) {
            _objects = [NSMutableArray arrayWithArray:[[[LVKHistoryCollection alloc] initWithDictionary:response.json] messages]];
            [self performSelectorOnMainThread:@selector(tableViewReloadDataWithScroll) withObject:nil waitUntilDone:YES];
        } errorBlock:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self registerObservers];
    [[self navigationItem] setTitle:dialog.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    LVKMessage *message = _objects[indexPath.row];
    cell.textLabel.text = [message body];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

-(IBAction) textFieldDoneEditing:(id)sender
{
    NSString *text = [textField text];
    [textField setText:@""];
    [self composeAndSendMessageWithText:text];
}

- (void)composeAndSendMessageWithText:(NSString *)text
{
    VKRequest *sendMessage = [VKApi
                          requestWithMethod:@"messages.send"
                          andParameters:[NSDictionary dictionaryWithObjectsAndKeys:text, @"message", [dialog chatId], [dialog chatIdKey], nil]
                          andHttpMethod:@"POST"];
    [sendMessage executeWithResultBlock:^(VKResponse *response) {
//        [self performSelectorOnMainThread:@selector(loadData:) withObject:0 waitUntilDone:YES];
    } errorBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMessage"]) {
        LVKMessage *object = nil;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        object = _objects[indexPath.row];
        
        [(LVKMessageViewController *)[segue destinationViewController] setMessage:object];
    }
}
@end
