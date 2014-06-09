//
//  LVKMasterViewController.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMasterViewController.h"
#import "LVKDialogViewController.h"
#import "LVKUserPickerViewController.h"
#import "UIScrollView+BottomRefreshControl.h"

@interface LVKMasterViewController () {
    NSMutableArray *_objects;
    BOOL isLoading;
    BOOL hasDataToLoad;
    UIRefreshControl *topRefreshControl;
    UIRefreshControl *bottomRefreshControl;
}
@end

@implementation LVKMasterViewController

@synthesize tableView;

- (void)awakeFromNib
{
#pragma mark - iPad
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        self.clearsSelectionOnViewWillAppear = NO;
//        self.preferredContentSize = CGSizeMake(320.0, 600.0);
//    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    hasDataToLoad = YES;

    bottomRefreshControl = [[UIRefreshControl alloc]init];
    [bottomRefreshControl addTarget:self action:@selector(onBottomRefreshControl) forControlEvents:UIControlEventValueChanged];
    [self.tableView setBottomRefreshControl:bottomRefreshControl];
    
    topRefreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:topRefreshControl];
    [topRefreshControl addTarget:self action:@selector(onTopRefreshControl) forControlEvents:UIControlEventValueChanged];

#pragma mark - iPad
//    self.detailViewController = (LVKDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self registerObservers];
    
    [self loadData:0];
}

- (void)resetMessageFlags:(NSNotification *)notification
{
    LVKLongPollResetMessageFlags *resetMessageFlagsUpdate = [notification object];
    
    NSArray *result = [_objects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(LVKDialog *dialog, NSDictionary *bindings) {
        return [[dialog lastMessage] _id] == [resetMessageFlagsUpdate messageId];
    }]];
    
    if(result.count == 1)
    {
        LVKDialog *dialog = [result firstObject];
        if([resetMessageFlagsUpdate isUnread])
        {
            [[dialog lastMessage] setIsUnread:NO];
            [tableView reloadData];
        }
    }
}

- (void)receiveNewMessage:(NSNotification *)notification
{
    LVKLongPollNewMessage *newMessageUpdate = [notification object];
    
    NSArray *result = [_objects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(LVKDialog *dialog, NSDictionary *bindings) {
        return [dialog isEqual:[newMessageUpdate dialog]];
    }]];
    
    if(result.count == 0)
    {
        if([newMessageUpdate dialog].type == Dialog)
        {
            isLoading = YES;
            VKRequest *users = [[VKApi users] get:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", [[newMessageUpdate dialog] chatId]], @"user_ids", @"photo_100", @"fields", nil]];
            
            users.attempts = 2;
            users.requestTimeout = 3;
            [users executeWithResultBlock:^(VKResponse *response) {
                LVKUsersCollection *usersCollection = [[LVKUsersCollection alloc] initWithArray:response.json];
                
                [[newMessageUpdate dialog] adoptUser:[[usersCollection users] firstObject]];
                
                [_objects insertObject:[newMessageUpdate dialog] atIndex:0];
                
                [self networkRestored];
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                isLoading = NO;
            } errorBlock:^(NSError *error) {
                if (error.code != VK_API_ERROR)
                {
                    [self networkFailedRequest:error.vkError.request];
                }
                else
                {
                    NSLog(@"%@", error);
                }
                isLoading = NO;
            }];
        }
        else
        {
            [_objects insertObject:[newMessageUpdate dialog] atIndex:0];
            [tableView reloadData];
        }
    }
    else
    {
        [_objects removeObject:[result firstObject]];
        [_objects insertObject:[result firstObject] atIndex:0];
        [[result firstObject] setLastMessage:[newMessageUpdate message]];
        [tableView reloadData];
    }
}

- (void)registerObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNewMessage:)
                                                 name:@"newMessage"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetMessageFlags:)
                                                 name:@"resetMessageFlags"
                                               object:nil];
}

