//
//  DVSMacros.h
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#define DVSPragma(pragma) _Pragma(#pragma)
#define DVSWorkInProgress(msg) DVSPragma(message "[WIP] " msg)
#define DVSTemporary(msg) DVSPragma(message "[TEMP] " msg)

#ifdef DEBUG
    #define DVSDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define DVSDLog(...)
#endif
