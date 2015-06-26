//
//  DVVServerManager.m
//  Shmeensta
//
//  Created by Dmitrii Vlasov on 27.06.15.
//  Copyright (c) 2015 Dmitry Vlasov. All rights reserved.
//

#import "DVVServerManager.h"
#import "DVVPost.h"

@interface DVVServerManager()

@property (strong, nonatomic) NSMutableArray *postsArray;

@property (assign, nonatomic) BOOL onOff;

@property (strong, nonatomic) NSArray *allPosts;

@end

@implementation DVVServerManager

typedef void (^SuccessBlock)(NSArray *);

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration];
        
        self.onOff = YES;
    }
    return self;
}

+ (DVVServerManager *)sharedManager {
    
    static DVVServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DVVServerManager alloc] init];
    });
    
    return manager;
}

- (NSString *)getAccessToken {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:@"accessToken"];
}

- (void)fetchAllPostsForUserID:(NSString *)userID success:(void(^)(NSArray *posts))success {
   
    NSString *stringURL = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@", userID, [self getAccessToken]];
    NSURL *url = [NSURL URLWithString:stringURL];
    
    self.allPosts = [NSArray array];
    
    [self fetchAllPostsFromURL:url success:^(NSArray *posts) {
        success(posts);
    }];
}

- (void)fetchAllPostsFromURL:(NSURL *)url success:(void(^)(NSArray *posts))success {
    
    __block NSArray *allPosts = [NSMutableArray array];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        if (!error) {
        
            NSError *jsonError = nil;
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if ([result isKindOfClass:[NSDictionary class]] && !jsonError) {
                
                NSMutableArray *tempArray = [NSMutableArray array];
                for (NSDictionary *jsonPost in [result objectForKey:@"data"]) {
                    DVVPost *post = [[DVVPost alloc] initWithJSONData:jsonPost];
                    [tempArray addObject:post];
                }
                allPosts = [NSArray arrayWithArray:tempArray];
            }
        
            NSURL *paginationURL = [self getPaginationURLFromResult:result];

            if (paginationURL) {
                
                [self fetchAllPostsFromURL:paginationURL success:^(NSArray *posts) {
                    allPosts = [allPosts arrayByAddingObjectsFromArray:posts];
                    success(allPosts);
                }];
                
            } else {
                
                success(allPosts);
            }

        } else {

            NSLog(@"error: %@", [error localizedDescription]);
        }
        
        
    }];
    
    [dataTask resume];
}

- (NSURL *)getPaginationURLFromResult:(NSDictionary *)result {
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        if ([[result objectForKey:@"pagination"] isKindOfClass:[NSDictionary class]]) {
            NSString *stringURL = [[result objectForKey:@"pagination"] objectForKey:@"next_url"];
            
            return [NSURL URLWithString:stringURL];
        }
    }
    return nil;
}

@end
