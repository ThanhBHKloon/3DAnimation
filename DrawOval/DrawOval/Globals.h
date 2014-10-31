//
//  Globals.h
//  publisher
//
//  Created by Thomas Binzinger on 26.09.10.
//  Copyright 2010 area851 LLC. All rights reserved.
//
//  Globals is implemented as a singleton, see:
//  http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html
//  Listing 2-15  Strict implementation of a singleton


#import <Foundation/Foundation.h>

// ------------------ server configurations (api, s3 bucket and file server) --------------------


// telekom-bmp configuration:
#if defined(TARGET_PPtelekombmp1)
    #if defined(LOCAL_TEST)
//        #define SERVER_API              @"http://127.0.0.1:3000"
//        #define SERVER_UPLOAD_PREFIX    @"http://127.0.0.1:8888/upload_files"
//        #define SERVER_S3_FILE_BUCKET   @""
//        #define SERVER_FILES            @"http://127.0.0.1:8888"
//        #define SERVER_API              @"http://10.31.56.197:3000"
//        #define SERVER_UPLOAD_PREFIX    @"http://10.31.56.199/download/upload_files"
//        #define SERVER_S3_FILE_BUCKET   @""
//        #define SERVER_FILES            @"http://10.31.56.199/download"
//        #define SERVER_API              @"https://evening-light-26.heroku.com" // old api
        #define SERVER_API              @"https://api.padcloud.com"   // new api
        #define SERVER_UPLOAD_PREFIX    @"padpublisher.area851.com"
        #define SERVER_S3_FILE_BUCKET   @"padpublisher.area851.com"
        #define SERVER_FILES            @"http://padpublisher.area851.com.s3.amazonaws.com"
    #else
// this are the final values for the production telekombmp1 server:
// they are received by redirect after checking the redirect of the my.padcloud.com
//        #define SERVER_API              @"https://www.padcloud.apg.app.telekomcloud.com/api"
//        #define SERVER_UPLOAD_PREFIX    @"https://www.padcloud.apg.app.telekomcloud.com/download/upload_files"
//        #define SERVER_S3_FILE_BUCKET   @""
//        #define SERVER_FILES            @"https://www.padcloud.apg.app.telekomcloud.com/download"
// this are the values for the default padcloud server; the server will answer with a redirect
// to the values above
//        #define SERVER_API              @"https://evening-light-26.heroku.com" // old api
        #define SERVER_API              @"https://api.padcloud.com"   // new api
        #define SERVER_UPLOAD_PREFIX    @"padpublisher.area851.com"
        #define SERVER_S3_FILE_BUCKET   @"padpublisher.area851.com"
        #define SERVER_FILES            @"http://padpublisher.area851.com.s3.amazonaws.com"
    #endif
#endif

// ingenidoc configuration:
#if defined(TARGET_PPingenidoc) || defined(TARGET_PPfrefc) || defined(TARGET_PPfrfunalbum)
    #if defined(LOCAL_TEST)
//        #define SERVER_API              @"http://127.0.0.1:3000"
//        #define SERVER_UPLOAD_PREFIX    @"http://127.0.0.1:8888/upload_files"
//        #define SERVER_S3_FILE_BUCKET   @""
//        #define SERVER_FILES            @"http://127.0.0.1:8888"
        #define SERVER_API              @"https://padcloud.ingenidoc.fr/api"
        #define SERVER_UPLOAD_PREFIX    @"https://padcloud.ingenidoc.fr/download/upload_files"
        #define SERVER_S3_FILE_BUCKET   @""
        #define SERVER_FILES            @"https://padcloud.ingenidoc.fr/download"
    #else
        #define SERVER_API              @"https://padcloud.ingenidoc.fr/api"
        #define SERVER_UPLOAD_PREFIX    @"https://padcloud.ingenidoc.fr/download/upload_files"
        #define SERVER_S3_FILE_BUCKET   @""
        #define SERVER_FILES            @"https://padcloud.ingenidoc.fr/download"
    #endif
#endif

