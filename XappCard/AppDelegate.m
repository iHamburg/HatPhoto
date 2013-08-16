//
//  AppDelegate.m
//  XappCard
//
//  Created by Xappsoft on 26.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "RootViewController.h"
#import "FlurryAnalytics.h"
#import "Controller.h"
#import "FacebookManager.h"
#import "CPMotionRecognizingWindow.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize facebook;

//static NSString *FLURRYPAIDKEY = @"RBR3HBMVH2Q5WWRBGFD6";

static NSString *FLURRYFREEKEY = @"Q6F2JCSBVD9SXFZWC8GK";
static NSString *ADMOBKEY = @"a1510e68ad9c726";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	NSLog(@"applicaiton did lauch");
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	
// 如果不是debug， startsesseion

#ifndef DEBUG
//	NSString *flurryKey;
//	if (isPaid()) {
//		flurryKey = FLURRYPAIDKEY;
//	}
//	else{
//		flurryKey = FLURRYFREEKEY;
//	}

	[FlurryAnalytics startSession:FLURRYFREEKEY];  // 如果不是测试版本，激活flurry
	
#endif
	
	NSString *facebookSuffix = isPaid()?@"paid":@"free";
	
	NSLog(@"suffix:%@",facebookSuffix);
	
	facebook = [[Facebook alloc] initWithAppId:FBAppID 
							   urlSchemeSuffix:facebookSuffix
								   andDelegate:[FacebookManager sharedInstance]];


	
	
#if TARGET_IPHONE_SIMULATOR
	//  NSString *hello = @"Hello, iPhone simulator!";
    ;
#elif TARGET_OS_IPHONE
	// NSString *hello = @"Hello, device!";
//	[NSThread sleepForTimeInterval:2];
#else
	// NSString *hello = @"Hello, unknown target!";
    ;
#endif
	
	[self customizeAppearance];

	self.window = [[CPMotionRecognizingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


//	NSLog(@"window # %@",self.window);
	
	self.viewController = [RootViewController sharedInstance];


    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

	NSLog(@"IS shakeHat # %d",isShakeHat());

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
//	L();
//	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
//
//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//	L();
//
//	application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber-1;
//
//	[self.viewController handleRemindNotification:notification];
//    
//
//}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
	 return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight; 
}
#pragma mark - Error Handlung
void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}


#pragma mark - Facebook
// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	NSLog(@"handleOpenURL");
    return [facebook handleOpenURL:url]; 
}

// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	NSLog(@"hanlde openurl");
    return [facebook handleOpenURL:url]; 
}


#pragma mark - UI Apperance
- (void)customizeAppearance{

	NSDictionary *barButtonTextAttributes = @{
UITextAttributeFont:  [UIFont fontWithName:@"Archive" size:0.0],
UITextAttributeTextColor: [UIColor colorWithWhite:0.95 alpha:1],
UITextAttributeTextShadowColor: [UIColor colorWithWhite:0.0f alpha:0.2f],
UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]
	};
	
	[[UIBarButtonItem appearance] setTitleTextAttributes:barButtonTextAttributes
												forState:UIControlStateNormal];
	[[UIBarButtonItem appearance] setTitleTextAttributes:barButtonTextAttributes
												forState:UIControlStateHighlighted];
	[[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0f, 0.5f)
											   forBarMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-0.5f, 2.0f)
														 forBarMetrics:UIBarMetricsDefault];
	[[UIBarButtonItem appearance]setTintColor:kLightBlueColor];
	
}


@end
