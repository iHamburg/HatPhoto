//
//  MyStoreObserver.m
//  SignatureN
//
//  Created by fanshao on 09-9-1.
//  Copyright 2009 Sensky. All rights reserved.
//

#import "MyStoreObserver.h"
#import "RootViewController.h"

@implementation MyStoreObserver


@synthesize delegate;



+(id)sharedInstance{
	
	static id sharedInstance;
	if (sharedInstance == nil) {
		
		sharedInstance = [[[self class] alloc]init];
	}
	
	return sharedInstance;
	
}

- (id)init{
	if (self = [super init]) {
		[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	
	}
	return self;
}


// buy
- (void) requestProductWithIdendifier:(NSString*)iden delegate:(id<IAPDelegate>)_delegate{

	
	NSLog(@"iap Identifier:%@",iden);
	if (delegate) {
		[[LoadingView sharedLoadingView]addInView:[_delegate viewForLoading]];
		
	}
	else{
		[[LoadingView sharedLoadingView]addInView:[[RootViewController sharedInstance]view]];
	}
	
	SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: iden]];
    
    request.delegate = self;
	[request start];
	delegate = _delegate;
}

// restore all
- (void) checkRestoredItemsWithDelegate:(id<IAPDelegate>)_delegate{

	
	if (delegate) {
		[[LoadingView sharedLoadingView]addInView:[_delegate viewForLoading]];
		
	}
	else{
		[[LoadingView sharedLoadingView]addInView:[[RootViewController sharedInstance]view]];
	}
	
	delegate = _delegate;
	[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}



#pragma mark - IAP Request


/*
 only one iap at a time
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
	
	NSArray *myProduct = response.products;
	NSLog(@"the count of products is %d", [myProduct count]);
	// populate UI

	if (ISEMPTY(myProduct)) {
		[[LoadingView sharedLoadingView]removeView];
		return;
	}

    SKProduct *product = [myProduct objectAtIndex:0];
//	NSLog(@"Product id: %@" , product.productIdentifier);
	
	SKPayment *payment = [SKPayment paymentWithProduct:product];
	
	[[SKPaymentQueue defaultQueue] addPayment:payment];
	
	
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
	[[LoadingView sharedLoadingView] removeView];
	
    NSLog(@"did fail Request,%@",[error localizedDescription]);
	UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"Alert" message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
	
	[alerView show];
}


#pragma mark - Store Response

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	L();
	for (SKPaymentTransaction* transaction in transactions)
	{
		
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				//NSLog(@"Complete Transaction");
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				//   NSLog(@"State Failed");
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				//                NSLog(@"state restored");
				[self restoreTransaction:transaction];
				break;
			default:
				//                NSLog(@"unknown state");
				[[LoadingView sharedLoadingView]removeView];
				break;
		}
	}
	
	
}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
	L();
	NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
	[self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
   	
	[[LoadingView sharedLoadingView] removeView];
	
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    NSString *iden = transaction.payment.productIdentifier;
	NSLog(@"Transaction complete id:%@",iden);
	
	
	[[NSUserDefaults standardUserDefaults]setBool:YES forKey:iden];
	
	[[NSUserDefaults standardUserDefaults]synchronize];
	
	[[RootViewController sharedInstance]IAPDidFinished:iden];
	
}


- (void) restoreTransaction: (SKPaymentTransaction *)transaction{
	L();
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    NSString *iden = transaction.payment.productIdentifier;
	NSLog(@"Transaction restored id:%@",iden);
	
	[[NSUserDefaults standardUserDefaults]setBool:YES forKey:iden];
	
	[[NSUserDefaults standardUserDefaults]synchronize];
	
	//	[delegate didCompleteIAPWithIdentifier:iden];
	
	// 不用remove loadingview，因为之后会调用 paymentQueueRestoreCompletedTransactionsFinished
	
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	//[[NSNotificationCenter defaultCenter] postNotificationName:@"faliedTransaction" object:nil];
    
	L();
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Optionally, display an error here.
        [UIAlertView showAlert:@"Error" msg:@"Transaction failed!" cancel:@"Cancel"];
    }
    
    L();
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
    [[LoadingView sharedLoadingView] removeView];
}



/*
 
 如果有2个iap，是否会调用两次restoreTransaction然后才调用paymentQueueRestoreCompletedTransactionsFinished？
 
 如果处理都在restoreTransaction中完成，paymentQueueRestoreCompletedTransactionsFinished就不用逻辑了
 */


- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
	
	L();
	
	[[LoadingView sharedLoadingView] removeFromSuperview];
	//	purchasedItemIDs = [[NSMutableArray alloc] init];
	
	NSLog(@"received restored transactions: %i", queue.transactions.count);
	
	//只有一个iap
	if (queue.transactions.count == 0) {
		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:LString(@"Warning") message:LString(@"No item restored") delegate:nil cancelButtonTitle:LString(@"Cancel") otherButtonTitles: nil];
		[alert show];
	}
	else{
		[[RootViewController sharedInstance]IAPDidRestored];
	}
	

	
}


-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    L();
	//     [iapVC.loadingView stop];
	[[LoadingView sharedLoadingView] removeView];
	NSLog(@"Error:%@\n%@",[error localizedDescription],[error localizedFailureReason]);
}


#pragma mark - Alert
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	L();
	NSLog(@"button:%d",buttonIndex);
	
	if (YES) {
		if (buttonIndex == 1) { // buy

			[self requestProductWithIdendifier:identifier delegate:delegate];
		}
		else if(buttonIndex == 2){ // restore

			[self checkRestoredItemsWithDelegate:delegate];
			
		}
	}
}

#pragma mark - Public



- (void) showFullVersionAlert{
	identifier = kIAPFullVersion;
	delegate = nil;
	
	if (!fullVersionAlert) {
		
		fullVersionAlert = [[UIAlertView alloc]initWithTitle:@"Upgrade to full version" message:SIAPMsgPhone delegate:self cancelButtonTitle:LString(@"Cancel") otherButtonTitles:LString(@"Upgrade"),LString(@"Restore"), nil];
	
	}
	[fullVersionAlert show];
}

@end