// azure configuration:
#if defined(TARGET_PPPadCloudAzure) || defined(TARGET_PPPresentationsAzure)
    #if defined(LOCAL_TEST)
        // test-api1:
        #define SERVER_API              @"http://test-api1.padcloud.com"
        //#define SERVER_API              @"http://127.0.0.1:3000"
        //#define SERVER_API              @"http://192.168.1.104:3000"
        #define SERVER_UPLOAD_PREFIX    @"testapi1.padcloud.com"
        #define SERVER_S3_FILE_BUCKET   @"testapi1.padcloud.com"
        #define SERVER_FILES            @"http://testapi1.padcloud.com.s3.amazonaws.com"
    #else
        #define SERVER_API              @"http://azure-api.padcloud.com/api"
        #define SERVER_UPLOAD_PREFIX    @"http://azure-api.padcloud.com/api/download/upload_files"
        #define SERVER_S3_FILE_BUCKET   @""
        #define SERVER_FILES            @"http://azure-api.padcloud.com/api/download"
    #endif
#endif

// default configuration:
#if !defined(SERVER_API)
    #if defined(LOCAL_TEST)
        // test-api1:
        #define SERVER_API              @"http://test-api1.padcloud.com"
        //#define SERVER_API              @"http://127.0.0.1:3000"
        //#define SERVER_API              @"http://192.168.1.104:3000"
        #define SERVER_UPLOAD_PREFIX    @"testapi1.padcloud.com"
        #define SERVER_S3_FILE_BUCKET   @"testapi1.padcloud.com"
        #define SERVER_FILES            @"http://testapi1.padcloud.com.s3.amazonaws.com"
    #else
        // test-api1:
        #define SERVER_API              @"http://test-api1.padcloud.com"
        #define SERVER_UPLOAD_PREFIX    @"testapi1.padcloud.com"
        #define SERVER_S3_FILE_BUCKET   @"testapi1.padcloud.com"
        #define SERVER_FILES            @"http://testapi1.padcloud.com.s3.amazonaws.com"
//        #define SHOW_SERVER_URL         // if we use test1 server, we will need to show the server url in imprint to avoid mistake when submission

        // production server:
        //#define SERVER_API              @"https://evening-light-26.heroku.com" // old api
//        #define SERVER_API              @"https://api.padcloud.com"   // new api
//        #define SERVER_UPLOAD_PREFIX    @"padpublisher.area851.com"
//        #define SERVER_S3_FILE_BUCKET   @"padpublisher.area851.com"
//        #define SERVER_FILES            @"http://padpublisher.area851.com.s3.amazonaws.com"

        // server with 307 redirect
//        #define SERVER_API              @"http://hollow-day-7104.heroku.com"
//        #define SERVER_UPLOAD_PREFIX    @"testapi1.padcloud.com"
//        #define SERVER_S3_FILE_BUCKET   @"testapi1.padcloud.com"
//        #define SERVER_FILES            @"http://testapi1.padcloud.com.s3.amazonaws.com"

    #endif
#endif

// ------------------ end server configurations (api, s3 bucket and file server) ----------------

typedef enum {
    AnimationModeCurl2D,
    AnimationModeSlide
} PageAnimationMode;

typedef enum {
	S3KeyTypeRead,
	S3KeyTypeWrite,
} S3KeyType;

static NSString *kNotification_IssueListUpdated = @"issueListUpdated";
static NSString *kNotification_FileItemsQueueComplete = @"fileItemsQueueComplete";	// posted when the fileItems download queue is finished
static NSString *kNotification_FileItemComplete = @"fileItemQueueComplete";			// posted when the fileItems download queue is finished
static NSString *kNotification_AppWillEnterForeground = @"appDidBecomeActive";		// posted when the application becomes active (also after start)
static NSString *kNotification_AppWillResignActive=@"appWillResignActive";			// postet when app resigns active 
static NSString *kNotification_DidReceiveRemoteNotification=@"didReceiveRemoteNotification";			// postet when receiving a push notification
static NSString *kNotification_DidReceiveRemoteNewsstandContenNotification=@"didReceiveRemoteNewsstandContenNotification";			// posted when new content is available for newsstand
static NSString *kNotification_DidReceiveRemotePadcloudContenNotification=@"didReceiveRemotepadcloudContenNotification";			// posted when new content is available for padcloud
static NSString *kNotification_NewsstandDownloadNewContent=@"newsstandDownloadNewContent";			// posted after start if the app was startet with newsstand payload

