//
//  LVKUserPickerViewController.m
//  VKMessenger
//
//  Created by Leonid Repin on 04.06.14.
//  Copyright (c) 2014 Levelab. All rights reserved.
//

#import "LVKUserPickerViewController.h"

@interface LVKUserPickerViewController ()
{
    NSMutableArray *_objects, *_filteredObjects;
}
@end

@implementation LVKUserPickerViewController

@synthesize tableView, callerViewController;

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
    [self loadData:0];
}

- (void)loadData:(int)offset
{
    if([VKSdk isLoggedIn])
    {
        VKRequest *friends = [VKApi
                              requestWithMethod:@"friends.get"
                              andParameters:[NSDictionary dictionaryWithObjectsAndKeys:@"hints", @"order", @"photo_200", @"fields", nil]
                              andHttpMethod:@"GET"];
        [friends executeWithResultBlock:^(VKResponse *response) {
            LVKUsersCollection *usersCollection = [[LVKUsersCollection alloc] initWithDictionary:response.json];

            _objects = [NSMutableArray arrayWithArray:[usersCollection users]];
            _filteredObjects = [NSMutableArray arrayWithArray:_objects];
            
            [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    LVKUser *user = _filteredObjects[indexPath.row];
    cell.textLabel.text = [user fullName];
    
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
    
    LVKDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"chatViewController"];
    [detailViewController setDialog:[user createDialog]];
    
    [[callerViewController navigationController] pushViewController:detailViewController animated:NO];
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _filteredObjects = [NSMutableArray arrayWithArray:[_objects filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(LVKUser *user, NSDictionary *bindings) {
        return [[user fullName] rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound;
    }]]];
    [tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (IBAction)closeModal:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
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
