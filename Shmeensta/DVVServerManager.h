//
//  DVVServerManager.h
//  Shmeensta
//
//  Created by Dmitrii Vlasov on 27.06.15.
//  Copyright (c) 2015 Dmitry Vlasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVVServerManager : NSObject

@property (strong, nonatomic) NSURLSession *session;

+ (DVVServerManager *)sharedManager;

- (void)fetchAllPostsForUserID:(NSString *)userID success:(void(^)(NSArray *posts))success;

@end