#if defined(DEVMODE_INCLUDED)
static NSString *kNotification_DevModeEnabled=@"dmEnabled";							// posted if developer mode get enabled
#endif
static NSString *kNotification_RefreshCoverInterface = @"refreshCoverInterface";    // posted if the title cover display should be refreshed
static NSString *kNotification_CurrentOpenIssueWasRemoved = @"currentOpenIssueWasRemoved";    // posted if the current open issue was removed by the issuelistupdater
static NSString *kNotification_CurrentOpenIssueWasChanged = @"currentOpenIssueWasChanged";    // posted if the current open issue has a different timestamp than the one on the server
static NSString *kNotification_CurrentOpenIssueWasChangedTapArea = @"currentOpenIssueChangeTapArea";    // posted if the current open issue has a different timestamp than the one on the server
static NSString *kNotification_CurrentOpenIssueWasChangedContent = @"currentOpenIssueChangeContentTable";    // posted if the current open issue has a different timestamp than the one on the server
static NSString *kNotification_IssueExitRegions = @"issuesExitRegions";    // posted if one or more issues exit it's geo fencing then reload cover flow

static NSString *kNotification_DeletedExpiredIssue = @"deletedExpiredIssue";
static NSString *kNotification_CloseDisplayingIssue = @"closeDisplayingIssue";
static NSString *kNotification_ShouldDismissDevPanel = @"shouldDismissDevPanel";
static NSString *kNotification_IssuesHasGeo = @"hasGeoFencing";
static NSString *kNotification_AutoRefreshAfterRegistration = @"autoRefreshAfterRegistration";
static NSString *kNotification_StopDownloadWithRemovedIssue = @"stopDownloadWithRemoveIssue";
static NSString *kNotification_RemoveWaitingScreen = @"removeWaitingScreen"; // when app in leaview, send notifcation to remove waiting screen at titlecoverview
static NSString *kNotification_RemoveIssueFromCoverInfo = @"removeIssueFromCoverInfo"; // after remove issue from issues list, need to remve from coverinfo list as well
static NSString *kNotification_ChangHeadlineUIType = @"changeHeadlineUIType"; // if headline mode change afte getting push from server

@interface Globals : NSObject {
	NSString *resourceDirectory;
	NSString *documentDirectory;
	NSString *imagesDirectory;
	NSString *assetImportDirectory;
    BOOL hardwareSet;
    BOOL hardware_hasRetinaDisplay;
    BOOL hardware_has4InchDisplay;
    BOOL hardware_runningOnIPad;
    NSString *hardware_platform;
}

@property (readonly) NSString *resourceDirectory;
@property (readonly) NSString *documentDirectory;
@property (readonly) NSString *imagesDirectory;
@property (readonly) NSString *assetImportDirectory;

@property (nonatomic, assign) BOOL serverRedirectChecked;

@property (nonatomic, retain) NSString *serverAPI;
@property (nonatomic, retain) NSString *serverUploadPrefix;
@property (nonatomic, retain) NSString *serverS3FileBucket;
@property (nonatomic, retain) NSString *serverFiles;

