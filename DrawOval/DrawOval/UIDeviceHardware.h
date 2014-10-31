//
//  UIDeviceHardware.h
//  publisher
//
//  Created by Thomas Binzinger on 29.03.11.
//  Copyright 2011 area851 LLC. All rights reserved.
//
//  based on the following stackoverflow thread: http://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk
//  some changes & extensions

#import <Foundation/Foundation.h>


@interface UIDeviceHardware : NSObject {
}
- (NSString *) platform;
- (BOOL)hasRetinaDisplay;
- (BOOL) isIPad;
- (NSString *) platformString;    
- (BOOL)has4InchDisplay;
@end
