//
//  ViewController.h
//  XappCard
//
//  Created by Xappsoft on 26.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRootViewController.h"
#import "AdView.h"
#import "InstructionViewController.h"


#define kFirstVersionKey @"firstVersionKey"
#define kLastVersionKey @"lastVersionKey"


typedef enum {
	SceneMain,
	SceneEffect,
	SceneShare
}Scene;


extern CGFloat _hAdBanner;


@class MainViewController;
@class EffectViewController;
@class ShareViewController;
@class InfoTableViewController;


@interface IHRootViewController : UIViewController< UIImagePickerControllerDelegate,
UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,InstructionDelegate>{

	UIImagePickerController *imgPicker;

	
	UINavigationController *nav;
	MainViewController *_mainVC;
	EffectViewController *_effectVC;
	ShareViewController *_shareVC;
	InstructionViewController *_instructionVC;
	InfoTableViewController *infoVC;
	
	AdView *_adContainer;
	
	
	CGRect containerRect,containerWithBannerRect;

	CGFloat w,h;
	
	BOOL firstLoadFlag;
	
}


@property (nonatomic, strong) UIImagePickerController *imgPicker;


@property (nonatomic, assign) CGRect r; //全屏size
@property (nonatomic, assign) CGRect containerRect; // 带navibar的rect
@property (nonatomic, assign) CGSize containerSize;

@property (nonatomic, assign) BOOL isFirstOpen,isUpdateOpen;
@property (nonatomic, assign) float firstVersion, lastVersion, thisVersion; // lastVersion 只用来判断是否update！

@property (nonatomic, strong) NSString *hatName;

+(id)sharedInstance;

- (void)checkVersion;
- (void)preLoad;


- (void)toEffectVCWithImage:(UIImage*)pictureImg;
- (void)toShareVCWithImage:(UIImage*)img;
//- (void)shareToMain;

- (void)toInstruction;
- (void)toInfo;
- (void)closeInfo;


- (void)didTakePicture:(UIImage*)pictureImg;

- (void)IAPDidFinished:(NSString*)identifier;
- (void)IAPDidRestored;

- (void)test;

@end
