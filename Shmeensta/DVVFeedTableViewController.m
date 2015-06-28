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

@interface DVVFeedTableViewController () <NSURLSessionTaskDelegate>

@property (strong, nonatomic) NSArray *posts;

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

        NSLog(@"sorting start, %@", [NSDate date]);
        self.posts = [posts sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        NSLog(@"sorting finished, %@", [NSDate date]);
//        self.posts = posts;
        
        NSLog(@"count %lu", (unsigned long)[posts count]);
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.posts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DVVFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVVFeedCell"];
    DVVPost *currentPost = [self.posts objectAtIndex:indexPath.row];
    NSURL *photoURL = currentPost.standardResolutionPhoto;
#warning - weakcell
    NSURLSession *session = [[DVVServerManager sharedManager] session];
    
    cell.photoImageView.image = nil;
    cell.likesLabel.text = @"";
    
    __weak DVVFeedTableViewCell *weakCell = cell;
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:photoURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (!error) {
            UIImage *image = [[UIImage alloc] initWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                
                weakCell.photoImageView.image = image;
                weakCell.likesLabel.text = [NSString stringWithFormat:@"%ld   ", (long)currentPost.numberOfLikes];
//                weakCell.textLabel.text = [NSString stringWithFormat:@"%@ : %ld", currentPost.username, (long)currentPost.numberOfLikes];
                [weakCell layoutSubviews];

            });


            
        } else {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
    [dataTask resume];
    
    return cell;
}



@end