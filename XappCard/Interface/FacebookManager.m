//
//  FacebookManager.m
//  InstaMagazine
//
//  Created by AppDevelopper on 07.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "FacebookManager.h"
#import "IHRootViewController.h"
#import "AppDelegate.h"



@interface FacebookManager()

- (void)authorize;
- (void)uploadPhotosToAlbum:(NSString*)albumID;
@end

@implementation FacebookManager

@synthesize fbAlbums, fbPhotoDict,fbUserName;



+(id)sharedInstance{
	static id sharedInstance;
	if (sharedInstance == nil) {
		
		sharedInstance = [[[self class] alloc]init];
	}
	
	return sharedInstance;
	
}

- (id)init{
	if (self = [super init]) {
		
		fbAlbums = [NSMutableArray array];
		fbPhotoDict = [NSMutableDictionary dictionary];
	}
	return self;
}


/**
 
 每次request都调用authorize其实有些重复
 
 可以
 1. feed
 2. request albums
 3.
 
*/

- (void)authorize{
	
	AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
	facebook = [appDelegate facebook];
	
	// 从defaults中给facebook的token和expirationdate赋值
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"FBAccessTokenKey"]
		&& [defaults objectForKey:@"FBExpirationDateKey"]) {

		facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
		facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
	}

	//如果token不存在或者过期就就行facebook的authorize流程
	if (![facebook isSessionValid]) {
		
		[facebook authorize:nil];
	}

}

#pragma mark - FBSessionDelegate Methods



- (void)fbDidLogin {
	
	NSLog(@"fb Did login");
	AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
	
	facebook = [appDelegate facebook];
	
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
	
	
//	[[ViewController sharedInstance] switchToScene:SceneManager];
	
}


/**
 * Called when the user has logged in successfully.
 */

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
	L();
	NSLog(@"token extended");

}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"fb not login");
	//    [pendingApiCallsController userDidNotGrantPermission];
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
	//    pendingApiCallsController = nil;
    
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
	//    [self showLoggedOut];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [self fbDidLogout];
}

#pragma mark - FBDialogDelegate
/**
 
 called： 当feed成功
 */

- (void)dialogDidComplete:(FBDialog *)dialog{
	L();
	
	// 不一定要返回信号
	//	[[LoadingView sharedLoadingView]addTitle:@"Sent !" inView:[[ViewController sharedInstance]view]];
	[[LoadingView sharedLoadingView]addTitle:@"Uploaded!" inView:[[IHRootViewController sharedInstance]view]];
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response.
 *
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	
	
    NSLog(@"received request #%@ ,response",request.url);
	
	

	
	
	//发声音作为提示更好
	
	//	[[LoadingView sharedLoadingView]showTitle:@"Added into Facebook" inView:[delegate view]];

	//	[FlurryAnalytics logEvent:@"Facebook Sent"];
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 
 
 
 1. me/photos

 2. me/albums

    2.1 create new album
 parameter:
 description = "Test Description";
 format = json;
 name = "Test Album2";
 sdk = ios;
 "sdk_version" = 2;
 
 result # {  //dict
 id = 356192597809815;
 }

    2.2 fetch all albums
 
 params:
 
 format = json;
 sdk = ios;
 "sdk_version" = 2;
 
 
 result # {    //dict
 data =     (  //array
 {


 
 3. albumID/photos  -> update photos
 
 
 
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	
	
	// 当share image后会有这个反应
	
//	NSLog(@"request #%@, parameters #%@",request.url,request.params);
	
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }

	NSString *requestStr = request.url;

    
	// post image
	NSRange range = [requestStr rangeOfString:@"me/photos"];
	if (range.location!=NSNotFound) {
			[[LoadingView sharedLoadingView]addTitle:@"Uploaded!" inView:[[IHRootViewController sharedInstance]view]];
		return;
	}
	
	//requestAlbums  -> FBAlbumsVC
	range = [requestStr rangeOfString:@"me/albums"];
	if (range.location!=NSNotFound) {
//		NSLog(@"result # %@",result);

		if (!ISEMPTY(result[@"id"])) {
			/**
			 
			 create new album

			 */
			
			NSString *newAlbumID = result[@"id"];
			NSLog(@" new album id # %@", newAlbumID);
			
			[self uploadPhotosToAlbum:newAlbumID];
			
			return;
		}
		else{
			/**
			 
			    fetch all albums
			 
			 params:
			 
			 format = json;
			 sdk = ios;
			 "sdk_version" = 2;
			 
			 
			 result # {    //dict
			 data =     (  //array
			 {
			 

			 */
			
			[fbAlbums removeAllObjects];
			
			NSArray *albumArray = result[@"data"];
			//		NSLog(@"albums # %@",albumArray);
			
			if (!ISEMPTY(albumArray)) {
				NSDictionary *dict = albumArray[0];
				if (!ISEMPTY(dict)) {
					NSDictionary *userInfos = dict[@"from"];
					if (!ISEMPTY(userInfos)) {
						fbUserName = userInfos[@"name"];
						NSLog(@"fbUsername # %@",fbUserName);
					}
				}
			}
			
			for (NSDictionary *dict in albumArray) {
				FBAlbum *album = [[FBAlbum alloc]initWithDictionary:dict];
				[fbAlbums addObject:album];
				
			}

			[[NSNotificationCenter defaultCenter]postNotificationName:kNotificationFinishRequestAlbums object:nil];
			return;
		}
		
	
	}
	
	
	//albumID/photos
	
	NSLog(@" albumID/photos # %@",result);
	numOfPhotsToUpload --;
	if (numOfPhotsToUpload <= 0) {
//		[[LoadingView sharedLoadingView]removeView];
		[[LoadingView sharedLoadingView]addTitle:@"Uploaded!" inView:[[IHRootViewController sharedInstance]view]];
	}
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
	
	
}


