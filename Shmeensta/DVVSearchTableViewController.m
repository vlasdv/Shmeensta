//
//  DVVSearchTableViewController.m
//  Shmeensta
//
//  Created by Dmitrii Vlasov on 28.06.15.
//  Copyright (c) 2015 Dmitry Vlasov. All rights reserved.
//

#import "DVVSearchTableViewController.h"
#import "DVVUser.h"
#import "DVVServerManager.h"
#import "DVVFeedTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DVVSearchTableViewCell.h"

@interface DVVSearchTableViewController ()

@property (strong, nonatomic) NSArray *users;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation DVVSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.tintColor = [UIColor darkGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)fetchDataForUsername:(NSString *)username {
    
    [[DVVServerManager sharedManager] searchForUsersWithUsername:username success:^(NSArray *users) {
       
        self.users = users;

        dispatch_async(dispatch_get_main_queue(), ^{

            [self.tableView reloadData];
        });
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"DVVSearchTableViewCell";
    DVVSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    DVVUser *user = [self.users objectAtIndex:indexPath.row];
    cell.usernameLabel.text = user.username;    
    [cell.userpicImageView sd_setImageWithURL:user.profilePicture];
    
    return cell;
}

#pragma mark - UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self fetchDataForUsername:self.searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.users = nil;
        [self.tableView reloadData];
    } else {
        [self fetchDataForUsername:searchText];
    }
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    [self.searchBar setShowsCancelButton:NO animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"DVVShowFeed"]) {
        
        DVVFeedTableViewController *vc = (DVVFeedTableViewController *)[segue destinationViewController];
        DVVUser *currentUser = [self.users objectAtIndex:[[self.tableView indexPathForCell:sender] row]];
        vc.userID = currentUser.userID;
    }
}

@end
