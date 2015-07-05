//
//  DVSLoginSignUpFormViewController+Private.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSLoginSignUpFormViewController+Private.h"

#import "DVSAccessibilityLabels.h"
#import "DVSFieldsUtils+Private.h"
#import "XLFormRowDescriptor+Devise+Private.h"
#import "XLFormSectionDescriptor+Devise+Private.h"

@implementation DVSLoginSignUpFormViewController

#pragma mark - Initialization

- (instancetype)initWithFields:(DVSAccountRetrieverFields)fields proceedTitle:(NSString *)proceedTitle proceedAccessibilityLabel:(NSString *)accessibilityLabel {
    self = [super initWithForm:[self formWithFields:fields proceedTitle:proceedTitle proceedAccessibilityLabel:accessibilityLabel]];
    return self;
}

#pragma mark - Form creation

- (XLFormDescriptor *)formWithFields:(DVSAccountRetrieverFields)fields proceedTitle:(NSString *)proceedTitle proceedAccessibilityLabel:(NSString *)accessibilityLabel {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptor];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:proceedTitle];
    
    if ([DVSFieldsUtils shouldShow:DVSAccountRetrieverFieldEmailAndPassword basedOn:fields]) {
        [section dvs_addEmailAndPasswordTextFields];
    }
    
    __weak typeof(self) weakSelf = self;
    
    if ([DVSFieldsUtils shouldShow:DVSAccountRetrieverFieldProceedButton basedOn:fields]) {
        [section dvs_addProceedButtonWithTitle:proceedTitle
                            accessibilityLabel:accessibilityLabel
                                        action:^(XLFormRowDescriptor *sender) {
                                            if ([weakSelf.delegate respondsToSelector:@selector(logInSignUpFormViewController:didSelectProceedRow:)]) {
                                                [weakSelf.delegate logInSignUpFormViewController:weakSelf didSelectProceedRow:sender];
                                            }
                                            [weakSelf deselectFormRow:sender];
                                        }];
    }
    
    if ([DVSFieldsUtils shouldShow:DVSAccountRetrieverFieldPasswordReminder basedOn:fields]) {
        [section dvs_addPresentButtonWithTitle:NSLocalizedString(@"Remind password", nil)
                            accessibilityLabel:NSLocalizedString(DVSAccessibilityLabelMoveToPasswordRemindButton, nil)
                                        action:^(XLFormRowDescriptor *sender) {
                                            if ([weakSelf.delegate respondsToSelector:@selector(logInSignUpFormViewController:didSelectPresentRow:)]) {
                                                [weakSelf.delegate logInSignUpFormViewController:weakSelf didSelectPresentRow:sender];
                                            }
                                            [weakSelf deselectFormRow:sender];
                                        }];
    }
    
    if ([DVSFieldsUtils shouldShow:DVSAccountRetrieverFieldDismissButton basedOn:fields]) {
        [section dvs_addDismissButtonWithAction:^(XLFormRowDescriptor *sender) {
            if ([weakSelf.delegate respondsToSelector:@selector(logInSignUpFormViewController:didSelectDismissRow:)]) {
                [weakSelf.delegate logInSignUpFormViewController:weakSelf didSelectDismissRow:sender];
            }
            [weakSelf deselectFormRow:sender];
        }];
    }
    
    [form addFormSection:section];
    
    
    return form;
}

@end


