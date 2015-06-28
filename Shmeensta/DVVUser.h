//
//  DVVUser.h
//  Shmeensta
//
//  Created by Dmitrii Vlasov on 28.06.15.
//  Copyright (c) 2015 Dmitry Vlasov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVVUser : NSObject

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSURL *profilePicture;
@property (copy, nonatomic) NSString *userID;
@property (copy, nonatomic) NSString *lastName;

- (id)initWithJSONData:(NSDictionary *)data;

@end
