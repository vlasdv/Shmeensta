//
//  DVVPost.m
//  Shmeensta
//
//  Created by Dmitrii Vlasov on 25.06.15.
//  Copyright (c) 2015 Dmitry Vlasov. All rights reserved.
//

#import "DVVPost.h"

@implementation DVVPost

- (id)initWithJSONData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        
        NSDictionary *user = [data objectForKey:@"user"];
        self.username = [user objectForKey:@"username"];
        self.userID = [user objectForKey:@"id"];
        self.profilePicture = [NSURL URLWithString:[user objectForKey:@"profile_picture"]];
        
        NSDictionary *caption = [data objectForKey:@"caption"];
        if ([caption class] != [NSNull class]) {
            self.captionText = [caption objectForKey:@"text"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            self.createdTime = [formatter dateFromString:[caption objectForKey:@"text"]];
        }

        self.standardResolutionPhoto = [NSURL URLWithString:[[[data objectForKey:@"images"] objectForKey:@"standard_resolution"] objectForKey:@"url"]];
        self.lowResolutionPhoto = [NSURL URLWithString:[[[data objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"]];

        self.likes = [data objectForKey:@"likes"];
        self.numberOfLikes = [[[data objectForKey:@"likes"] objectForKey:@"count"] integerValue];
        
        self.comments = [data objectForKey:@"comments"];
        
    }
    return self;
}

- (NSInteger)getNumberOfComments {

    /*
    comments =             {
        count = 1;
        data =                 (
                                {
                                    "created_time" = 1435234750;
                                    from =                         {
                                        "full_name" = "Wesley Carlisle";
                                        id = 308057387;
                                        "profile_picture" = "https://igcdn-photos-d-a.akamaihd.net/hphotos-ak-xpf1/t51.2885-19/11049437_341481056043819_1185052903_a.jpg";
                                        username = terranceandthethugsquad;
                                    };
                                    id = 1015145123170734702;
                                    text = "@amylarabaxter";
                                }
                                );
    */
    return [[self.comments objectForKey:@"count"] integerValue];
}

- (NSInteger)getNumberOfLikes {
    
    /*
    likes =             {
        count = 352;
        data =                 (
                                {
                                    "full_name" = "Thunderous Genius";
                                    id = 2011686758;
                                    "profile_picture" = "https://igcdn-photos-g-a.akamaihd.net/hphotos-ak-xaf1/t51.2885-19/11312145_1416895975299822_1356645597_a.jpg";
                                    username = thunderousgenius;
                                }
                                );
     */
    if (self.likes != NULL) {
        return [[self.likes objectForKey:@"count"] integerValue];
    } else {
        return 0;
    }

}

- (NSComparisonResult)compare:(DVVPost *)other
{
    NSComparisonResult order;
    
    // first compare modified
    order = [[NSNumber numberWithInteger:other.numberOfLikes] compare:[NSNumber numberWithInteger:self.numberOfLikes]];
    // if same modified alpha by path
//    if (order == NSOrderedSame) {
//        order = [other.createdTime compare:self.createdTime];
//    }
    return order;
}

@end
