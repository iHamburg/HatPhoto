//
//  ViewController.m
//  XappCard
//
//  Created by Xappsoft on 26.11.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import "IHRootViewController.h"
#import "MainViewController.h"
#import "EffectViewController.h"
#import "ShareViewController.h"
#import "InfoTableViewController.h"



@implementation IHRootViewController

@synthesize r,containerSize,containerRect;

@synthesize imgPicker,hatName;

//@synthesize firstVersion,lastVersion,thisVersion,isFirstOpen,isUpdateOpen;

//CGFloat _hAdBanner;

#pragma mark - View lifecycle
//+(id)sharedInstance{
//	static id sharedInstance;
//	if (sharedInstance == nil) {
//
//		sharedInstance = [[IHRootViewController alloc]init];
//		
//	}
//	
//	return sharedInstance;
//	
//}

- (void)loadView{
//	L();
	
//	NSLog(@"paid version # %d",isPaid());
//	
//	r = [UIScreen mainScreen].bounds;
//	w = r.size.width;
//	h = r.size.height;
//	
//	_r =  [UIScreen mainScreen].bounds;
//    _w = _r.size.width;
//    _h = _r.size.height;
//	
//	self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, w, h)];

    [super loadView];
    
//	[self checkVersion];
	
	containerRect = CGRectMake(0, 0, _w, _h-44); // 带Navibar


	self.view.backgroundColor = [UIColor blackColor];
	
	_mainVC = [[MainViewController alloc]init];
	_mainVC.view.alpha = 1;

	nav = [[UINavigationController alloc]initWithRootViewController:_mainVC];
	nav.view.frame = CGRectMake(0, 0, _w, _h);


	if (kVersion < 7.0) {
        [nav.navigationBar setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor colorWithWhite:0.95 alpha:1],UITextAttributeTextColor,
          [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],UITextAttributeTextShadowColor,
          [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],UITextAttributeTextShadowOffset,
          [UIFont fontWithName:@"Archive" size:0.0],UITextAttributeFont,
          nil]];
        
        [nav.navigationBar setTintColor:kBlueColor];
    
    }
	
	
	[self.view addSubview:nav.view];
	
	
	
	imgPicker = [[UIImagePickerController alloc] init];
	imgPicker.delegate = self;
	imgPicker.allowsEditing = NO;
	imgPicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	
	//abc
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleNotificationResignActive:)
												 name:UIApplicationWillResignActiveNotification
											   object: [UIApplication sharedApplication]];
	
	
	//提前load
	_effectVC = [[EffectViewController alloc]init];
	_effectVC.view.alpha = 1;


}

- (void)handleAppFirstTimeOpen{
    [self toInstruction];
}

// 如果是iphone中调用了presentModalVC的话，viewdidAppear还是会不停出现的！！
- (void)viewDidAppear:(BOOL)animated{
//	L();
	[super viewDidAppear:animated];
//
//	if (firstLoadFlag) {
//		firstLoadFlag = NO;
//	}
	
    NSLog(@"root view # %@",self.view.subviews);
	[self test];

//	NSLog(@"root # %@,imgPicker # %@",self,imgPicker);

}

//
//- (void)checkVersion{
//	
//	
//	firstVersion = [[NSUserDefaults standardUserDefaults]floatForKey:kFirstVersionKey];
//	lastVersion = [[NSUserDefaults standardUserDefaults]floatForKey:kLastVersionKey];
//	thisVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] floatValue];
//	
//	if (firstVersion == 0.0) { // 第一次安装app
//		isFirstOpen = YES;
//		
//		firstVersion =  [[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey] floatValue];
//		[[NSUserDefaults standardUserDefaults]setFloat:firstVersion forKey:kFirstVersionKey];
//		
//		lastVersion = firstVersion;
//		[[NSUserDefaults standardUserDefaults]setFloat:lastVersion forKey:kLastVersionKey];
//		
//	}
//	else{ // 已经安装过app，再次打开
//		if (thisVersion != lastVersion) {
//			isUpdateOpen = YES;
//		}
//		
//		[[NSUserDefaults standardUserDefaults]setFloat:thisVersion forKey:kLastVersionKey];
//	}
//	
//	
//}
//
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//
//	return UIInterfaceOrientationPortrait;
//    
//}
//
//- (NSUInteger)supportedInterfaceOrientations{
//	//	L();
//	return UIInterfaceOrientationMaskPortrait;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
	// Release any cached data, images, etc that aren't in use.


}

///**
// 
// 当切换当前card的时候调用
// */
//
//
///**
// 这个是在所有的cover，contentVC都完成后才调用的
// */
//- (void)preLoad{
//
//	if (isFirstOpen) {
//
//
//		
//		[self toInstruction];
//	}
//	else if(isUpdateOpen){
//		
////		if (thisVersion == isPaid()?2.5:1.2) {
////	
////		}
//	}
//	else{
//		
//	}
//
//
//}





#pragma mark - Navigation

- (void)toMainVC{
	if (!_mainVC) {
		_mainVC = [[MainViewController alloc]init];
		_mainVC.view.alpha = 1;
	}
	
	
}

- (void)toEffectVCWithImage:(UIImage*)pictureImg{
	L();

	
	if (!_effectVC) {
		_effectVC = [[EffectViewController alloc]init];
		_effectVC.view.alpha = 1;
	}
	
	_effectVC.img = pictureImg;
	
	hatName = _mainVC.hatName;

	[nav pushViewController:_effectVC animated:YES];
}

- (void)toShareVCWithImage:(UIImage*)img{


	
	if (!_shareVC) {
		_shareVC = [[ShareViewController alloc]init];
		_shareVC.view.alpha = 1;
	}
    
    _shareVC.img = img;
	
	[nav pushViewController:_shareVC animated:YES];
}

//- (void)shareToMain{
//	
//}

- (void)toInstruction{
	
	if (!_instructionVC) {
		_instructionVC = [[InstructionViewController alloc]init];
		_instructionVC.view.alpha = 1;
		_instructionVC.delegate = self;
	}
	
	[self.view addSubview:_instructionVC.view];
	
}

- (void)closeInstruction:(InstructionViewController *)vc{
	
	[_instructionVC.view removeFromSuperview];
}

- (void)toInfo{



	if (!infoVC) {
		infoVC = [[InfoTableViewController alloc]initWithStyle:UITableViewStyleGrouped];
		infoVC.view.frame = containerRect;
	}

	[nav pushViewController:infoVC animated:YES];
}

- (void)closeInfo{
	
	
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
	
    [infoVC.view removeFromSuperview];
	
    [UIView commitAnimations];

}

#pragma mark -

- (void)didTakePicture:(UIImage*)pictureImg{
	L();

	
	UIImage *imgFromMainVC = [_mainVC imageWithPhotoImage:pictureImg];
	
	[[LoadingView sharedLoadingView]removeView];
	
	[self toEffectVCWithImage:imgFromMainVC];
}



- (void)handleNotificationResignActive: (NSNotification*)notification{
	L();

}



#pragma mark - IAP


- (void)IAPDidFinished:(NSString*)identifier{
	

	
	// ads

    [AdView releaseSharedInstance];

	
	// hat
	[_mainVC applyCategory];
	
}
- (void)IAPDidRestored{

	
	// ads

//	[self initBanner];
    [AdView releaseSharedInstance];	
	
	// hat
	[_mainVC applyCategory];
}




#pragma mark -

- (void)test{

//	[[ExportController sharedInstance]showRateAlert];
    
//    [self toEffectVCWithImage:[UIImage imageNamed:@"placeholder.jpg"]];
	
}


@end
