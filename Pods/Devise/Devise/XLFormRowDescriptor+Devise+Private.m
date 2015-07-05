//
//  XLFormRowDescriptor+Devise+Private.m
//  Devise
//
//  Created by Wojciech Trzasko on 23.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormRowDescriptor+Devise+Private.h"

#import "DVSAccessibilityLabels.h"
#import "XLForm.h"

@implementation XLFormRowDescriptor (Devise)

#pragma mark - Custom textFields

+ (XLFormRowDescriptor *)dvs_emailRowWithTag:(NSString *)tag {
    XLFormRowDescriptor *emailRow = [XLFormRowDescriptor formRowDescriptorWithTag:tag
                                                                          rowType:XLFormRowDescriptorTypeEmail
                                                                            title:NSLocalizedString(@"E-mail", nil)];
    [emailRow dvs_setAccessibilityLabel:NSLocalizedString(DVSAccessibilityLabelEmailTextField, nil)];
    
    return emailRow;
}

+ (XLFormRowDescriptor *)dvs_passwordRowWithTag:(NSString *)tag {
    XLFormRowDescriptor *passwordRow = [XLFormRowDescriptor formRowDescriptorWithTag:tag
                                                                             rowType:XLFormRowDescriptorTypePassword
                                                                               title:NSLocalizedString(@"Password", nil)];
    [passwordRow dvs_setAccessibilityLabel:NSLocalizedString(DVSAccessibilityLabelPasswordTextField, nil)];
    
    return passwordRow;
}

#pragma mark - Custom buttons

+ (XLFormRowDescriptor *)dvs_buttonRowWithTag:(NSString *)tag title:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel color:(UIColor *)color action:(void (^)(XLFormRowDescriptor *))action {
    XLFormRowDescriptor *buttonRow = [XLFormRowDescriptor formRowDescriptorWithTag:tag
                                                                           rowType:XLFormRowDescriptorTypeButton
                                                                             title:title];
    [buttonRow dvs_customizeTextWithColor:color alignment:NSTextAlignmentCenter];
    [buttonRow dvs_setAccessibilityLabel:accessibilityLabel];
    buttonRow.action.formBlock = action;
    
    return buttonRow;
}

#pragma mark - Private methods

- (void)dvs_customizeTextWithColor:(UIColor *)color alignment:(NSTextAlignment)alignment {
    [self.cellConfig setObject:color forKey:@"textLabel.textColor"];
    [self.cellConfig setObject:@(alignment) forKey:@"textLabel.textAlignment"];
}

- (void)dvs_setAccessibilityLabel:(NSString *)accessibilityLabel {
    if ([self.rowType isEqualToString:XLFormRowDescriptorTypeButton]) {
        [self dvs_setAccessibilityLabel:accessibilityLabel forKeyByComponents:@[ @"self", @"accessibilityLabel"]];
    } else if ([self.rowType isEqualToString:XLFormRowDescriptorTypeText]
               || [self.rowType isEqualToString:XLFormRowDescriptorTypeEmail]
               || [self.rowType isEqualToString:XLFormRowDescriptorTypePassword]) {
        [self dvs_setAccessibilityLabel:accessibilityLabel forKeyByComponents:@[ @"textField", @"accessibilityLabel"]];
    } else {
        NSAssert(NO, @"Row type not supported.");
    }
}

- (void)dvs_setAccessibilityLabel:(NSString *)accessibilityLabel forKeyByComponents:(NSArray *)components {
    NSString *key = [components componentsJoinedByString:@"."];
    [self.cellConfig setObject:accessibilityLabel forKey:key];
}

@end
