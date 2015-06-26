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

        self.userID = @"173571053";
        
        [[DVVServerManager sharedManager] fetchAllPostsForUserID:self.userID success:^(NSArray *posts) {
            self.posts = [posts sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2];
            }];
            NSLog(@"count %lu", (unsigned long)[posts count]);
            [self.tableView reloadData];
        }];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.posts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DVVFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVVFeedCell"];
    DVVPost *currentPost = [self.posts objectAtIndex:indexPath.row];
    NSURL *photoURL = currentPost.standardResolutionPhoto;
#warning - weakcell
    NSURLSession *session = [[DVVServerManager sharedManager] session];
    cell.imageView.image = nil;
    cell.textLabel.text = @"";
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:photoURL
                                                 completionHandler:^(NSData *data, NSURLResponse *response,
                                                                     NSError *error) {
                                                     if (!error) {
                                                         UIImage *image = [[UIImage alloc] initWithData:data];
                                                         //                                                     photo.thumbNail = image;
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                             cell.imageView.image = image;
                                                             cell.textLabel.text = [NSString stringWithFormat:@"%@ : %ld", currentPost.username, (long)currentPost.numberOfLikes];
                                                         });
                                                     } else {
                                                         // HANDLE ERROR //
                                                     }
                                                 }];
    [dataTask resume];
    
    return cell;
}

@end