//
//  AlbumLoader.h
//  XappCard
//
//  Created by  on 01.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol AlbumLoaderDelegate;

@interface AlbumLoader : NSObject{
	NSString* loadKey;
}

@property (nonatomic, unsafe_unretained)  id<AlbumLoaderDelegate> delegate;

- (void)loadUrls:(NSArray*)array withKey:(NSString*)key;
@end

@protocol AlbumLoaderDelegate <NSObject>

- (void)didLoadAsset:(ALAsset*)asset withKey:(NSString*)key;

@end