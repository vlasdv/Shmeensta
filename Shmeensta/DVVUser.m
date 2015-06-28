//
//  DVVUser.m
//  Shmeensta
//
//  Created by Dmitrii Vlasov on 28.06.15.
//  Copyright (c) 2015 Dmitry Vlasov. All rights reserved.
//

#import "DVVUser.h"

@implementation DVVUser

- (id)initWithJSONData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        
        self.username = [data objectForKey:@"username"];
        self.firstName = [data objectForKey:@"first_name"];
        self.profilePicture = [NSURL URLWithString:[data objectForKey:@"profile_picture"]];
        self.userID = [data objectForKey:@"id"];
        self.lastName = [data objectForKey:@"last_name"];
        
    }
    return self;
}

@end
