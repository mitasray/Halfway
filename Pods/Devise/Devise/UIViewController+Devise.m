//
//  UIViewController+Devise.m
//  Devise
//
//  Created by Wojciech Trzasko on 30.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "UIViewController+Devise.h"

@implementation UIViewController (Devise)

- (void)attachViewController:(UIViewController *)controller {
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

@end
