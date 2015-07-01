//
//  DVVPost.h
//  Shmeensta
//
//  Created by Dmitrii Vlasov on 25.06.15.
//  Copyright (c) 2015 Dmitry Vlasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVVPost : NSObject

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSURL *profilePicture;
@property (assign, nonatomic) NSDate *createdTime;
@property (strong, nonatomic) NSString *captionText;
@property (strong, nonatomic) NSURL *standardResolutionPhoto;
@property (strong, nonatomic) NSURL *lowResolutionPhoto;

@property (assign, nonatomic) NSDictionary *likes;

@property (assign, nonatomic) NSInteger numberOfLikes;

@property (strong, nonatomic) NSDictionary *comments;

- (id)initWithJSONData:(NSDictionary *)data;

- (NSInteger)getNumberOfLikes;
- (NSInteger)getNumberOfComments;

@end
