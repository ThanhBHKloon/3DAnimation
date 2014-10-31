//
//  UIDeviceHardware.m
//  publisher
//
//  Created by Thomas Binzinger on 29.03.11.
//  Copyright 2011 area851 LLC. All rights reserved.
//
//  based on the following stackoverflow thread: http://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk
//  some changes & extensions

#import "UIDeviceHardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDeviceHardware

- (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSISOLatin1StringEncoding];
    free(machine);
    if ([platform isEqualToString:@"i386"] ||
        [platform isEqualToString:@"x86_64"]) {
        if ([self isIPad]) {
            return @"iPadSimulator";
        } else {
            return @"iPhoneSimulator";
        }
    }
    return platform;
}

//- (BOOL)hasMultitasking {
//    if ([self respondsToSelector:@selector(isMultitaskingSupported)]) {
//        return [self isMultitaskingSupported];
//    }
//    return NO;
//}

- (BOOL)hasRetinaDisplay {
    // http://stackoverflow.com/questions/3504173/detect-retina-display
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)) {
        // Retina display
        return(YES);
    } else {
        // non-Retina display
        return(NO);
    }
}

// does the device has a 4" display (= 568 points vertically, aka iphone5)?
- (BOOL) has4InchDisplay {
    
    if( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] )
    {
        /* Detect using nativeBounds - iOS 8 and greater */
        return(fabs( ( double )[ [ UIScreen mainScreen ] nativeBounds ].size.height - ( double )1136 ) < DBL_EPSILON);
    }
    else
    {
        /* Detect using bounds - iOS 7 and lower */
        return(fabs( (double)[[ UIScreen mainScreen ] bounds].size.height - (double)568) < DBL_EPSILON );
    }
    
    return NO;
}

- (BOOL) isIPad {
    return(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

- (NSString *) platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4"; //Verizon
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad-3G (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad-3G (4G)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad-3G (4G)";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5th generation";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (Wifi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (Wifi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air 3G";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini Original";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (Wifi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 3G";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5(GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5(GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c(GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c(GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s(GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s(GSM+CDMA)";
    return platform;
}

@end
