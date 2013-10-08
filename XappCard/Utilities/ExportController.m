//
//  ExportController.m
//  FirstThings_Uni
//
//  Created by  on 12.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "ExportController.h"
#import "RootViewController.h"
#import "Info2ViewController.h"
#import "FacebookManager.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@implementation ExportController


+(id)sharedInstance{
	static id sharedInstance;
	if (sharedInstance == nil) {
		
		sharedInstance = [[[self class] alloc]init];
	}
	
	return sharedInstance;
	
}

- (id)init{
	if(self = [super init]){
	
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(handleBecomeActive)
													 name:UIApplicationDidBecomeActiveNotification
												   object:nil];

	}
	return self;
}

#pragma mark - Notification
- (void)handleBecomeActive{
	L();
	
	// share过之后才会调用showRateAlert

	int rateNr = [[NSUserDefaults standardUserDefaults]integerForKey:kRateNrKey];
	NSLog(@"rate Nr # %d",rateNr);
	if (rateNr == -1) {
		return;
	}
	else if(rateNr>=3){
		[self showRateAlert];
	}
	else{
		[[NSUserDefaults standardUserDefaults]setInteger:rateNr+1 forKey:kRateNrKey];
	}
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{

	NSLog(@"button # %d",buttonIndex);
	if (alertView == rateAlert) {
		if (buttonIndex == 0) { //NO,thanks ,key == -1
			[[NSUserDefaults standardUserDefaults]setInteger:-1 forKey:kRateNrKey];
		}
		else if(buttonIndex == 1){//Yes, now, key == -1
			[[NSUserDefaults standardUserDefaults]setInteger:-1 forKey:kRateNrKey];
			[self toRate];
		}
		else if(buttonIndex == 2){ //Later
			[[NSUserDefaults standardUserDefaults]setInteger:0 forKey:kRateNrKey];
		}
	}
}

#pragma Rate
- (void)showRateAlert{
	
	L();
	if (!rateAlert) {
		rateAlert = [[UIAlertView alloc] initWithTitle:@"Dear user" message:SRateMsgPhone delegate:self
									 cancelButtonTitle:@"No, thanks" otherButtonTitles:@"Rate now",@"Remind me later",nil];
		
	}
	
	[rateAlert show];
	
	
}

#pragma mark - Email

- (void)sendEmail:(NSDictionary *)info{
	[[LoadingView sharedLoadingView] removeView];
	
	mailPicker = [[MFMailComposeViewController alloc] init];
	mailPicker.mailComposeDelegate = self;
	
	NSString *emailBody = [info objectForKey:@"emailBody"];
	NSString *subject = [info objectForKey:@"subject"];
	NSArray *toRecipients = [info objectForKey:@"toRecipients"];
	NSArray *ccRecipients = [info objectForKey:@"ccRecipients"];
	NSArray *bccRecipients = [info objectForKey:@"bccRecipients"];
	NSArray *attachment = [info objectForKey:@"attachment"]; //0: nsdata, 1: mimetype, 2: filename
	
	[mailPicker setMessageBody:emailBody isHTML:YES];
	[mailPicker setSubject:subject];
    [mailPicker setToRecipients:toRecipients];
	[mailPicker setCcRecipients:ccRecipients];
	[mailPicker setBccRecipients:bccRecipients];
	
	
	if (!ISEMPTY(attachment)) {
		
		[mailPicker addAttachmentData:[attachment objectAtIndex:0] mimeType:[attachment objectAtIndex:1] fileName:[attachment objectAtIndex:2]];
	}
	
	
	[[RootViewController sharedInstance] presentModalViewController:mailPicker animated:NO];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller

		  didFinishWithResult:(MFMailComposeResult)result

						error:(NSError *)error

{
	
	L();
	
    [controller dismissModalViewControllerAnimated:NO];
	
	if (result == MFMailComposeResultSent) {
		
	}
	
}

#pragma mark - Tweet

- (void)sendTweetWithText:(NSString*)text image:(UIImage*)image{
	[[LoadingView sharedLoadingView]removeView];
	
	// Set up the built-in twitter composition view controller.
	if (!tweetViewController) {
		tweetViewController = [[TWTweetComposeViewController alloc] init];
	}
    
    
    // Set the initial tweet text. See the framework for additional properties that can be set.
	
	if (image) {
		[tweetViewController addImage:image];
	}
	
	if (!ISEMPTY(text)) {
		[tweetViewController setInitialText:text];
		
	}

    // Create the completion handler block.
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
//        NSString *output;
//        
//        switch (result) {
//            case TWTweetComposeViewControllerResultCancelled:
//                // The cancel button was tapped.
//                output = @"Tweet cancelled.";
//                break;
//            case TWTweetComposeViewControllerResultDone:
//                // The tweet was sent.
//                output = @"Tweet done.";
//				//				[FlurryAnalytics logEvent:@"Tweet sent"];
//                break;
//            default:
//                break;
//        }
		
        [[RootViewController sharedInstance] dismissModalViewControllerAnimated:YES];

    }];
    
    // Present the tweet composition view controller modally.
    [[RootViewController sharedInstance] presentModalViewController:tweetViewController animated:YES];

}
#pragma mark - Rate
- (void)toRate{
//	int appId = isPaid()?495584349:540736134;

	NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
					 kAppID ];
	// NSLog(str);  
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]]; 
}

