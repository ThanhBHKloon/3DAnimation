//
//  Globals.m
//  publisher
//
//  Created by Thomas Binzinger on 26.09.10.
//  Copyright 2010 area851 LLC. All rights reserved.
//
//  Globals is implemented as a singleton, see:
//  http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//  Listing 2-15  Strict implementation of a singleton

#import "Globals.h"
#import "UIDeviceHardware.h"
#include <sys/xattr.h>
#import "UIDevice+IdentifierAddition.h"
#import "NSString+StrUtils.h"

static Globals *sharedGlobalsManager = nil;

@implementation Globals

@synthesize resourceDirectory;
@synthesize documentDirectory;
@synthesize imagesDirectory;
@synthesize assetImportDirectory;

@synthesize serverRedirectChecked;

@synthesize serverAPI;
@synthesize serverUploadPrefix;
@synthesize serverS3FileBucket;
@synthesize serverFiles;

@dynamic    serverIssueListURL;
@dynamic    serverIssueFilesListURL;
@dynamic    serverHeadlineListURL;
@dynamic    serverFeedListURL;
#if defined (ITUNES_SUBSCRIPTIONS_PURCHASE)
@dynamic    serverReceiptNotificationURL;
#endif
@dynamic	serverFileStorageURLPrefix;
@dynamic	serverIssueUpdatedNotificationURL;
@dynamic	serverCheckIssueExistsURL;
@dynamic	serverCheckIssueUpdateAllowedURL;
@dynamic	serverVerifyReceiptURL;
@dynamic    clientVersion;
@synthesize onlineIssueListCheckDone;

@synthesize S3ReadKeysFetched;
@synthesize serverReadAccessKey;			//available after successfull fetchS3Keys
@synthesize serverReadSecretAccessKey;		
#if defined(DEVMODE_UPLOAD_INCLUDED)
@synthesize S3WriteKeysFetched;
@synthesize serverWriteAccessKey;			
@synthesize serverWriteSecretAccessKey;		
#endif

@dynamic serverPUTLogEventURL;

@dynamic appState_idOfOpenIssue;	
@dynamic appState_issuePageNumber;
@dynamic appState_idOfSelectedCover;
@dynamic appState_subscriptionLogin;
@dynamic appState_subscriptionPassword;
@dynamic appState_clientAccessToken;

#if defined(DEVMODE_INCLUDED)
@dynamic appState_devModeEnabled;
@dynamic appState_hidePreviewIssuesInTitle;
#endif

@dynamic appState_lockScreenRegistrationFinished;

@synthesize uploadPassword;

@dynamic runningOniPad;
@dynamic hasRetinaDisplay;
@dynamic has4InchDisplay;
@dynamic hardwarePlatform;

@synthesize socialSetup;

#if defined (NEWSSTAND_NKDOWNLOAD)
@synthesize newsstandLastDownloadedIssueID;
#endif

@synthesize appState_helpNotificationHidden = _appState_helpNotificationHidden;
@synthesize  isOpenHTMLFromLeaves;
@synthesize appState_currentHeadlineID;
@synthesize appState_headlineMode;

+ (Globals*)sharedManager
{
    if (sharedGlobalsManager == nil) {
        sharedGlobalsManager = [[super allocWithZone:NULL] init];
    }
    return sharedGlobalsManager;
}



-(id)init
{
    self = [super init];
    if(self != nil)
    {
		[self initializeGlobalPaths];
		self.S3ReadKeysFetched=NO;
#if defined(DEVMODE_UPLOAD_INCLUDED)
		self.S3WriteKeysFetched=NO;
#endif
		self.uploadPassword=@"";
        self.socialSetup=nil;
        self.serverRedirectChecked=NO;
        self.serverAPI = SERVER_API;
        self.serverUploadPrefix = SERVER_UPLOAD_PREFIX;
        self.serverS3FileBucket = SERVER_S3_FILE_BUCKET;
        self.serverFiles = SERVER_FILES;
        hardwareSet = NO;
        _appState_helpNotificationHidden = [[NSUserDefaults standardUserDefaults] objectForKey:@"noHelpNotif"];
    }
    isOpenHTMLFromLeaves = NO;
    return self;
}



#pragma mark -
#pragma mark hardware checks

// read the paramters once, then on subsequent calls return the cached parameters:
- (void) getHardwareParameters {
    UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
    hardware_runningOnIPad = [h isIPad];
    hardware_hasRetinaDisplay = [h hasRetinaDisplay];
    hardware_has4InchDisplay = [h has4InchDisplay];
    hardware_platform = [h platform];
    hardwareSet=YES;
}

//check if app is running on iPad (opposed to iphone/ipod touch)
- (BOOL) runningOniPad {
    if (!hardwareSet)
        [self getHardwareParameters];
    return(hardware_runningOnIPad);
}

// check if the device has a retina display
- (BOOL) hasRetinaDisplay {
    if (!hardwareSet)
        [self getHardwareParameters];
    return (hardware_hasRetinaDisplay);
}

- (BOOL) hasRetinaHDDisplay {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 3.0)) {
        return(YES);
    } else {
        return(NO);
    }
}

// check if the device has a 4 inch display (iphone5)
- (BOOL) has4InchDisplay {
    if (!hardwareSet)
        [self getHardwareParameters];
    return (hardware_has4InchDisplay);
}

// return the platform string (like "iPad3,3")
- (NSString *) hardwarePlatform {
    if (!hardwareSet)
        [self getHardwareParameters];
    return (hardware_platform);
}

#pragma mark -


@end