@property (readonly) NSString *serverIssueListURL;				// request for XML list of available issues
@property (readonly) NSString *serverIssueFilesListURL;			// request for XML list of files for a specific issue
@property (readonly) NSString *serverHeadlineListURL;           // request for XML list of available headlines
@property (readonly) NSString *serverFeedListURL;               // request of JSON list of available feeds
#if defined (ITUNES_SUBSCRIPTIONS_PURCHASE)
@property (readonly) NSString *serverReceiptNotificationURL;    // request to send a receipt (for a purchased newsstand subscription)
#endif
@property (readonly) NSString *serverFileStorageURLPrefix;		// server URL without sub-Paths for downloading files (S3)
@property (readonly) NSString *serverIssueUpdatedNotificationURL;	// url to call after upload of an issue
@property (readonly) NSString *serverCheckIssueExistsURL;		// url to check if issue exists (returns "yes" or "no")
@property (readonly) NSString *serverCheckIssueUpdateAllowedURL; // url to check if device can create/update issue
@property (readonly) NSString *serverVerifyReceiptURL;			// url to send a purchase receipt to

#if defined (NEWSSTAND) || defined (PUSH_NOTIFICATIONS)
@property (readonly) NSString *serverRegisterAPNSToken;         // url to register APNS tokens with the server
#endif

@property (readonly) NSString *serverRegisterAPNSTokenAndGetConfig; // url to register APNS tokens with the server and get client config

-(NSString *)serverGetSubscriberStatusURL;

@property (readonly) NSString *serverPUTLogEventURL;             // url to send client logging events to the server

#if defined(DEVMODE_INCLUDED)
@property (readonly) NSString *serverDevEnabledURL;				// url to ask if this device is enabled for development
#endif

-(NSString *)subcriptionLoginCheckURL;                          // url to get a message for subscription login/password

-(NSString *)subscriberDeregistrationCheckURL;                  // url to check whether subscriber can deregistration or not
-(NSString *)subscriberDeregistrateURL;                         // url de-registration a subscriber

@property (readonly) NSString *serverReadKeysURL;				// url to request the S3 keys
#if defined(DEVMODE_UPLOAD_INCLUDED)
@property (readonly) NSString *serverWriteKeysURL;				
#endif

@property (assign) BOOL S3ReadKeysFetched;						// keys downloaded? use fetchS3Keys  to populate keys
@property (nonatomic, retain) NSString *serverReadAccessKey;				// s3 access key for reading files
@property (nonatomic, retain) NSString *serverReadSecretAccessKey;		// s3 secret access key for reading files
#if defined(DEVMODE_UPLOAD_INCLUDED)
@property (assign) BOOL S3WriteKeysFetched;
@property (nonatomic, retain) NSString *serverWriteAccessKey;			// s3 access key for writing files (developer mode)
@property (nonatomic, retain) NSString *serverWriteSecretAccessKey;		// s3 secret access key for writing files (developer mode)
@property (readonly) NSString *serverS3UploadBucket;
#endif
@property (readonly) NSString *serverS3DownloadBucket;

@property (readonly) NSString *clientVersion;

@property (nonatomic, assign) NSUInteger settingsAnimationspeed;
@property (nonatomic, assign) PageAnimationMode settingsPageAnimationMode;

// properties for saving the application state:
@property (nonatomic, retain) NSString *appState_idOfOpenIssue;		// issue id if the last app-state was an open issue, otherwise nil for title
@property (nonatomic, retain) NSString *appState_idOfLastClosedIssue;		// issue id of the last closed issue, nil when a document is opened
@property (nonatomic, assign) NSUInteger appState_issuePageNumber;		// pageNumber within issue
@property (nonatomic, retain) NSString *appState_idOfSelectedCover;	// selected issue in the title
@property (nonatomic, retain) NSString *appState_subscriptionLogin;	// login for ubscriptions
@property (nonatomic, retain) NSString *appState_subscriptionPassword;	// password for subscriptions

@property (nonatomic, retain) NSString *appState_clientAccessToken;     // padcloud client access token
@property (nonatomic, assign) NSUInteger appState_currentHeadlineID;    // id for current headline selected
@property (nonatomic, assign) NSUInteger appState_headlineMode;    // =0: tripes mode, =1: thumbnail mode

#if defined(DEVMODE_INCLUDED)
@property (nonatomic, assign) BOOL appState_devModeEnabled;             // is this device enabled for development?
@property (nonatomic, assign) BOOL appState_hidePreviewIssuesInTitle;   // hide preview issues in coverview? (default:no; applies only to dev mode; in non-dev, preview issues are always hidden!)
#endif

