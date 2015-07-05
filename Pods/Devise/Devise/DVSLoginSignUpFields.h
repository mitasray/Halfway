//
//  DVSLoginSignUpFields.h
//  Devise
//
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#ifndef Devise_DVSLoginSignUpFields_h
#define Devise_DVSLoginSignUpFields_h

/**
 * A bitmask specifying elements which are enabled
 */
typedef NS_OPTIONS(NSInteger, DVSAccountRetrieverFields) {
    DVSAccountRetrieverFieldEmailAndPassword           = 1 << 0,
    DVSAccountRetrieverFieldProceedButton              = 1 << 1,
    DVSAccountRetrieverFieldDismissButton              = 1 << 2,
    DVSAccountRetrieverFieldNavigationProceedButton    = 1 << 3,
    DVSAccountRetrieverFieldNavigationDismissButton    = 1 << 4,
    DVSAccountRetrieverFieldPasswordReminder           = 1 << 5
};

#endif
