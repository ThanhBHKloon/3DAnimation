//
//  NSString+StrUtils.h
//  original used in dbPager
//
//  Created by Thomas Binzinger on 6/18/08.
//  Copyright 2008 Thomas Binzinger. All rights reserved.
//
//	renamed, updated 29/12/2010

#import <UIKit/UIKit.h>


@interface NSString ( StrUtils ) 

+ (NSString*) stringWithNewUUID;
- (NSString *)getRegex:(NSString *)pattern;
- (BOOL) checkRegex:(NSString *)pattern;
- (BOOL) checkEmail;
- (BOOL) checkNickname;
- (BOOL) checkPassword;
- (BOOL) checkItunesProductIdentifier;
- (BOOL) checkSubscriptionLoginPassword;

- (NSString *) convertToXMLEntities;
- (NSString *) convertFromXMLEntities;

@end
