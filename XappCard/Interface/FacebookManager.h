//
//  FacebookManager.h
//  InstaMagazine
//
//  Created by AppDevelopper on 07.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"
#import "Utilities.h"
#import "LoadingView.h"
#import "FBAlbum.h"
#import "FBPhoto.h"

#define FBAppID @"118673921639778"
#define kNotificationFinishRequestAlbums @"NotificationFinishRequestAlbum"


@interface FacebookManager : NSObject<FBSessionDelegate, FBRequestDelegate, FBDialogDelegate>{
	Facebook *facebook;
	
	NSArray *imgs;  // for upload images
	
	int numOfPhotsToUpload;
	
}

@property (nonatomic, strong) NSString *fbUserName;
@property (nonatomic, strong) NSMutableArray *fbAlbums;
@property (nonatomic, strong) NSMutableDictionary *fbPhotoDict; //photoid - fbphoto


+ (id)sharedInstance;


- (void)feed;
- (void)postImage:(UIImage*)img;
- (void)postImage:(UIImage *)img text:(NSString*)text;

- (void)requestAlbums;
- (void)reloadAlbums;
- (void)requestAlbumPhotos:(NSString*)albumID withDelegate:(id)delegate;
- (void)requestPhoto:(NSString*)photoID withDelegate:(id)delegate;


- (void)uploadNewAlbum:(NSString*)albumName imgs:(NSArray*)imgs;
@end
