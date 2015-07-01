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
@property (strong, nonatomic) UIView *noPhotosView;


@end

@implementation DVVFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    [self addLoadingView];
    
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

#pragma mark - UI

- (void)addLoadingView {
    
    UIView *loadingView = [[UIView alloc] initWithFrame:self.view.frame];
    loadingView.backgroundColor = [UIColor colorWithRed:170.f green:170.f blue:170.f alpha:1.f];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - 60.f);
    [indicator startAnimating];
    
    [loadingView addSubview:indicator];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, CGRectGetMinY(indicator.frame) + 40.f, CGRectGetWidth(loadingView.frame), 70.f)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:12.f];
    label.numberOfLines = 0;
    label.text = @"your data is loading, \nit may take some time \n\n(●￣(ｴ)￣●)";
    
    [loadingView addSubview:label];
    
    self.loadingView = loadingView;
    
    [self.view addSubview:loadingView];
}

- (void)addNoPhotosView {
    
    UIView *noPhotosView = [[UIView alloc] initWithFrame:self.view.frame];
    
    noPhotosView.backgroundColor = [UIColor colorWithRed:170.f green:170.f blue:170.f alpha:1.f];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, CGRectGetMidY(noPhotosView.frame) - 80.f, CGRectGetWidth(noPhotosView.frame), 60.f)];
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:16.f];
    label.numberOfLines = 0;
    label.text = @"no photos \n\n(´∩｀。)";
    
    [noPhotosView addSubview:label];
    
    noPhotosView.alpha = 0.f;
    self.noPhotosView = noPhotosView;
    
    [self.view addSubview:noPhotosView];
}

#pragma mark - UITableViewDataSource

- (void)fetchData {
    [[DVVServerManager sharedManager] fetchAllPostsForUserID:self.userID success:^(NSArray *posts) {

        self.posts = [posts sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:1.f animations:^{
                self.loadingView.alpha = 0.f;

                if ([self.posts count] == 0) {
                    [self addNoPhotosView];
                    self.noPhotosView.alpha = 1.f;
                }
                
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