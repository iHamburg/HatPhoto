//
//  MyStoreObserver.h
//  SignatureN
//
//  Created by fanshao on 09-9-1.
//  Copyright 2009 Sensky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "Utilities.h"
#import "LoadingView.h"

/*
 多个iap
 kIAPfullverion,
 kIAPHalloween
 
 
 alert:
 一种是buy，restore一起的alert，
 另一种是只有buy的alert
 
 */


@protocol IAPDelegate;

@interface MyStoreObserver : NSObject< SKPaymentTransactionObserver,SKProductsRequestDelegate,UIAlertViewDelegate>{
	
	NSString *identifier;
	
	UIAlertView  *fullVersionAlert;

}


@property (nonatomic, unsafe_unretained) id<IAPDelegate>delegate;


+ (id)sharedInstance;


- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;


//public
- (void) checkRestoredItemsWithDelegate:(id<IAPDelegate>)delegate;   // restore
- (void) requestProductWithIdendifier:(NSString*)iden delegate:(id<IAPDelegate>)delegate; //buy

- (void) showFullVersionAlert;

@end


@protocol IAPDelegate <NSObject>

@optional
- (UIView*)viewForLoading;
- (void)didCompleteIAPWithIdentifier:(NSString*)identifier;
@end