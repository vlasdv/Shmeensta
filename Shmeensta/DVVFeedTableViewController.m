//
//  DVVFeedTableViewController.m
//  Shmeensta
//
//  Created by Dmitrii Vlasov on 26.06.15.
//  Copyright (c) 2015 Dmitry Vlasov. All rights reserved.
//

#import "DVVFeedTableViewCell.h"
#import "DVVPost.h"
#import "DVVFeedTableViewController.h"
#import "DVVServerManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DVVFeedTableViewController () <NSURLSessionTaskDelegate>

@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) UIView *loadingView;

@end

@implementation DVVFeedTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

//        self.userID = @"173571053";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    UIView *loadingView = [[UIView alloc] initWithFrame:self.view.frame];
    loadingView.backgroundColor = [UIColor colorWithRed:170.f green:170.f blue:170.f alpha:1.f];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - 60.f);
    [indicator startAnimating];
    
    [loadingView addSubview:indicator];
    
    self.loadingView = loadingView;
    
    [self.view addSubview:loadingView];
    
    if (!self.userID) {
        [[DVVServerManager sharedManager] selfUserIDwithSuccess:^(NSString *userID) {
            self.userID = userID;
            [self fetchData];
        }];
    } else {
        [self fetchData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (void)fetchData {
    [[DVVServerManager sharedManager] fetchAllPostsForUserID:self.userID success:^(NSArray *posts) {

        self.posts = [posts sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        NSLog(@"count %lu", (unsigned long)[posts count]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:1.f animations:^{
                self.loadingView.alpha = 0.f;
            }];
            
            [self.tableView reloadData];
        });
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.posts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DVVFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVVFeedCell"];
    DVVPost *currentPost = [self.posts objectAtIndex:indexPath.row];
    NSURL *photoURL = currentPost.standardResolutionPhoto;

    [cell.photoImageView sd_setImageWithURL:photoURL];
    cell.likesLabel.text = [NSString stringWithFormat:@"%ld   ", (long)currentPost.numberOfLikes];

    return cell;
}



@end