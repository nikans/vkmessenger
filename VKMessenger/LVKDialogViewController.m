//
//  LVKDetailViewController.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKDialogViewController.h"
#import "LVKMessageViewController.h"
#import "LVKAppDelegate.h"
#import "AVHexColor.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "LVKMessagePartProtocol.h"
#import "LVKDialogCollectionViewDelegate.h"
#import "LVKUsersCollection.h"
#import "UIImage+Color.h"

#import "LVKDefaultMessageTableViewCell.h"

#define TEXTVIEW_BASE_HEIGHT (27)

@interface LVKDialogViewController () {
    NSMutableArray *_objects;
    BOOL isLoading;
    BOOL hasDataToLoad;
    UIRefreshControl *topRefreshControl;
    UIRefreshControl *bottomRefreshControl;
}

// TODO: interface 4 cell
@property (nonatomic, strong) LVKDefaultMessageTableViewCell *prototypeCellIncoming;
@property (nonatomic, strong) LVKDefaultMessageTableViewCell *prototypeCellOutgoing;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation LVKDialogViewController

@synthesize tableView, textView, dialog;


#pragma mark - Networking

- (void)resetMessageFlags:(NSNotification *)notification
{
    LVKLongPollResetMessageFlags *resetMessageFlagsUpdate = [notification object];
    
    NSArray *result = [_objects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(LVKMessage *message, NSDictionary *bindings) {
        return [message _id] == [resetMessageFlagsUpdate messageId];
    }]];
    
    if(result.count == 1)
    {
        LVKMessage *message = [result firstObject];
        if([resetMessageFlagsUpdate isUnread])
        {
            [message setIsUnread:NO];
            [tableView reloadData];
        }
    }
}

- (NSArray *)dialogUsers
{
    NSMutableArray *userArray = [[NSMutableArray alloc] init];
    
    if([dialog type] == Room)
    {
        [userArray addObjectsFromArray:[dialog users]];
    }
    else if([dialog type] == Dialog)
    {
        [userArray addObject:[dialog user]];
    }
    [userArray addObject:[(LVKAppDelegate *)[[UIApplication sharedApplication] delegate] currentUser]];
    
    return [NSArray arrayWithArray:userArray];
}

- (void)loadMessageData:(LVKMessage *)message withResultBlock:(void (^)(VKResponse *))completeBlock
                                           errorBlock:(void (^)(NSError *))errorBlock
{
    VKRequest *messageRequest = [VKApi requestWithMethod:@"messages.getById" andParameters:[NSDictionary dictionaryWithObject:[message _id] forKey:@"message_id"] andHttpMethod:@"GET"];
    
    messageRequest.attempts = 2;
    messageRequest.requestTimeout = 5;
    [messageRequest executeWithResultBlock:completeBlock errorBlock:errorBlock];
}