@property (nonatomic, assign) BOOL appState_lockScreenRegistrationFinished;             // has the user finished the subscriber registration process?

@property (assign) BOOL onlineIssueListCheckDone;				// request send to server for issue list update?

@property (nonatomic, retain) NSString *uploadPassword;				// just so the user does not need to type it in each time (not saved betwenn app-starts)

@property (readonly) BOOL runningOniPad;
@property (readonly) BOOL hasRetinaDisplay;
@property (readonly) BOOL hasRetinaHDDisplay;
@property (readonly) BOOL has4InchDisplay;
@property (readonly) NSString *hardwarePlatform;
@property (nonatomic, retain) NSDictionary *socialSetup;

#if defined (NEWSSTAND_NKDOWNLOAD)
@property (nonatomic, retain) NSString *newsstandLastDownloadedIssueID;
#endif

@property (nonatomic, assign) BOOL appState_helpNotificationHidden;
@property(nonatomic, assign) BOOL isOpenHTMLFromLeaves;

+ (Globals*)sharedManager;

- (void) initializeGlobalPaths;
- (BOOL)fetchS3Keys:(S3KeyType)type withPublicationID:(NSString *)publicationID andPassword:(NSString *)password;
#if defined(DEVMODE_INCLUDED)
- (BOOL)checkDevEnabledForPublication:(NSString *)publicationID returnText:(NSString **)userText;
#endif

- (BOOL) getServerInfoForSubscriptionLogin:(NSString *)login andPassword:(NSString *)password andPublication:(NSString *)publicationID returnText:(NSString **)userText returnURL:(NSString **)userURL clientAccessToken:(NSString **)clientAcccessToken;
- (NSString *) currentSubscriptionLoginString;
- (BOOL) doSubscriberLoginForLogin:(NSString *)login andPassword:(NSString *)password andPublicationID:(NSString *)publicationID resultMessage:(NSString **)message resultURL:(NSString **)urlToOpen;

- (NSString *) socialSetupForKey:(NSString *)key;

- (void)downloadFileFromURL:(NSString *)url toFile:(NSString *)filename inDirectory:(NSString *)directory redownload:(BOOL)redownload;

- (NSString *) resourceImageNameWithTitle:(NSString *)title isPortrait:(BOOL)portrait;
- (NSString *) resourceImageFileNameWithTitle:(NSString *)title extension:(NSString *)fileExtension isPortrait:(BOOL)portrait ;
- (NSString *) resourceImagePathWithTitle:(NSString *)title extension:(NSString *)fileExtension isPortrait:(BOOL)portrait;


//- (NSString *) newImageResourcePathForFile:(NSString *)fileName extension:(NSString *)fileExtension portrait:(BOOL)portrait retinaDisplay:(BOOL)retinaDisplay;
//- (NSString *) newImageResourceNameForFile:(NSString *)fileName extension:(NSString *)fileExtension portrait:(BOOL)portrait retinaDisplay:(BOOL)retinaDisplay;

- (BOOL) retinaGraphicsFilesAvailable;

#if defined(SERVER_REDIRECT_ENABLED)
- (NSString *)serverRedirectCheckURL;
- (BOOL)checkServerRedirectForPublicationID:(NSString *)publicationID;
#endif

- (BOOL) setFileProtectionForFile:(NSString *)filename;

-(void) setAppState_subscriberDeregistrationAllowed:(BOOL)value;
-(BOOL) appState_subscriberDeregistrationAllowed;

-(void) setAppState_clientEventlogWaitMin:(int)value;
-(int) appState_clientEventlogWaitMin;

-(void) setAppState_clientEventlogWaitCount:(int)value;
-(int) appState_clientEventlogWaitCount;

-(void) setAppState_clientEventlogGeoEnabled:(BOOL)value;
-(BOOL) appState_clientEventlogGeoEnabled;

@end
