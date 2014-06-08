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

#import "LVKDefaultMessageTableViewCell.h"
#import "LVKMessagePartProtocol.h"
#import "LVKRepostedMessage.h"

@interface LVKDialogViewController () {
    NSMutableArray *_objects;
    BOOL isLoading;
    BOOL hasDataToLoad;
    UIRefreshControl *refreshControl;
}

// TODO: interface 4 cell
@property (nonatomic, strong) LVKDefaultMessageTableViewCell *prototypeCellIncoming;
@property (nonatomic, strong) LVKDefaultMessageTableViewCell *prototypeCellOutgoing;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation LVKDialogViewController

@synthesize tableView, textView , dialog;

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
            LVKHistoryCollection *historyCollection = [[LVKHistoryCollection alloc] initWithMessage:[newMessageUpdate message]];
            
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
            
            [historyCollection adoptUserArray:userArray];
            
            [_objects addObject:[[historyCollection messages] firstObject]];
            [self tableViewReloadDataWithScrollToIndexPath:[NSIndexPath indexPathForRow:_objects.count-1 inSection:0]];
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
}

- (void)loadData:(int)offset
{
    if(!hasDataToLoad)
    {
        [refreshControl endRefreshing];
        return;
    }
    if(dialog)
    {
        isLoading = YES;
        VKRequest *history = [VKApi
                              requestWithMethod:@"messages.getHistory"
                              andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"60", @"count", [NSNumber numberWithInt:offset], @"offset", [dialog chatId], [dialog chatIdKey], nil]
                              andHttpMethod:@"GET"];
        [history executeWithResultBlock:^(VKResponse *response) {
            LVKHistoryCollection *historyCollection = [[LVKHistoryCollection alloc] initWithDictionary:response.json];
            
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
            
            [historyCollection adoptUserArray:userArray];
            
            if(_objects.count == 0)
            {
                _objects = [NSMutableArray arrayWithArray:[historyCollection messages]];
                [self performSelectorOnMainThread:@selector(tableViewReloadDataWithScrollToIndexPath:) withObject:[NSIndexPath indexPathForRow:_objects.count-1 inSection:0] waitUntilDone:YES];
            }
            else if(offset == _objects.count)
            {
                [_objects insertObjects:[historyCollection messages] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [historyCollection messages].count)]];
                [self performSelectorOnMainThread:@selector(tableViewReloadDataWithScrollToIndexPath:) withObject:[NSIndexPath indexPathForRow:[historyCollection messages].count inSection:0] waitUntilDone:YES];
            }
            
            isLoading = NO;
            [refreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
            
            if(_objects.count >= [[historyCollection count] intValue])
            {
                hasDataToLoad = NO;
                [refreshControl performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:YES];
            }
        } errorBlock:^(NSError *error) {
            NSLog(@"%@", error);
            isLoading = NO;
            [refreshControl performSelectorOnMainThread:@selector(endRefreshing) withObject:nil waitUntilDone:YES];
        }];
    }
}

