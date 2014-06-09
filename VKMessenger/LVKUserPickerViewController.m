//
//  LVKUserPickerViewController.m
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKUserPickerViewController.h"
#import "LVKUserViewController.h"

@interface LVKUserPickerViewController ()
{
    NSMutableArray *_objects, *_filteredObjects;
    NSString *searchString;
    BOOL isLoading;
}
@end

@implementation LVKUserPickerViewController

@synthesize tableView, searchBar, callerViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadData];
}

- (void)loadSearchData:(int)offset
{
    NSString *currentSearchString = [NSString stringWithString:searchString];
    
    if(currentSearchString.length > 0)
    {
        if([VKSdk isLoggedIn] && !isLoading)
        {
            isLoading = YES;
            VKRequest *users = [VKApi
                                  requestWithMethod:@"users.search"
                                  andParameters:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"sort", @"photo_100", @"fields", currentSearchString, @"q", [NSNumber numberWithInt:offset], @"offset", nil]
                                  andHttpMethod:@"GET"];
            users.attempts = 2;
            users.requestTimeout = 5;
            [users executeWithResultBlock:^(VKResponse *response) {
                LVKUsersCollection *usersCollection = [[LVKUsersCollection alloc] initWithDictionary:response.json];
                
                _filteredObjects = [NSMutableArray arrayWithArray:[usersCollection users]];
                
                if(![searchString isEqual:currentSearchString])
                {
                    [self performSelector:@selector(loadSearchData:) withObject:0 afterDelay:1];
                }

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
                [self performSelector:@selector(loadSearchData:) withObject:0 afterDelay:2];
                isLoading = NO;
            }];
        }
    }
    else
    {
        _filteredObjects = [NSMutableArray arrayWithArray:_objects];
        [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
}

- (void)loadData
{
    if([VKSdk isLoggedIn])
    {
        isLoading = YES;
        VKRequest *friends = [VKApi
                              requestWithMethod:@"friends.get"
                              andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"hints", @"order", @"photo_100", @"fields", nil]
                              andHttpMethod:@"GET"];
        friends.attempts = 2;
        friends.requestTimeout = 5;
        [friends executeWithResultBlock:^(VKResponse *response) {
            LVKUsersCollection *usersCollection = [[LVKUsersCollection alloc] initWithDictionary:response.json];

            _objects = [NSMutableArray arrayWithArray:[usersCollection users]];
            _filteredObjects = [NSMutableArray arrayWithArray:_objects];
            
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _filteredObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    
    LVKUser *user = _filteredObjects[indexPath.row];
    [(UILabel *)[cell viewWithTag:1] setText:[user fullName]];
    [(UIImageView *)[cell viewWithTag:2] setImageWithURL:[user photo_100]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    LVKUser *user = _filteredObjects[indexPath.row];
    
    UIStoryboard *storyboard = nil;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        
    }
    else
    {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    }
    
    LVKDialogViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"chatViewController"];
    [detailViewController setDialog:[user createDialog]];
    
    [[callerViewController navigationController] pushViewController:detailViewController animated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchString = searchText;
    [self loadSearchData:0];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (IBAction)closeModal:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Scroll view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[self searchBar] endEditing:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showUserInfo"]) {
        LVKUser *object = nil;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        object = _objects[indexPath.row];
        
        [(LVKUserViewController *)[segue destinationViewController] setUser:object];
    }
}

@end