- (void)loadData:(int)offset
{
    if(!hasDataToLoad)
    {
        [bottomRefreshControl endRefreshing];
        return;
    }
    if([VKSdk isLoggedIn])
    {
        isLoading = YES;
        VKRequest *dialogs = [VKApi
                              requestWithMethod:@"messages.getDialogs"
                              andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"30", @"count", [NSNumber numberWithInt:offset], @"offset", nil]
                              andHttpMethod:@"GET"];
        dialogs.attempts = 3;
        dialogs.requestTimeout = 3;
        [dialogs executeWithResultBlock:^(VKResponse *response) {
            LVKDialogsCollection *dialogsCollection = [[LVKDialogsCollection alloc] initWithDictionary:response.json];
            NSString *userIdsCSV = [[dialogsCollection getUserIds] componentsJoinedByString:@","];
            
            if([userIdsCSV length] > 0)
            {
                VKRequest *users = [[VKApi users] get:[NSDictionary dictionaryWithObjectsAndKeys:userIdsCSV, @"user_ids", @"photo_100", @"fields", nil]];
                
                users.attempts = 3;
                users.requestTimeout = 3;
                [users executeWithResultBlock:^(VKResponse *response) {
                    LVKUsersCollection *usersCollection = [[LVKUsersCollection alloc] initWithArray:response.json];
                    
                    [dialogsCollection adoptUserCollection:usersCollection];
                    
                    if(_objects.count == 0)
                    {
                        _objects = [NSMutableArray arrayWithArray:[dialogsCollection dialogs]];
                    }
                    else if(offset == _objects.count)
                    {
                        [_objects addObjectsFromArray:[dialogsCollection dialogs]];
                    }
                    
                    [self networkRestored];
                    [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                    isLoading = NO;
                    [bottomRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
                    [topRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
                    
                    if(_objects.count >= [[dialogsCollection count] intValue])
                    {
                        hasDataToLoad = NO;
                        [bottomRefreshControl performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
                    }
                } errorBlock:^(NSError *error) {
                    if (error.code != VK_API_ERROR)
                    {
                        [self networkFailedRequest:error.vkError.request];
                    }
                    else
                    {
                        NSLog(@"%@", error);
                    }
                    isLoading = NO;
                    [bottomRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
                    [topRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
                }];
            }
        } errorBlock:^(NSError *error) {
            if (error.code != VK_API_ERROR)
            {
                [self networkFailedRequest:error.vkError.request];
            }
            else
            {
                NSLog(@"%@", error);
            }
            isLoading = NO;
            [bottomRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
            [topRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
        }];
    }
}

- (void)onBottomRefreshControl
{
    if(!isLoading)
    {
        [self loadData:_objects.count];
    }
}

- (void)onTopRefreshControl
{
    if(!isLoading)
    {
        [self loadData:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    LVKDialog *dialog = _objects[indexPath.row];
    UITableViewCell *cell = nil;
    
    if(dialog.type == Dialog)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DialogCell" forIndexPath:indexPath];
        
        [(UIImageView *)[cell viewWithTag:4] setImageWithURL:[dialog getChatPicture]];
    }
    else if(dialog.type == Room)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RoomCell" forIndexPath:indexPath];
        NSArray *pictures = [dialog getChatPicture];
        
        [pictures enumerateObjectsUsingBlock:^(NSString *picture, NSUInteger idx, BOOL *stop) {
            UIView *subview = [cell viewWithTag:idx+4];
            [(UIImageView *)subview setImageWithURL:picture];
        }];
    }
    
    [(UILabel *)[cell viewWithTag:1] setText:[NSString stringWithFormat:@"%@%@", [dialog getReadState] == UnreadIncoming ? @"(!) " : [dialog getReadState] == UnreadOutgoing ? @"(?) " : @"", [dialog title]]];
    [(UILabel *)[cell viewWithTag:2] setText:[[dialog lastMessage] body]];
    [(UILabel *)[cell viewWithTag:3] setText:[NSDateFormatter localizedStringFromDate:[[dialog lastMessage] date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma mark - iPad
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        LVKDialog *object = _objects[indexPath.row];
//        self.detailViewController.dialog = object;
//    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        LVKDialog *object = nil;
    
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        object = _objects[indexPath.row];
        
        [[segue destinationViewController] setDialog:object];
    }
    else if ([[segue identifier] isEqualToString:@"pickUsers"]) {
        [(LVKUserPickerViewController *)[[segue destinationViewController] topViewController] setCallerViewController:self];
    }
}

@end
