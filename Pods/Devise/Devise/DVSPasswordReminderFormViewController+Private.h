//
//  DVSPasswordReminderFormViewControllers+Private.h
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "XLFormViewController.h"

@protocol DVSPasswordReminderFormViewControllerDelegate;

@interface DVSPasswordReminderFormViewController : XLFormViewController

@property (weak, nonatomic) id<DVSPasswordReminderFormViewControllerDelegate> delegate;

@end

@protocol DVSPasswordReminderFormViewControllerDelegate <NSObject>

@optional
- (void)passwordReminderFormViewController:(DVSPasswordReminderFormViewController *)controller didSelectProceedRow:(XLFormRowDescriptor *)row;
- (void)passwordReminderFormViewController:(DVSPasswordReminderFormViewController *)controller didSelectDismissRow:(XLFormRowDescriptor *)row;

@end
