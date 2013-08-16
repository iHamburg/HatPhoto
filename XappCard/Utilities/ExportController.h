//
//  ExportController.h
//  FirstThings_Uni
//
//  Created by  on 12.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>
#import "Utilities.h"
#import <AssetsLibrary/AssetsLibrary.h>

typedef enum{
	
    ShareToAlbum,
	ShareToFacebook,
	ShareToTwitter,
	ShareToEmail,
    ShareInstagram,
	ShareAlbumToFacebook,
	ShareAlbumSendPDF,
	ShareAlbumSavePDF,
	ShareAlbumSaveImages,
	ShareMax
    
}ShareType;

#define kRateNrKey @"rateNr"

@interface ExportController : NSObject<MFMailComposeViewControllerDelegate, UIAlertViewDelegate,UIDocumentInteractionControllerDelegate>{
	MFMailComposeViewController *mailPicker;
	TWTweetComposeViewController *tweetViewController;
    ALAssetsLibrary* library;
    UIDocumentInteractionController *documentController;
    int numOfPhotosToSave;
	
	UIAlertView *rateAlert;
}


+(id)sharedInstance;

- (void)showRateAlert;

- (void)sendEmail:(NSDictionary *)info;
- (void)sendTweetWithText:(NSString*)text image:(UIImage*)image;

- (void)shareImage:(UIImage*)img text:(NSString*)text type:(ShareType)type;

- (void)saveImageInAlbum:(UIImage*)img;
- (void)sharePhotoWithInstagram:(NSString*)imgName text:(NSString*)text;

- (void)toRate;
- (void)toFullVersion;
@end
