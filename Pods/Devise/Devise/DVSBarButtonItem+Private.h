//
//  DVSBarButtonItem+Private.h
//  Devise
//
//  Created by Wojciech Trzasko on 29.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVSBarButtonItem : UIBarButtonItem

- (instancetype)initWithTitle:(NSString *)title action:(void (^)(DVSBarButtonItem *sender))action;

@end
