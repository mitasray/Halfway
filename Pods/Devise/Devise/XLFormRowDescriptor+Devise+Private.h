//
//  XLFormRowDescriptor+Devise+Private.h
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormRowDescriptor.h"

@interface XLFormRowDescriptor (Devise)

+ (XLFormRowDescriptor *)dvs_emailRowWithTag:(NSString *)tag;
+ (XLFormRowDescriptor *)dvs_passwordRowWithTag:(NSString *)tag;
+ (XLFormRowDescriptor *)dvs_buttonRowWithTag:(NSString *)tag title:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel color:(UIColor *)color action:(void (^)(XLFormRowDescriptor *))action;

- (void)dvs_customizeTextWithColor:(UIColor *)color alignment:(NSTextAlignment)alignment;

@end
