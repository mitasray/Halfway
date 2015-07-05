//
//  DVSBarButtonItem+Private.m
//  Devise
//
//  Created by Wojciech Trzasko on 29.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSBarButtonItem+Private.h"

@interface DVSBarButtonItem ()

@property (nonatomic, copy) void (^actionBlock)(DVSBarButtonItem *);

@end

@implementation DVSBarButtonItem

#pragma mark - Initialization

- (instancetype)initWithTitle:(NSString *)title action:(void (^)(DVSBarButtonItem *))action {
    if (self = [super initWithTitle:title
                              style:UIBarButtonItemStylePlain
                             target:self
                             action:@selector(callActionForItem:)]) {
        self.actionBlock = action;
    }
    return self;
}

#pragma mark - Action

- (void)callActionForItem:(DVSBarButtonItem *)item {
    if (self.actionBlock) {
        self.actionBlock(item);
    }
}

@end
