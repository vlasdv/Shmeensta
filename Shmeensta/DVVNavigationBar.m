//
//  DVVNavigationBar.m
//  Shmeensta
//
//  Created by Dmitrii Vlasov on 30.06.15.
//  Copyright (c) 2015 Dmitry Vlasov. All rights reserved.
//

#import "DVVNavigationBar.h"

@implementation DVVNavigationBar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self setTitleTextAttributes:
         
        [NSDictionary dictionaryWithObjectsAndKeys:    [UIFont fontWithName: @"LobsterTwo" size:21], NSFontAttributeName,
                                                        NSForegroundColorAttributeName, [UIColor darkGrayColor],
                                                        nil]
        ];
        
        self.tintColor = [UIColor darkGrayColor];

    }
    return self;
}



@end
