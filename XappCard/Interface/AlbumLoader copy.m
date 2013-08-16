//
//  AlbumLoader.m
//  XappCard
//
//  Created by  on 01.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "AlbumLoader.h"
#import "Utilities.h"

@implementation AlbumLoader

@synthesize delegate;


- (void)loadUrls:(NSArray*)array withKey:(NSString*)key{
	if (ISEMPTY(array)) {
		return;
	}
	
	loadKey = key;
	
	
	ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
	
	for(int i = 0; i<[array count];i++) {
		
		NSURL *url = [array objectAtIndex:i];
		ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
		{
			NSLog(@"resultblock");
			[delegate didLoadAsset:myasset withKey:loadKey];
			
		};
		
		ALAssetsLibraryAccessFailureBlock failureblock  = ^(NSError *myerror)
		{
			
			NSLog(@"booya, cant get image - %@",[myerror localizedDescription]);
		};
		
		[assetslibrary assetForURL:url 
					   resultBlock:resultblock
					  failureBlock:failureblock];
	}

}

@end