#pragma mark - Public

/**
 
 发送feed 传递Handler: dialogDidComplete
 
 */

- (void)feed{

	[self authorize];


	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   FBAppID, @"app_id",
								   kApplink, @"link",
								   @"http://www.xappsoft.de/img/Icon_ShakeHat_128.png", @"picture",
								   kAppName, @"name",
								   SFBCaption, @"caption",
								   SFBDescription, @"description",
								   nil];
	
	[facebook dialog:@"feed" andParams:params andDelegate:self];
	
}

/**
 
 request: me/photos
 */

- (void)postImage:(UIImage*)img{

	[self postImage:img text:SFBPostImageMsg];
}


- (void)postImage:(UIImage *)img text:(NSString*)text{
    
    [self authorize];
    
    NSData *picData = UIImageJPEGRepresentation(img, kJPEGCompressionQuality);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   text,@"message",
                                   picData, @"picture",
                                   nil];
	
    [facebook requestWithGraphPath:@"me/photos"
						 andParams:params
					 andHttpMethod:@"POST"
					   andDelegate:self];
}
/**
 
 在FBAlbumVC出现时调用一次，如果fbalbums已经初始化了，就不再次调用了
 
  request: me/albums
 
 不会调用requestalbumphotos
 
 
 现在程序只会加载一次album！！
 
 */


- (void)requestAlbums{
	L();
	
	[self authorize];
	[facebook requestWithGraphPath:@"me/albums" andDelegate:self];
	

}

/**
 
 强制fetch albums
 
 Bug: 连续reload会导致fbalbum dealloc，然后出错！！
 
 */

- (void)reloadAlbums{
	
//	[fbAlbums removeAllObjects];
	[self authorize];
	[facebook requestWithGraphPath:@"me/albums" andDelegate:self];
	
}
/**
 
 from:    fbalbumsVC
 request: albumID/photos 
 
 */

- (void)requestAlbumPhotos:(NSString*)albumID withDelegate:(id)delegate{
	[self authorize];
	NSString *str = [albumID stringByAppendingString:@"/photos"];
	[facebook requestWithGraphPath:str andDelegate:delegate];
}


/**
 request: photoID
 
 */

- (void)requestPhoto:(NSString*)photoID withDelegate:(id)delegate{
	//	[self authorize];
	if (ISEMPTY(photoID)) {
		return;
	}
	
	[facebook requestWithGraphPath:photoID andDelegate:delegate];
}


- (void)uploadPhotosToAlbum:(NSString*)albumID{
	
	[self authorize];
	
//	NSString *request = [albumID stringByAppendingString:@"/photos"];
//	
//	numOfPhotsToUpload = [imgs count];
//	for (int i = 0; i < numOfPhotsToUpload; i++) {
//		UIImage *img = imgs[i];
//		NSData *picData = UIImageJPEGRepresentation(img, 0.6);
//		NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//									   SFBPostImageMsg,@"message",
//									   picData, @"picture",
//									   nil];
//		
//		[facebook requestWithGraphPath:request andParams:params andHttpMethod:@"POST" andDelegate:self];
//		
//
//	}

}

- (void)uploadNewAlbum:(NSString*)albumName imgs:(NSArray*)_imgs{
//	if (ISEMPTY(_imgs)) {
//		[[LoadingView sharedLoadingView]addTitle:@"Error: No Images to be uploaded!" inView:[[ViewController sharedInstance]view]];
//		return;
//	}
//
//	
//	[self authorize];
//	NSMutableDictionary *params =[NSMutableDictionary dictionaryWithDictionary: @{
//								  @"name":albumName,
//								  @"description":SShareFBNewAlbumMsg,
//								  }];
//	
//	imgs = _imgs;
//	[facebook requestWithGraphPath:@"me/albums" andParams:params andHttpMethod:@"POST" andDelegate:self];

}
@end
