//
//  XLFormSectionDescriptor+Devise+Private.m
//  Devise
//
//  Created by Wojciech Trzasko on 29.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormSectionDescriptor+Devise+Private.h"

#import "DVSAccessibilityLabels.h"
#import "XLFormRowDescriptor+Devise+Private.h"

NSString * const DVSFormEmailTag = @"email";
NSString * const DVSFormPasswordTag = @"password";
NSString * const DVSFormProceedButtonTag = @"proceedButton";
NSString * const DVSFormDismissButtonTag = @"dismissButton";
NSString * const DVSFormPresentButtonTag = @"presentButton";

@implementation XLFormSectionDescriptor (Devise)

- (void)dvs_addEmailAndPasswordTextFields {
    [self dvs_addEmailTextField];
    [self dvs_addPasswordTextField];
}

- (void)dvs_addEmailTextField {
    [self addFormRow:[XLFormRowDescriptor dvs_emailRowWithTag:DVSFormEmailTag]];
}

- (void)dvs_addPasswordTextField {
    [self addFormRow:[XLFormRowDescriptor dvs_passwordRowWithTag:DVSFormPasswordTag]];
}

- (void)dvs_addDismissButtonWithAction:(void (^)(XLFormRowDescriptor *))action {
    [self dvs_addDismissButtonWithTitle:NSLocalizedString(@"Cancel", nil)
                     accessibilityLabel:NSLocalizedString(DVSAccessibilityLabelCancelButton, nil)
                                 action:action];
}

- (void)dvs_addDismissButtonWithTitle:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel action:(void (^)(XLFormRowDescriptor *))action {
    [self addFormRow:[XLFormRowDescriptor dvs_buttonRowWithTag:DVSFormDismissButtonTag
                                                         title:title
                                            accessibilityLabel:accessibilityLabel
                                                         color:[UIColor redColor]
                                                        action:action]];
}

- (void)dvs_addProceedButtonWithTitle:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel action:(void (^)(XLFormRowDescriptor *))action {
    [self addFormRow:[XLFormRowDescriptor dvs_buttonRowWithTag:DVSFormProceedButtonTag
                                                         title:title
                                            accessibilityLabel:accessibilityLabel
                                                         color:[UIColor blueColor]
                                                        action:action]];
}

- (void)dvs_addPresentButtonWithTitle:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel action:(void (^)(XLFormRowDescriptor *))action {
    [self addFormRow:[XLFormRowDescriptor dvs_buttonRowWithTag:DVSFormPresentButtonTag
                                                         title:title
                                            accessibilityLabel:accessibilityLabel
                                                         color:[UIColor redColor]
                                                        action:action]];
}

@end
