//
//  XLFormSectionDescriptor+Devise+Private.h
//  Devise
//
//  Created by Wojciech Trzasko on 29.12.2014.
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormSectionDescriptor.h"

extern NSString * const DVSFormEmailTag;
extern NSString * const DVSFormPasswordTag;
extern NSString * const DVSFormProceedButtonTag;
extern NSString * const DVSFormDismissButtonTag;
extern NSString * const DVSFormPresentButtonTag;

@interface XLFormSectionDescriptor (Devise)

- (void)dvs_addEmailAndPasswordTextFields;
- (void)dvs_addEmailTextField;
- (void)dvs_addPasswordTextField;

- (void)dvs_addDismissButtonWithAction:(void (^)(XLFormRowDescriptor *sender))action;
- (void)dvs_addDismissButtonWithTitle:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel action:(void (^)(XLFormRowDescriptor *sender))action;
- (void)dvs_addProceedButtonWithTitle:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel action:(void (^)(XLFormRowDescriptor *sender))action;
- (void)dvs_addPresentButtonWithTitle:(NSString *)title accessibilityLabel:(NSString *)accessibilityLabel action:(void (^)(XLFormRowDescriptor *sender))action;

@end