#pragma mark - Fullversion
- (void)toFullVersion{
	
	NSURL *url = [NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=495584349&mt=8"];
	[[UIApplication sharedApplication] openURL:url];

}

#pragma mark - Share


- (void)shareImage:(UIImage*)img text:(NSString*)text type:(ShareType)type{
    NSString *shareType = @"Unknown Share";
	NSString *twitterText = [text stringByAppendingFormat:@"\nvia ShakeHat - Try on new Hats. %@",kAppShortLink];
	if (type == ShareToAlbum) {
		shareType = @"Album";

		[[LoadingView sharedLoadingView]addInView:[[RootViewController sharedInstance] view]];
		
		[self saveImageInAlbum:img];
	}
	else if (type == ShareToFacebook){
		shareType = @"Facebook";
		// 不发到墙上而是直接发到照片中
		[[LoadingView sharedLoadingView]addInView:[[RootViewController sharedInstance]view]];

        [[FacebookManager sharedInstance]postImage:img text:twitterText];
		
	}
	else if (type == ShareToTwitter){
		shareType = @"Twitter";

        [self sendTweetWithText:twitterText image:img];
	}
	else if (type == ShareToEmail){
		shareType = @"Email";
		NSData *contentData = UIImageJPEGRepresentation(img , kJPEGCompressionQuality);
        NSString *twitterText = [text stringByAppendingFormat:@"\nvia ShakeHat. %@",kAppShortLink];
		NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
							  SShareImageEmailSubject, @"subject",
							  twitterText,@"emailBody",
							  [NSArray arrayWithObjects:contentData,@"image/jpeg",@"ShakeHat.jpg", nil], @"attachment",
							  nil];
		
		[[ExportController sharedInstance] sendEmail:info];
	}
    else if (type == ShareInstagram){
		shareType = @"Instagram";
        NSString *instagramName = [kAppName stringByAppendingPathExtension:@"igo"];
        [img saveWithName:instagramName];

        [self sharePhotoWithInstagram:instagramName text:twitterText];
    }
	
	NSString *hatName = [[RootViewController sharedInstance] hatName];
	if (ISEMPTY(hatName)) {
		hatName = @"Without Hat";
	}
	
	NSDictionary *dict = @{
	@"Share": shareType,
	@"Hatname" : hatName
	};
	
	[FlurryAnalytics logEvent:@"Share Photo" withParameters:dict];


}


- (void)saveImageInAlbum:(UIImage*)img{
		numOfPhotosToSave = 1;
	
	if (!library) {
		library = [[ALAssetsLibrary alloc] init];
	}
    
	[library saveImage:img toAlbum:kAppName withCompletionBlock:^(NSError *error){
		//            NSLog(@"saved!");
		if (!error) {
			[[LoadingView sharedLoadingView]addTitle:@"Saved!" inView:[[RootViewController sharedInstance]view]];
		}else{
			NSLog(@"error # %@",[error description]);
			[[LoadingView sharedLoadingView]addTitle:@"Please try it again later." inView:[[RootViewController sharedInstance]view]];
		}
	}];

}

- (void)sharePhotoWithInstagram:(NSString*)imgName text:(NSString*)text{
	
    //	NSString *filePath = [NSString dataFilePath:imgName];
	NSString *filePath = [NSString dataFilePath:imgName];
	
    documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    documentController.delegate = self;
	
	[[LoadingView sharedLoadingView]removeView];
	
	/*
	 Other common UTIs are "com.apple.quicktime-movie" (QuickTime movies), "public.html" (HTML documents), and "public.jpeg" (JPEG files).
	 */
    documentController.UTI = @"com.instagram.exclusivegram";
    
	documentController.annotation = [NSDictionary dictionaryWithObject:text forKey:@"InstagramCaption"];
	
	
    [documentController presentOpenInMenuFromRect:CGRectZero
										   inView:[[RootViewController sharedInstance]view]
										 animated:YES];
	
	
}



@end
