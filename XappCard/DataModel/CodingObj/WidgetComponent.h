//
//  WidgetComponent.h
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 29.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utilities.h"

@protocol WidgetDelegate <NSObject>


- (id)encodedObject;
- (void)setLockFlag:(BOOL)lockFlag;
- (BOOL)lockFlag;

@optional
- (void)loadImage;
- (void)deleteDocuments;
- (NSArray*)menuItems;
@end


@interface WidgetComponent : NSObject

@property (nonatomic, assign) BOOL lockFlag;

+ (UIMenuItem*)lockItem;
+ (UIMenuItem*)unlockItem;
+ (UIMenuItem*)editItem;
+ (UIMenuItem*)cropItem;
@end
