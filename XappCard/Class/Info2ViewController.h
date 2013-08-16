//
//  Info2ViewController.h
//  InstaMagazine
//
//  Created by AppDevelopper on 13.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "InstructionViewController.h"
#import "RootViewController.h"

@interface Info2ViewController : UIViewController<InstructionDelegate>{


	InstructionViewController *instructionVC;
	
	UIButton *backB,*aboutB,*recommendB,*supportB,*facebookB,*twitterB, *downloadB, *instructionB;
	UIButton *myecardB,*tinyKitchenB,*ncsB, *firstAppB;
	UIImageView *binder, *ribbon,*featureV;
	UIScrollView *scrollView;
	UILabel *otherAppL;
	UITextView *textV;

	NSMutableArray *moreApps;
	
	int selectedIndex;
	CGFloat width,height;
}

@property (nonatomic, unsafe_unretained) RootViewController *root;

- (void)back;
- (void)aboutus;
- (void)tweetus;
- (void)facebook;
- (void)email;
- (void)supportEmail;


@end
