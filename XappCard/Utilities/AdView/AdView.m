//
//  AdView.m
//  MyeCard
//
//  Created by AppDevelopper on 02.02.13.
//
//

#import "AdView.h"
#import "Controller.h"
#import "RootViewController.h"

@implementation AdView

@synthesize delegate;

static bool _isIAD = NO;
static bool _iadAvailable = NO;
static float _h, _w;
static NSString *MY_BANNER_UNIT_ID=@"a1510e68ad9c726";
static bool _isGADLoaded = NO;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
		
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleResignActive)
													 name:UIApplicationWillResignActiveNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleBecomeActive)
													 name:UIApplicationDidBecomeActiveNotification
												   object:nil];
		
		_h = frame.size.height;
		_w = frame.size.width;
		
		static NSSet* supportedCountries = nil;
		if (supportedCountries == nil)
		{
			supportedCountries = [NSSet setWithObjects:
								  @"ES", // spain
								  @"US", // usa
								  @"UK", // united kingdom
								  @"CA", // canada
								  @"FR", // france
								  @"DE", // german
								  @"IT", // italy
								  @"JP", // japan
								  nil];
		}
		
		NSLocale* currentLocale = [NSLocale currentLocale];  // get the current locale.
		NSString* countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
		if ([supportedCountries containsObject:countryCode]) {
			_iadAvailable = YES;
		}
		else{
			_iadAvailable = NO;
		}
		
		
		///TODO: 测试admob
#ifdef DEBUG
		_iadAvailable = NO;
#endif
		// 优先调用IAD
		if (_iadAvailable) { // iad
			
			[self setupIAD];
		}
		else{ //gad
			[self setupGAD];
		}
		
		// 开始时hidden，等到载入iad时才显示
		self.hidden = YES;
		
		
    }
    return self;
}


- (void)setupIAD{
	L();
	if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
		_iadView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
		
	}
	else {
		_iadView = [[ADBannerView alloc] init];
	}
	_iadView.delegate = self;
	_iadView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
	
	[self addSubview:_iadView];
	
	_isIAD = YES;
	[_gadView removeFromSuperview];
	_gadView.delegate = nil;
	_gadView = nil;
	
}

- (void)setupGAD{
	L();
	_gadView = [[GADBannerView alloc] initWithFrame:self.bounds];
	
	//设置阴影
	_gadView.layer.shadowOffset = CGSizeMake(5, 3);
	_gadView.layer.shadowOpacity = 0.9;
	_gadView.layer.shadowColor = [UIColor grayColor].CGColor;
	
	_gadView.adUnitID = MY_BANNER_UNIT_ID;
	_gadView.rootViewController = [RootViewController sharedInstance];
	
	_gadView.delegate = self;
	[_gadView loadRequest:[GADRequest request]];
	
	[self addSubview:_gadView];
	
	_isIAD = NO;
	[_iadView removeFromSuperview];
	_iadView.delegate = nil;
	_iadView = nil;
	
}

- (BOOL)bannerLoaded{
	if (_isIAD) {
		return _iadView.bannerLoaded;
	}
	else{
		return _isGADLoaded;
	}
}

//为什么要resign？
- (void)handleResignActive{
	NSLog(@"Adview resign Active # %@",self);
	[delegate layoutBanner:NO];
}

- (void)handleBecomeActive{
	//	L();
	NSLog(@"Adview become Active # %@",self);
	
	[[RootViewController sharedInstance] initBanner];
}
#pragma mark - iAD Banner


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	L();
	
	self.hidden = NO;
	[delegate layoutBanner:YES];
	
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	//	L();
	NSLog(@"error # %@",[error localizedDescription]);
	
	self.hidden= YES;
	
    [delegate layoutBanner:NO];
	
	//iad fail 自动调用 admob
	[self setupGAD];
	
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	
	
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	L();
	
}


#pragma mark - Google Admob Ads
// Sent when an ad request loaded an ad.  This is a good opportunity to add this
// view to the hierarchy if it has not yet been added.  If the ad was received
// as a part of the server-side auto refreshing, you can examine the
// hasAutoRefreshed property of the view.
- (void)adViewDidReceiveAd:(GADBannerView *)view {
	
	L();
	
	_isGADLoaded = YES;
	
	self.hidden = NO;
	[delegate layoutBanner:YES];
	
}

// Sent when an ad request failed.  Normally this is because no network
// connection was available or no ads were available (i.e. no fill).  If the
// error was received as a part of the server-side auto refreshing, you can
// examine the hasAutoRefreshed property of the view.
- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
	
	NSLog(@"GAD error # %@", [error description]);
	
	_isGADLoaded = NO;
	
	self.hidden = YES;
	
	[delegate layoutBanner:NO];
	
	if (_iadAvailable) {
		[self setupIAD];
	}
}

// Sent just before presenting the user a full screen view, such as a browser,
// in response to clicking on an ad.  Use this opportunity to stop animations,
// time sensitive interactions, etc.
//
// Normally the user looks at the ad, dismisses it, and control returns to your
// application by calling adViewDidDismissScreen:.  However if the user hits the
// Home button or clicks on an App Store link your application will end.  On iOS
// 4.0+ the next method called will be applicationWillResignActive: of your
// UIViewController (UIApplicationWillResignActiveNotification).  Immediately
// after that adViewWillLeaveApplication: is called.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    NSLog(@"[GAD]: 即将显示全屏广告.");
}

// Sent just before dismissing a full screen view.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
    NSLog(@"[GAD]: 即将退出全屏广告.");
}

// Sent just after dismissing a full screen view.  Use this opportunity to
// restart anything you may have stopped as part of adViewWillPresentScreen:.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    NSLog(@"[GAD]: 全屏广告已经退出.");
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    NSLog(@"[GAD]: 即将进入广告目标.");
}




@end
