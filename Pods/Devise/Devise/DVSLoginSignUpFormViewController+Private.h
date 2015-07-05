//
//  DVSLoginSignUpFormViewController+Private.h
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "XLForm/XLFormViewController.h"

#import "DVSLoginSignUpFields.h"

@protocol DVSLoginSignUpFormViewControllerDelegate;

@interface DVSLoginSignUpFormViewController : XLFormViewController

@property (weak, nonatomic) id<DVSLoginSignUpFormViewControllerDelegate> delegate;

- (instancetype)initWithFields:(DVSAccountRetrieverFields)fields proceedTitle:(NSString *)proceedTitle proceedAccessibilityLabel:(NSString *)accessibilityLabel;

@end

@protocol DVSLoginSignUpFormViewControllerDelegate <NSObject>

@optional
- (void)logInSignUpFormViewController:(DVSLoginSignUpFormViewController *)formController didSelectProceedRow:(XLFormRowDescriptor *)row;
- (void)logInSignUpFormViewController:(DVSLoginSignUpFormViewController *)formController didSelectDismissRow:(XLFormRowDescriptor *)row;
- (void)logInSignUpFormViewController:(DVSLoginSignUpFormViewController *)formController didSelectPresentRow:(XLFormRowDescriptor *)row;

@end