- (void)onRefreshControl
{
    if(!isLoading)
    {
        [self loadData:_objects.count];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[self navigationItem] setTitle:dialog.title];
    
    [self registerObservers];
    
    hasDataToLoad = YES;
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(onRefreshControl) forControlEvents:UIControlEventValueChanged];
    
    // TODO: style
    self.tableView.backgroundColor = [AVHexColor colorWithHexString:@"#edf3fa"];
    
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
    
    // TODO
    LVKMessage *message = _objects[indexPath.row];
    if([message isOutgoing])
        prototypeCell = self.prototypeCellOutgoing;
    else
        prototypeCell = self.prototypeCellIncoming;
    
    [self tableView:tableView configureCell:prototypeCell forRowAtIndexPath:indexPath];
    
    // Need to set the width of the prototype cell to the width of the table view
    // as this will change when the device is rotated.
    
    prototypeCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(prototypeCell.bounds));
    
    [prototypeCell layoutIfNeeded];
    
    CGSize size = [prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView configureCell:(LVKDefaultMessageTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    LVKMessage *message = _objects[indexPath.row];
    cell.isOutgoing = [message isOutgoing];
    
    [cell setCollectionViewDelegates:self forMessageWithIndexPath:indexPath];
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


#pragma mark - UICollectionView Datasource

// TODO
- (NSInteger)collectionView:(LVKDefaultMessagesCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_objects[collectionView.messageIndexPath.row] getMessageParts].count;
}

- (UICollectionViewCell *)collectionView:(LVKDefaultMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    id<LVKMessagePartProtocol> cellData = [self collectionView:collectionView dataForItemAtIndexPath:indexPath];
    
    UICollectionViewCell *cell;

    if([cellData isKindOfClass:[LVKMessage class]])
    {
        cell = (LVKDefaultMessageBodyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultBodyItem" forIndexPath:indexPath];
        [cell setValue:[(LVKMessage *)cellData body] forKeyPath:@"body.text"];
    }
    else if([cellData isKindOfClass:[LVKRepostedMessage class]])
    {
        cell = (LVKDefaultMessageRepostBodyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultRepostBodyItem" forIndexPath:indexPath];
        [cell setValue:[(LVKRepostedMessage *)cellData body] forKeyPath:@"body.text"];
        [cell setValue:[NSDateFormatter localizedStringFromDate:
                [(LVKRepostedMessage *)cellData date] dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle] forKeyPath:@"date.text"];
        [cell setValue:[[(LVKRepostedMessage *)cellData user] fullName] forKeyPath:@"userName.text"];
    }
    else
    {
        cell = (LVKDefaultMessageBodyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DefaultBodyItem" forIndexPath:indexPath];
        [cell setValue:@"" forKeyPath:@"body.text"];
    }

    
//    switch (itemType) {
//        case bodyItem:
//            cell = (LVKMessageBodyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"BodyItem" forIndexPath:indexPath];
//            [cell setValue:cellData[@"body"] forKeyPath:@"body.text"];
//            break;
//            
//        case photoItem:
//            cell = (LVKMessagePhotoItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoItem" forIndexPath:indexPath];
//            [cell setValue:[UIImage imageNamed:@"camera"] forKeyPath:@"photo.image"];
//            break;
//            
//        case repostBodyItem:
//            cell = (LVKMessageRepostBodyItem *)[collectionView dequeueReusableCellWithReuseIdentifier:@"RepostBodyItem" forIndexPath:indexPath];
//            [cell setValue:[UIImage imageNamed:@"camera"] forKeyPath:@"avatar.image"];
//            [cell setValue:cellData[@"body"] forKeyPath:@"body.text"];
//            [cell setValue:cellData[@"date"] forKeyPath:@"date.text"];
//            [cell setValue:cellData[@"userName"] forKeyPath:@"userName.text"];
//            break;
//            
//            
//        default:
//            break;
//    }
    
    return cell;
}

//- (DefaultMessageItemType)collectionView:(LVKDefaultMessagesCollectionView *)collectionView typeOfItemAtIndexPath:(NSIndexPath *)indexPath {
//    return [[[self collectionView:collectionView dataForItemAtIndexPath:indexPath] objectForKey:@"type"] intValue];
//}

// TODO
- (id<LVKMessagePartProtocol>)collectionView:(LVKDefaultMessagesCollectionView *)collectionView dataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[_objects[collectionView.messageIndexPath.row] getMessageParts] objectAtIndex:indexPath.row];
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark – UICollectionViewDelegateFlowLayout

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    
//    NSInteger numberOfCells = self.view.frame.size.width / 202;
//    NSInteger edgeInsets = (self.view.frame.size.width - (numberOfCells * 202)) / (numberOfCells + 1);
//    
//    return UIEdgeInsetsMake(0, edgeInsets, 0, edgeInsets);
//}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    [self.collectionView.collectionViewLayout invalidateLayout];
//}


- (CGSize)collectionView:(LVKDefaultMessagesCollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<LVKMessagePartProtocol> cellData = [self collectionView:collectionView dataForItemAtIndexPath:indexPath];

    CGSize cellSize;

    if([cellData isKindOfClass:[LVKMessage class]])
    {
        cellSize = [LVKDefaultMessageBodyItem calculateContentSizeWithData:cellData];
    }
    else if([cellData isKindOfClass:[LVKRepostedMessage class]])
    {
        cellSize = [LVKDefaultMessageRepostBodyItem calculateContentSizeWithData:cellData];
    }
    else
    {
        cellSize = [LVKDefaultMessageBodyItem calculateContentSizeWithData:[[LVKMessage alloc] init]];
    }

//    cellSize = [LVKDefaultMessageBodyItem calculateContentSizeWithData:cellData];
    
//    switch (itemType) {
//        case bodyItem:
//            cellSize = [LVKMessageBodyItem calculateContentSizeWithData:cellData];
//            break;
//            
//        case photoItem:
//            cellSize = [LVKMessagePhotoItem calculateContentSizeWithData:cellData];
//            break;
//            
//        case repostBodyItem:
//            cellSize = [LVKMessageRepostBodyItem calculateContentSizeWithData:cellData];
//            break;
//            
//        default:
//            break;
//    }
    return cellSize;
}



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


-(IBAction) sendMessage:(id)sender
{
    NSString *text = [textView text];
    [textView setText:@""];
    [self composeAndSendMessageWithText:text];
}

-(IBAction) textFieldReceivedFocus:(id)sender
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
    
    }
    
    VKRequest *markAsRead = [VKApi
                              requestWithMethod:@"messages.markAsRead"
                              andParameters:[NSDictionary dictionaryWithObjectsAndKeys:messageIds, @"message_ids", nil]
                              andHttpMethod:@"POST"];
    [markAsRead executeWithResultBlock:^(VKResponse *response) {
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)composeAndSendMessageWithText:(NSString *)text
{
    VKRequest *sendMessage = [VKApi
                          requestWithMethod:@"messages.send"
                          andParameters:[NSDictionary dictionaryWithObjectsAndKeys:text, @"message", [dialog chatId], [dialog chatIdKey], nil]
                          andHttpMethod:@"POST"];
    [sendMessage executeWithResultBlock:^(VKResponse *response) {

    } errorBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Scroll view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([scrollView isEqual:tableView])
    {
        [[self textView] endEditing:YES];
    }
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
