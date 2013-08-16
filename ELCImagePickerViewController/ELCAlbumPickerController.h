//
//  AlbumPickerController.h
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ELCAlbumPickerController : UITableViewController {
	
	NSMutableArray *assetGroups;
	NSOperationQueue *queue;
	id __unsafe_unretained parent;
    
    ALAssetsLibrary *library;
}

@property (nonatomic, unsafe_unretained) id parent;
@property (nonatomic, strong) NSMutableArray *assetGroups;

-(void)selectedAssets:(NSArray*)_assets;

@end

