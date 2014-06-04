//
//  LVKMasterViewController.m
//  VKMessenger
//
//  Created by Leonid Repin on 03.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKMasterViewController.h"
#import "LVKDetailViewController.h"
#import "LVKUserPickerViewController.h"

@interface LVKMasterViewController () {
    NSMutableArray *_objects;
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
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

#pragma mark - iPad
//    self.detailViewController = (LVKDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    [self registerObservers];
    
    [self loadData:0];
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
            VKRequest *users = [[VKApi users] get:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@", [[newMessageUpdate dialog] chatId]], @"user_ids", @"photo_200", @"fields", nil]];
            
            [users executeWithResultBlock:^(VKResponse *response) {
                LVKUsersCollection *usersCollection = [[LVKUsersCollection alloc] initWithArray:response.json];
                
                [[newMessageUpdate dialog] adoptUser:[[usersCollection users] firstObject]];
                
                [_objects insertObject:[newMessageUpdate dialog] atIndex:0];
                
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            } errorBlock:^(NSError *error) {
                NSLog(@"%@", error);
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
}

- (void)loadData:(int)offset
{
    if([VKSdk isLoggedIn])
    {
        VKRequest *dialogs = [VKApi
                              requestWithMethod:@"messages.getDialogs"
                              andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"60", @"count", [NSNumber numberWithInt:offset], @"offset", nil]
                              andHttpMethod:@"GET"];
        [dialogs executeWithResultBlock:^(VKResponse *response) {
            LVKDialogsCollection *dialogsCollection = [[LVKDialogsCollection alloc] initWithDictionary:response.json];
            NSString *userIdsCSV = [[dialogsCollection getUserIds] componentsJoinedByString:@","];
            
            if([userIdsCSV length] > 0)
            {
                VKRequest *users = [[VKApi users] get:[NSDictionary dictionaryWithObjectsAndKeys:userIdsCSV, @"user_ids", @"photo_200", @"fields", nil]];
                
                [users executeWithResultBlock:^(VKResponse *response) {
                    LVKUsersCollection *usersCollection = [[LVKUsersCollection alloc] initWithArray:response.json];
                    
                    [dialogsCollection adoptUserCollection:usersCollection];
                    
                    _objects = [NSMutableArray arrayWithArray:[dialogsCollection dialogs]];
                    
                    [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                } errorBlock:^(NSError *error) {
                    NSLog(@"%@", error);
                }];
            }
            else
            {
                _objects = [NSMutableArray arrayWithArray:[dialogsCollection dialogs]];
                
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
        } errorBlock:^(NSError *error) {
            NSLog(@"%@", error);
        }];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    LVKDialog *dialog = _objects[indexPath.row];
    cell.textLabel.text = [dialog title];
    cell.detailTextLabel.text = [[dialog lastMessage] body];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        LVKDialog *object = nil;
    
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        object = _objects[indexPath.row];
        
        [[segue destinationViewController] setDialog:object];
    }
    else if ([[segue identifier] isEqualToString:@"pickUsers"]) {
        NSLog(@"%@ %@", [segue destinationViewController], [[segue destinationViewController] topViewController]);
        [(LVKUserPickerViewController *)[[segue destinationViewController] topViewController] setCallerViewController:self];
    }
}

@end
