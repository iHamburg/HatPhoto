//
//  FBAlbum.m
//  InstaMagazine
//
//  Created by AppDevelopper on 07.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "FBAlbum.h"

@interface FBAlbum ()

- (void)requestPhotos;

@end

@implementation FBAlbum

@synthesize albumID,coverID,name,numberOfPhotos,coverLink,fbPhotos,coverImage;


/*
 {
 "can_upload" = 0;
 count = 2;
 "cover_photo" = 134759469953130;
 "created_time" = "2011-08-31T18:00:00+0000";
 from =             {
 id = 100002572320629;
 name = "Zh Tom";
 };
 id = 134759466619797;
 link = "http://www.facebook.com/album.php?fbid=134759466619797&id=100002572320629&aid=26860";
 name = "supercry Photos";
 privacy = everyone;
 type = app;
 "updated_time" = "2011-08-31T18:10:56+0000";
 }

 */

- (id)initWithDictionary:(NSDictionary*)dict{
	if (self = [super init]) {
		albumID = dict[@"id"];
		name = dict[@"name"];
		numberOfPhotos = [dict[@"count"] intValue];
		coverID = dict[@"cover_photo"];
		fbPhotos = [NSMutableArray array];
		
		[self requestPhotos];
	}
	return self;
}

- (NSString*)description{
	NSString *str = @"";
	str = [str stringByAppendingFormat:@"name:%@\n",name];
	str = [str stringByAppendingFormat:@"number of cover:%d\n",numberOfPhotos];
	str = [str stringByAppendingFormat:@"coverLink:%@\n",coverLink];
	return str;
}

/*
 如果在返回request之前，FBAlbum就被dealloc，
 
 */

- (void)requestPhotos{
	
//	NSLog(@"album # %@ request photos, cover # %@",name,coverID);
	
	[[FacebookManager sharedInstance]requestPhoto:coverID withDelegate:self];
	
	[[FacebookManager sharedInstance]requestAlbumPhotos:albumID withDelegate:self];

	
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
	//    NSLog(@"received response");
}

// only for photo



/*
 
 这里面picture的size最大130
 
 "created_time" = "2011-08-31T18:00:00+0000";
 from =     {
 id = 100002572320629;
 name = "Zh Tom";
 };
 height = 39;
 icon = "https://s-static.ak.facebook.com/rsrc.php/v2/yz/r/StEh3RhPvjk.gif";
 id = 134759469953130;
 images =     (
 {
...
 }
 );
 link = "http://www.facebook.com/photo.php?fbid=134759469953130&set=a.134759466619797.26860.100002572320629&type=1";
 picture = "https://fbcdn-photos-a.akamaihd.net/hphotos-ak-ash4/300475_134759469953130_2268230_s.jpg";
 source = "https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-ash4/300475_134759469953130_2268230_n.jpg";
 "updated_time" = "2011-08-31T18:00:01+0000";
 width = 184;
 */

- (void)request:(FBRequest *)request didLoad:(id)result {

//	NSLog(@"request # %@",request.url);
	if (ISEMPTY(result)) {
		NSLog(@"empty result");
		return;
	}

//	NSLog(@"album # %@,result:%@",name,result);
	
	//cover id: photo 返回值就是一个dict
	/*
	 result:{
	 "created_time" = "2012-06-17T21:29:18+0000";
	 from =     {
	 id = 100002572320629;
	 name = "Zh Tom";
	 };
	 height = 540;
	 icon = "https://s-static.ak.facebook.com/rsrc.php/v2/yz/r/StEh3RhPvjk.gif";
	 id = 295280117234397;
	 images =     (
	 ...
	 };
	 link = "http://www.facebook.com/photo.php?fbid=295280117234397&set=a.295280113901064.62911.100002572320629&type=1";
	 name = Hh;
	 picture = "https://fbcdn-photos-a.akamaihd.net/hphotos-ak-ash4/484331_295280117234397_1489241083_s.jpg";
	 source = "https://fbcdn-sphotos-f-a.akamaihd.net/hphotos-ak-ash4/484331_295280117234397_1489241083_n.jpg";
	 "updated_time" = "2012-06-17T21:29:19+0000";
	 width = 720;
	 }
	 */
	

	NSRange range = [request.url rangeOfString:@"photos"];

	if (range.location == NSNotFound) {

		NSString *aCoverID = result[@"id"];

		if ([aCoverID isEqualToString:coverID]) {

			coverLink = result[@"picture"];
	
			
			//调用 sddownloader
			if (!ISEMPTY(coverLink)) {
				[SDWebImageDownloader downloaderWithURL:[NSURL URLEncodedWithString:coverLink] delegate:self];

			}
			
		}
	}
	
	NSArray *photoArray = result[@"data"];
	for (NSDictionary *dict in photoArray) {
		
		FBPhoto *photo = [[FBPhoto alloc]initWithDictionary:dict];
		[fbPhotos addObject:photo];

	}

}


- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@,%@", [[error userInfo] objectForKey:@"error_msg"],[error localizedDescription]);
    NSLog(@"Err code: %d", [error code]);
	
//	[[LoadingView sharedLoadingView] addTitle:@"" inView:]];
}

#pragma mark - SDDownloader
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image{
//	L();
	
	coverImage = image;

//	NSLog(@"fb album cover size # %@,scale # %f",NSStringFromCGSize(image.size),image.scale);  // 130,1
    
}
- (void)imageDownloader:(SDWebImageDownloader *)downloader didFailWithError:(NSError *)error{
	L();
	NSLog(@"error:%@",[error description]);
//	[[LoadingView sharedLoadingView]addTitle:@"Download Failed." inView:[[ViewController sharedInstance] view]];
}

@end
