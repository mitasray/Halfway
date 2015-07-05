//
//  DVSPasswordReminderFormViewControllers+Private.m
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSPasswordReminderFormViewController+Private.h"

#import "DVSAccessibilityLabels.h"
#import "DVSFieldsUtils+Private.h"
#import "XLFormRowDescriptor+Devise+Private.h"
#import "XLFormSectionDescriptor+Devise+Private.h"

@implementation DVSPasswordReminderFormViewController

#pragma mark - Initialization

- (instancetype)init {
    self = [super initWithForm:[self defaultForm]];
    return self;
}

#pragma mark - Form creation

- (XLFormDescriptor *)defaultForm {
    XLFormDescriptor *form = [XLFormDescriptor formDescriptor];
    
    XLFormSectionDescriptor *section = [XLFormSectionDescriptor formSectionWithTitle:NSLocalizedString(@"Remind", nil)];
    
    __weak typeof(self) weakSelf = self;
    
    [section dvs_addEmailTextField];
    [section dvs_addProceedButtonWithTitle:NSLocalizedString(@"Remind", nil)
                        accessibilityLabel:NSLocalizedString(DVSAccessibilityLabelConfirmRemindPasswordButton, nil)
                                    action:^(XLFormRowDescriptor *sender) {
                                        if ([weakSelf.delegate respondsToSelector:@selector(passwordReminderFormViewController:didSelectProceedRow:)]) {
                                            [weakSelf.delegate passwordReminderFormViewController:self didSelectProceedRow:sender];
                                        }
                                        [weakSelf deselectFormRow:sender];
                                    }];
    
    [section dvs_addDismissButtonWithTitle:NSLocalizedString(@"Cancel", nil)
                        accessibilityLabel:NSLocalizedString(DVSAccessibilityLabelCancelRemindPasswordButton, nil)
                                    action:^(XLFormRowDescriptor *sender) {
                                        if ([weakSelf.delegate respondsToSelector:@selector(passwordReminderFormViewController:didSelectDismissRow:)]) {
                                            [weakSelf.delegate passwordReminderFormViewController:self didSelectDismissRow:sender];
                                        }
                                        [weakSelf deselectFormRow:sender];
                                    }];
    
    [form addFormSection:section];
    
    return form;
}

@end