- (void)loadHistoryDataOffsettedBy:(int) offset withResultBlock:(void (^)(VKResponse *))completeBlock
             errorBlock:(void (^)(NSError *))errorBlock
{
    VKRequest *history = [VKApi
                          requestWithMethod:@"messages.getHistory"
                          andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"30", @"count", [NSNumber numberWithInt:offset], @"offset", [dialog chatId], [dialog chatIdKey], nil]
                          andHttpMethod:@"GET"];
    history.attempts = 3;
    history.requestTimeout = 3;
    [history executeWithResultBlock:completeBlock errorBlock:errorBlock];
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
    
    if([dialog isEqual:[newMessageUpdate dialog]])
    {
        NSArray *result = [_objects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(LVKMessage *message, NSDictionary *bindings) {
            return [message isEqual:[newMessageUpdate message]];
        }]];
        
        if(result.count == 0)
        {
            LVKMessage *message = [newMessageUpdate message];
            [self loadMessageData:message withResultBlock:^(VKResponse *response) {
                [message adoptAttachments:[[[response.json objectForKey:@"items"] firstObject] objectForKey:@"attachments"]];
                [message adoptForwarded:[[[response.json objectForKey:@"items"] firstObject] objectForKey:@"fwd_messages"]];
                
                NSArray *result = [_objects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(LVKMessage *message, NSDictionary *bindings) {
                    return [message isEqual:[newMessageUpdate message]];
                }]];
                
                if(result.count == 0)
                {
                    [self loadUserDataForIdsInArray:[message getUserIds] excludingUsersFromArray:[self dialogUsers] withResultBlock:^(NSArray *userArray) {
                        [self didLoadMessage:message withUserArray:userArray];
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
                    [message adoptUserArray:[self dialogUsers]];
                    
                    LVKMessage *existingMessage = [result firstObject];
                    
                    [_objects replaceObjectAtIndex:[_objects indexOfObject:existingMessage] withObject:message];
                    [self tableViewReloadDataWithScrollToIndexPath:[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]];
                    
                    [self networkRestored];
                    [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                    isLoading = NO;
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
            }];
        }
    }
}

#pragma mark - Managing the detail item

- (void)setDialog:(LVKDialog *)newDialog
{
    if (dialog != newDialog) {
        dialog = newDialog;
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)tableViewReloadDataWithScrollToIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
    int count = [_objects count]-1;
    if(count >= 0)
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
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
    [[NSNotificationCenter defaultCenter] addObserver:textView
                                             selector:@selector(resignFirstResponder)
                                                 name:@"appBecomeActive"
                                               object:nil];
}

- (void)didLoadMessage:(LVKMessage *)message withUserArray:(NSArray *)userArray
{
    [message adoptUserArray:userArray];
    
    [_objects addObject:message];
    [self tableViewReloadDataWithScrollToIndexPath:[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]];
    
    [self networkRestored];
    [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    isLoading = NO;
}

- (void)didLoadHistoryCollection:(LVKHistoryCollection *)historyCollection withUserArray:(NSArray *)userArray offset:(int)offset reload:(BOOL)reload
{
    [historyCollection adoptUserArray:userArray];
    
    if(_objects.count == 0 || reload)
    {
        _objects = [NSMutableArray arrayWithArray:[historyCollection messages]];
        [self performSelectorOnMainThread:@selector(tableViewReloadDataWithScrollToIndexPath:) withObject:[NSIndexPath indexPathForRow:_objects.count-1 inSection:0] waitUntilDone:YES];
    }
    else if(offset == _objects.count)
    {
        [_objects insertObjects:[historyCollection messages] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [historyCollection messages].count)]];
        [self performSelectorOnMainThread:@selector(tableViewReloadDataWithScrollToIndexPath:) withObject:[NSIndexPath indexPathForRow:[historyCollection messages].count inSection:0] waitUntilDone:YES];
    }
    
    [self networkRestored];
    [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
    [self didFinishedLoadingHistoryCollection];
    
    [self endOfDataSourceHandlerForHistoryCollection:historyCollection];
}

- (void)endOfDataSourceHandlerForHistoryCollection:(LVKHistoryCollection *)historyCollection
{
    if(_objects.count >= [[historyCollection count] intValue])
    {
        hasDataToLoad = NO;
        [topRefreshControl performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
        [bottomRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
    }
}

- (void)didFinishedLoadingHistoryCollection
{
    isLoading = NO;
    [bottomRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
    [topRefreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
}

- (void)loadData:(int)offset
{
    [self loadData:offset reload:NO];
}

- (void)loadData:(int)offset reload:(BOOL)reload
{
    if(!hasDataToLoad && !reload)
    {
        [topRefreshControl endRefreshing];
        return;
    }
    if(dialog)
    {
        isLoading = YES;
        [self loadHistoryDataOffsettedBy:offset withResultBlock:^(VKResponse *response) {
            LVKHistoryCollection *historyCollection = [[LVKHistoryCollection alloc] initWithDictionary:response.json];
            
            [self loadUserDataForIdsInArray:[historyCollection getUserIds] excludingUsersFromArray:[self dialogUsers] withResultBlock:^(NSArray *userArray) {
                [self didLoadHistoryCollection:historyCollection withUserArray:userArray offset:offset reload:reload];
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
        } errorBlock:^(NSError *error) {
            if (error.code != VK_API_ERROR)
            {
                [self networkFailedRequest:error.vkError.request];
            }
            else
            {
                NSLog(@"%@", error);
            }
            [self didFinishedLoadingHistoryCollection];
        }];
    }
}

- (void)onTopRefreshControl
{
    if(!isLoading)
    {
        [self loadData:_objects.count];
    }
}

- (void)onBottomRefreshControl
{
    if(!isLoading)
    {
        [self loadData:0 reload:YES];
    }
}


#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Navbar
    [[self navigationItem] setTitle:dialog.title];
    
    // TODO: placeholder
    if (self.dialog.type == Dialog) {
        UIButton *avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,36,36)];
        [avatarButton setImageWithURL:self.dialog.user.photo_100 forState:UIControlStateNormal];
//        [avatarButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        avatarButton.layer.cornerRadius = 18.0f;
        avatarButton.layer.masksToBounds = YES;
        
        UIView *avatarButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
        avatarButtonView.bounds = CGRectOffset(avatarButtonView.bounds, -11, 1);
        [avatarButtonView addSubview:avatarButton];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:avatarButtonView];
    }
    
    // Refresh controls
    topRefreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:topRefreshControl];
    [topRefreshControl addTarget:self action:@selector(onTopRefreshControl) forControlEvents:UIControlEventValueChanged];
    
    bottomRefreshControl = [[UIRefreshControl alloc]init];
    [bottomRefreshControl addTarget:self action:@selector(onBottomRefreshControl) forControlEvents:UIControlEventValueChanged];
    [self.tableView setBottomRefreshControl:bottomRefreshControl];
    
    
    // TODO: style
    self.tableView.backgroundColor = [AVHexColor colorWithHexString:@"#edf3fa"];
    [self.tableView setContentInset:UIEdgeInsetsMake(0,0,5,0)];
    
    // Text view
//    textView.layoutManager.delegate = self;
    self.textViewContainer.layer.cornerRadius = 4.f;
    self.textViewContainer.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 4.f;
    self.textView.layer.masksToBounds = YES;
    [self.textView setTextContainerInset:UIEdgeInsetsMake(3, 3, 3, 3)];
    
    // Load data
    [self registerObservers];
    
    hasDataToLoad = YES;
    
    [self loadData:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.textView resignFirstResponder];
    
    // unregister for keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View


// TODO some shit w/ interface 4 cell
- (LVKDefaultMessageTableViewCell *)prototypeCellIncoming
{
    if (!_prototypeCellIncoming)
        _prototypeCellIncoming = [self.tableView dequeueReusableCellWithIdentifier:@"DefaultIncomingMessageCell"];
    return _prototypeCellIncoming;
}
- (LVKDefaultMessageTableViewCell *)prototypeCellOutgoing
{
    if (!_prototypeCellOutgoing)
        _prototypeCellOutgoing = [self.tableView dequeueReusableCellWithIdentifier:@"DefaultOutgoingMessageCell"];
    return _prototypeCellOutgoing;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LVKDefaultMessageTableViewCell *prototypeCell;
    
    LVKMessage *message = _objects[indexPath.row];
    if([message isOutgoing])
        prototypeCell = self.prototypeCellOutgoing;
    else
        prototypeCell = self.prototypeCellIncoming;
    
    [self tableView:tableView configureCell:prototypeCell forRowAtIndexPath:indexPath];
    
    prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(prototypeCell.bounds));
    [prototypeCell layoutIfNeeded];
    
    CGSize size = [prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (void)tableView:(UITableView *)tableView configureCell:(LVKDefaultMessageTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    LVKMessage *message = _objects[indexPath.row];
    cell.isOutgoing = [message isOutgoing];
    cell.isRoom     = message.type == Room ? YES : NO;
    cell.isUnread   = message.isUnread;
    cell.bubbleDelegate = self;
    cell.sandingState = message.state;
    
    CGFloat maxCVWidth;
    if (!cell.isOutgoing)
        if (cell.isRoom) maxCVWidth = 196.f;
        else maxCVWidth = 230.f;
    else maxCVWidth = 217.f;
    cell.collectionViewMaxWidth = maxCVWidth;
    
    LVKDialogCollectionViewDelegate *collectionViewDelegate = [[LVKDialogCollectionViewDelegate alloc] initWithData:message];
    [cell setCollectionViewDelegates:collectionViewDelegate forMessageWithIndexPath:indexPath];
    [cell setBubbleActionsDelegate:self forMessageWithIndexPath:indexPath];
}

// TODO
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LVKDefaultMessageTableViewCell *cell = nil;
    LVKMessage *message = _objects[indexPath.row];
    
    if([message isOutgoing])
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultOutgoingMessageCell" forIndexPath:indexPath];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultIncomingMessageCell" forIndexPath:indexPath];
    
//    [(UILabel *)[cell viewWithTag:1] setText:[NSString stringWithFormat:@"%@%@", [message getReadState] == UnreadIncoming ? @"(!) " : [message getReadState] == UnreadOutgoing ? @"(?) " : @"", [message body]]];
//    [(UILabel *)[cell viewWithTag:2] setText:[NSDateFormatter localizedStringFromDate:[message date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]];
//    [(UIImageView *)[cell viewWithTag:3] setImageWithURL:[[message user] getPhoto:100]];
    
    [cell.avatarImage setImageWithURL:[[message user] getPhoto:100]];
    [cell.timeLabel setText:[NSDateFormatter localizedStringFromDate:[message date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]];
    [self tableView:tableView configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



#pragma mark - Keyboard & new message GUI

// Called when the UIKeyboardWillShowNotification is received
- (void)keyboardWillBeShown:(NSNotification *)aNotification
{
    // keyboard frame is in window coordinates
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardInfoFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // get the height of the keyboard by taking into account the orientation of the device too
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect keyboardFrame = CGRectIntersection (windowFrame, keyboardInfoFrame);
    CGRect coveredFrame = [self.view.window convertRect:keyboardFrame toView:self.view];
    CGRect newWindowFrame = CGRectMake(0, -coveredFrame.size.height, windowFrame.size.width, windowFrame.size.height);
    
    // add the keyboard height to the content insets so that the scrollview can be scrolled
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake (0.0, 0.0, coveredFrame.size.height, 0.0);
//    self.view.contentInset = contentInsets;
//    self.view.scrollIndicatorInsets = contentInsets;
    
    // make sure the scrollview content size width and height are greater than 0
//    [self.view setContentSize:CGSizeMake (self.scrollView.width, self.scrollView.contentSize.height)];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationBeginsFromCurrentState: NO];
    self.view.frame = newWindowFrame;
    [UIView commitAnimations];
    
    // scroll to the text view
//    [self.view scrollRectToVisible:textView.superview.frame animated:YES];
    
}

// Called when the UIKeyboardWillHideNotification is received
- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    
    CGRect windowFrame = [self.view.window convertRect:self.view.frame fromView:self.view];
    CGRect newWindowFrame = CGRectMake(0, 0, windowFrame.size.width, windowFrame.size.height);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:[userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
    [UIView setAnimationDuration:[userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationBeginsFromCurrentState: NO];
    self.view.frame = newWindowFrame;
    [UIView commitAnimations];
    // scroll back..
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.scrollView.contentInset = contentInsets;
//    self.scrollView.scrollIndicatorInsets = contentInsets;
}


- (IBAction)sendMessage:(id)sender
{
    if([textView text].length == 0)
        return;
    
    NSString *text = [textView text];
    [textView setText:@""];
    
    // TODO: shit stuff
    [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.textViewHeightConstraint.constant = TEXTVIEW_BASE_HEIGHT;
    
    [self composeAndSendMessageWithText:text];
}

- (void)markAllAsRead
{
    NSString *messageIds = nil;
    
    NSArray *unreadMessages = [_objects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(LVKMessage *message, NSDictionary *bindings) {
        return [message getReadState] == UnreadIncoming;
    }]];
    
    if(unreadMessages.count > 0)
    {
        NSMutableArray *unreadMessageIds = [[NSMutableArray alloc] init];
        [unreadMessages enumerateObjectsUsingBlock:^(LVKMessage *message, NSUInteger idx, BOOL *stop) {
            [unreadMessageIds addObject:[message _id]];
        }];
        
        messageIds = [unreadMessageIds componentsJoinedByString:@","];
    
        VKRequest *markAsRead = [VKApi
                                  requestWithMethod:@"messages.markAsRead"
                                  andParameters:[NSDictionary dictionaryWithObjectsAndKeys:messageIds, @"message_ids", nil]
                                  andHttpMethod:@"POST"];

        markAsRead.attempts = 3;
        markAsRead.requestTimeout = 3;
        [markAsRead executeWithResultBlock:^(VKResponse *response) {
            [self networkRestored];
        } errorBlock:^(NSError *error) {
            if (error.code != VK_API_ERROR)
            {
                [self networkFailedRequest:error.vkError.request];
            }
            else
            {
                NSLog(@"%@", error);
            }
        }];
    }
}

- (void)sendMessageForMessage:(LVKMessage *)message andDialog:(LVKDialog *)currentDialog
{
    VKRequest *sendMessage = [VKApi
                              requestWithMethod:@"messages.send"
                              andParameters:[NSDictionary dictionaryWithObjectsAndKeys:[message body], @"message", [currentDialog chatId], [currentDialog chatIdKey], /*[NSNumber numberWithInt:rand()], @"guid",*/ nil]
                              andHttpMethod:@"POST"];
    
    sendMessage.attempts = 3;
    sendMessage.requestTimeout = 3;
    [sendMessage executeWithResultBlock:^(VKResponse *response) {
        [message set_id:response.json];
        [self networkRestored];
    } errorBlock:^(NSError *error) {
        if (error.code != VK_API_ERROR)
        {
            [self networkFailedRequest:error.vkError.request];
        }
        else
        {
            NSLog(@"%@", error);
        }
    }];
}

- (void)composeAndSendMessageWithText:(NSString *)text
{
    LVKMessage *newMessage = [[LVKMessage alloc] initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[dialog chatId], [dialog chatIdKey], [NSNumber numberWithDouble: [[NSDate date] timeIntervalSince1970]], @"date", text, @"body", [NSNumber numberWithInt:1], @"out", [NSNumber numberWithInt:0], @"read_state", nil]];
    
    [_objects addObject:newMessage];
    [self tableViewReloadDataWithScrollToIndexPath:[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]];
    
    [self sendMessageForMessage:newMessage andDialog:dialog];
}
- (void)hasSuccessfullySentMessageAtIndexPath:(NSIndexPath *)indexPath {
    LVKDefaultMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultOutgoingMessageCell" forIndexPath:indexPath];
    [cell hasSuccessfullySentMessage];
}

- (void)hasFailedToSentMessageAtIndexPath:(NSIndexPath *)indexPath {
    LVKDefaultMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultOutgoingMessageCell" forIndexPath:indexPath];
    [cell hasFailedToSentMessage];
}

- (void)hasRetriedToSentMessageAtIndexPath:(NSIndexPath *)indexPath {
    LVKDefaultMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultOutgoingMessageCell" forIndexPath:indexPath];
    [cell hasRetriedToSendMessage];
}

#pragma mark - Text view

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self markAllAsRead];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.textViewHeightConstraint.constant != self.textView.contentSize.height) {
        [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height-1, 1, 1) animated:NO];
//        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_objects count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    self.textViewHeightConstraint.constant = self.textView.contentSize.height;
    
    if(self.textView.text.length > 0)
    {
        [self.sendButton setTitleColor:self.sendButton.titleLabel.tintColor forState:UIControlStateNormal];
    }
    else
    {
        [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}


#pragma mark - Scroll view

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([scrollView isEqual:tableView])
    {
        [[self textView] endEditing:YES];
//        [self.textView resignFirstResponder];
    }
}


#pragma mark - Bubble actions

- (void)pushToMessageVC:(UITapGestureRecognizer *)tapGesture {
    
    // TODO protocol
    LVKDefaultMessageTableViewCell *cell = (LVKDefaultMessageTableViewCell *)tapGesture.view;
    
    // TODO
//    cell.messageContainerBackgroundImage.image = [cell.messageContainerBackgroundImage.image addColor:[UIColor blackColor] drawAsOverlay:YES];
    
    [self performSegueWithIdentifier:@"showMessage" sender:cell.cellIndexPath];
}

- (void)resendMessage:(UITapGestureRecognizer *)tapGesture {
    
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
//    if ([[segue identifier] isEqualToString:@"showMessage"]) {
//        LVKMessage *object = nil;
//        
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        object = _objects[indexPath.row];
//        
//        [(LVKMessageViewController *)[segue destinationViewController] setMessage:object];
//    }
    
    if ([[segue identifier] isEqualToString:@"showMessage"]) {
        LVKMessage *object = nil;

        NSIndexPath *indexPath = sender;
        object = _objects[indexPath.row];

        [(LVKMessageViewController *)[segue destinationViewController] setMessage:object];
    }
    
    
}
@end
