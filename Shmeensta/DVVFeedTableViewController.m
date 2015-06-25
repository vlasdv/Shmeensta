//
//  DVVFeedTableViewController.m
//  Shmeensta
//
//  Created by Dmitrii Vlasov on 23.06.15.
//  Copyright (c) 2015 Dmitry Vlasov. All rights reserved.
//

//https://api.instagram.com/v1/users/self/feed?access_token=ACCESS-TOKEN

#import "DVVFeedTableViewController.h"
#import "DVVFeedTableViewCell.h"
#import "DVVPost.h"

@interface DVVFeedTableViewController () <NSURLSessionTaskDelegate>

@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation DVVFeedTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.userID) {
        self.userID = @"self";
    }
    
    [self loadDataForUserID:self.userID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"%d", [self.posts count]);
    return [self.posts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    DVVFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DVVFeedCell"];
    
    DVVPost *currentPost = [self.posts objectAtIndex:indexPath.row];
    
    NSURL *photoURL = currentPost.standardResolutionPhoto;
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:photoURL
                                             completionHandler:^(NSData *data, NSURLResponse *response,
                                                                 NSError *error) {
                                                 if (!error) {
                                                     UIImage *image = [[UIImage alloc] initWithData:data];
//                                                     photo.thumbNail = image;
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                                         cell.imageView.image = image;
                                                         cell.textLabel.text = currentPost.username;
                                                         NSLog(@"%@", currentPost.username);
                                                     });
                                                 } else {
                                                     // HANDLE ERROR //
                                                 }
                                             }];
    [dataTask resume];
    
    return cell;
}

#pragma mark - NSURLSession

- (void)loadDataForUserID:(NSString *)userID {

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaults objectForKey:@"accessToken"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *stringURL = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/feed?access_token=%@", userID, token];
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    NSLog(@"%@", self.session);
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if (httpResponse.statusCode == 200) {
                NSError *jsonError;
                NSArray *jsonData = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError] objectForKey:@"data"];

                if (!jsonError) {
                    
                    NSMutableArray *posts = [NSMutableArray array];
                    for (NSDictionary *jsonPost in jsonData) {
                        DVVPost *post = [[DVVPost alloc] initWithJSONData:jsonPost];
                        [posts addObject:post];
                    }
                    
//                    [posts sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//                        return [obj1 compare:obj2];
//                    }];
                    
                    self.posts = posts;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                        [self.tableView reloadData];
                    });
                }
            }
        }
    }];
    
    [dataTask resume];
    
    
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_progress setProgress:
//         (double)totalBytesSent /
//         (double)totalBytesExpectedToSend animated:YES];
//    });
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    // 1
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//        _uploadView.hidden = YES;
//        [_progress setProgress:0.5];
//    });
//    
    if (!error) {
        // 2
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadDataForUserID:self.userID];
        });
    } else {
        // Alert for error
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
