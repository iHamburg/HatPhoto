//
//  WidgetComponent.m
//  MyPhotoAlbum
//
//  Created by AppDevelopper on 29.09.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "WidgetComponent.h"

@implementation WidgetComponent



@synthesize lockFlag;
static UIMenuItem *lockItem, *unlockItem, *editItem, *cropItem;



+ (UIMenuItem*)lockItem{
	if (!lockItem) {
		
		lockItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Lock", nil) action:@selector(menuLockPiece:)];
		
	}
	return lockItem;
}
+ (UIMenuItem*)unlockItem{
	if (!unlockItem) {

		unlockItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Unlock", nil) action:@selector(menuUnlockPiece:)];

	}
	return unlockItem;
}
+ (UIMenuItem*)editItem{
	if (!editItem) {
	
		editItem = [[UIMenuItem alloc]initWithTitle:@"Edit" action:@selector(menuEditPiece:)];
	}
	return editItem;
}

+ (UIMenuItem*)cropItem{
    if(!cropItem){
        cropItem = [[UIMenuItem alloc]initWithTitle:@"Crop" action:@selector(menuCropPiece:)];
    }
    return cropItem;
}
@end
