//
//  LVKMasterViewController.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDialogListViewController.h"
#import "LVKDialogViewController.h"
#import "LVKUserPickerViewController.h"
#import "LVKDialogDeleteAlertDelegate.h"
#import "UIScrollView+BottomRefreshControl.h"
#import <VKSdk.h>
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import <UIImageView+WebCache.h>
#import "UIViewController+NetworkNotifications.h"
#import "LVKDialogsCollection.h"
#import "LVKUsersCollection.h"
#import <AudioToolbox/AudioToolbox.h>
#import "LVKLongPoll.h"
#import "LVKDefaultDialogTableViewCell.h"
#import "LVKAppDelegate.h"

@interface LVKDialogListViewController () {
    NSMutableArray *_objects, *_filteredObjects;
    NSString *searchString;
    BOOL isLoading;
    BOOL hasDataToLoad;
    UIRefreshControl *topRefreshControl;
    UIRefreshControl *bottomRefreshControl;
    LVKDialogDeleteAlertDelegate *dialogDeleteAlertDelegate;
}
@end

@implementation LVKDialogListViewController

@synthesize tableView, searchBar;

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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
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

- (void)loadUserDataForIdsInArray:(NSArray *)_userIds excludingUsersFromArray:(NSArray *)_userArray withResultBlock:(void (^)(NSArray *))completeBlock
                       errorBlock:(void (^)(NSError *))errorBlock
{
    NSMutableArray *userArray = [NSMutableArray arrayWithArray:_userArray];
    NSMutableArray *userIds = [NSMutableArray arrayWithArray:_userIds];
    
    for (LVKUser *userObject in userArray) {
        if([userObject isCurrent])
        {
            [userIds removeObject:[NSNumber numberWithInt:0]];
        }
        else if([userIds indexOfObject:[userObject _id]] != NSNotFound)
        {
            [userIds removeObject:[userObject _id]];
        }
    }
    
    NSString *userIdsCSV = [userIds componentsJoinedByString:@","];
    
    if([userIdsCSV length] > 0)
    {
        VKRequest *users = [[VKApi users] get:[NSDictionary dictionaryWithObjectsAndKeys:userIdsCSV, @"user_ids", @"photo_100", @"fields", nil]];
        
        users.attempts = 3;
        users.requestTimeout = 3;
        [users executeWithResultBlock:^(VKResponse *response) {
            LVKUsersCollection *usersCollection = [[LVKUsersCollection alloc] initWithArray:response.json];
            
            [userArray addObjectsFromArray:[usersCollection users]];
            
            completeBlock([NSArray arrayWithArray:userArray]);
        } errorBlock:errorBlock];
    }
    else
    {
        completeBlock([NSArray arrayWithArray:userArray]);
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
            [self loadUserDataForIdsInArray:[NSArray arrayWithObject:[[newMessageUpdate dialog] chatId]] excludingUsersFromArray:[[NSArray alloc] init] withResultBlock:^(NSArray *userArray) {
                [[newMessageUpdate dialog] adoptUser:[userArray firstObject]];
                
                [_objects insertObject:[newMessageUpdate dialog] atIndex:0];
                
                [self networkRestored];
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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

-(NSMutableArray *)getObjects
{
    return [searchString length] > 0 ? _filteredObjects : _objects;
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

- (void)loadSearchData
{
    NSString *currentSearchString = [NSString stringWithString:searchString];
    
    if(currentSearchString.length > 0)
    {
        if([VKSdk isLoggedIn] && !isLoading)
        {
            isLoading = YES;
            VKRequest *dialogs = [VKApi
                                requestWithMethod:@"messages.searchDialogs"
                                andParameters:[NSDictionary dictionaryWithObjectsAndKeys:currentSearchString, @"q", nil]
                                andHttpMethod:@"GET"];
            dialogs.attempts = 2;
            dialogs.requestTimeout = 5;
            [dialogs executeWithResultBlock:^(VKResponse *response) {
                LVKDialogsCollection *dialogsCollection = [[LVKDialogsCollection alloc] initWithArray:response.json];
                
                [self loadUserDataForIdsInArray:[dialogsCollection getUserIds] excludingUsersFromArray:[[NSArray alloc] init] withResultBlock:^(NSArray *userArray) {
                    
                    [dialogsCollection adoptUserCollection:[[LVKUsersCollection alloc] initWithUserArray:userArray]];
                    
                    _filteredObjects = [NSMutableArray arrayWithArray:[dialogsCollection dialogs]];
                    
                    if(![searchString isEqual:currentSearchString])
                    {
                        [self performSelector:@selector(loadSearchData) withObject:0 afterDelay:1];
                    }
                    
                    [self networkRestored];
                    [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
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
                    [self performSelector:@selector(loadSearchData) withObject:0 afterDelay:2];
                    isLoading = NO;
                }];
                
                
            } errorBlock:^(NSError *error) {
                if (error.code != VK_API_ERROR)
                {
                    [self networkFailedRequest:error.vkError.request];
                }
                else
                {
                    NSLog(@"%@", error);
                }
                [self performSelector:@selector(loadSearchData) withObject:0 afterDelay:2];
                isLoading = NO;
            }];
        }
    }
    else
    {
        [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
}

- (void)loadData:(int)offset
{
    [self loadData:offset reload:NO];
}

- (void)loadData:(int)offset reload:(BOOL)reload
{
    if(!hasDataToLoad && !reload)
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
            
            [self loadUserDataForIdsInArray:[dialogsCollection getUserIds] excludingUsersFromArray:[[NSArray alloc] init] withResultBlock:^(NSArray *userArray) {
                
                [dialogsCollection adoptUserCollection:[[LVKUsersCollection alloc] initWithUserArray:userArray]];
                
                if(_objects.count == 0 || reload)
                {
                    _objects = [NSMutableArray arrayWithArray:[dialogsCollection dialogs]];
                }
                else if(offset == _objects.count)
                {
                    [_objects addObjectsFromArray:[dialogsCollection dialogs]];
                }
                
                [self networkRestored];
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                isLoading = NO;
                [bottomRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
                [topRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
                
                if(_objects.count >= [[dialogsCollection count] intValue])
                {
                    hasDataToLoad = NO;
                    [bottomRefreshControl performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:NO];
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
                [bottomRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
                [topRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:NO];
            }];
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
        [self loadData:0 reload:YES];
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
    return [self getObjects].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LVKDialog *dialog = [self getObjects][indexPath.row];
    LVKDefaultDialogTableViewCell *cell = nil;
    
    if(dialog.type == Dialog || dialog.lastMessage.user == [(LVKAppDelegate *)[[UIApplication sharedApplication] delegate] currentUser])
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultDialogCell" forIndexPath:indexPath];
        
//        [(UIImageView *)[cell viewWithTag:4] setImageWithURL:[dialog getChatPicture]];
    }
    else if(dialog.type == Room)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultDialogCellWithMessageDetails" forIndexPath:indexPath];
        NSArray *pictures = [dialog getChatPicture];
        
//        [pictures enumerateObjectsUsingBlock:^(NSString *picture, NSUInteger idx, BOOL *stop) {
//            UIView *subview = [cell viewWithTag:idx+4];
//            [(UIImageView *)subview setImageWithURL:picture];
//        }];
    }
    
    cell.title.text = dialog.title;
    cell.message.text = dialog.lastMessage.body;
    cell.date.text = [NSDateFormatter localizedStringFromDate:dialog.lastMessage.date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    [cell.messageAvatar setImageWithURL:dialog.lastMessage.user.photo_100];
    BOOL isUnread = dialog.getReadState == UnreadIncoming || dialog.getReadState == UnreadOutgoing ? YES : NO;
    [cell ajustLayoutLastMessageIsUnread:isUnread];
    
    [cell setAvatars:[dialog getChatPicture]];
    
//    [cell ajustLayoutUserIsOnline:dialog.user.]
    
//    [(UILabel *)[cell viewWithTag:1] setText:[NSString stringWithFormat:@"%@%@", [dialog getReadState] == UnreadIncoming ? @"(!) " : [dialog getReadState] == UnreadOutgoing ? @"(?) " : @"", [dialog title]]];
//    [(UILabel *)[cell viewWithTag:2] setText:[[dialog lastMessage] body]];
//    [(UILabel *)[cell viewWithTag:3] setText:[NSDateFormatter localizedStringFromDate:[[dialog lastMessage] date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]];
    
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
        LVKDialog *dialog = [[self getObjects] objectAtIndex:indexPath.row];
        VKRequest *deleteDialogRequest = [VKApi requestWithMethod:@"messages.deleteDialog" andParameters:[NSDictionary dictionaryWithObjectsAndKeys:[dialog chatId], [dialog chatIdKey], nil] andHttpMethod:@"GET"];
        
        dialogDeleteAlertDelegate = [[LVKDialogDeleteAlertDelegate alloc] initWithRequest:deleteDialogRequest resultBlock:^(VKResponse *response) {
            [[self getObjects] removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } errorBlock:^(NSError *error) {
            
        }];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Удалить диалог %@", [dialog title]]
                                                          message:@"Все сообщения в диалоге будут удалены!"
                                                         delegate:dialogDeleteAlertDelegate
                                                cancelButtonTitle:@"Отмена"
                                                otherButtonTitles:@"Удалить", nil];
        
        [message show];
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

#pragma mark - Search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchString = searchText;
    [self loadSearchData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self loadSearchData];
    [searchBar resignFirstResponder];
}

#pragma mark - Scroll view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[self searchBar] endEditing:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [searchBar resignFirstResponder];
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        LVKDialog *object = nil;
    
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        object = [self getObjects][indexPath.row];
        
        [[segue destinationViewController] setDialog:object];
    }
    else if ([[segue identifier] isEqualToString:@"pickUsers"]) {
        [(LVKUserPickerViewController *)[[segue destinationViewController] topViewController] setCallerViewController:self];
    }
}

@end
