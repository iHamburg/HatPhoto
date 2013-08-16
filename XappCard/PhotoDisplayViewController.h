//
//  PhotoDisplayViewController.h
//  travelAlbum
//
//  Created by XC on 7/19/12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ImageTableView.h"
//#import "ToggleImageView.h"
#import "FacebookManager.h"
//#import "EditSidebar.h"

typedef enum {
	PhotoSourceAlbum,
	PhotoSourceFacebook
}PhotoSource;

/*
 display pics from asset
 */


@interface PhotoDisplayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

	UITableView *tableView;
	
	NSMutableArray *elcAssets;
    NSMutableArray *thumbs;  //imgVs for fb
//	NSMutableArray *thumbImages;

	NSMutableArray *thumbsInRow;
	
	PhotoSource source;
    int count;
	CGFloat w,h;
	CGFloat margin;
	int numOfPhotoInRow;
	CGSize thumbSize;
}

@property (nonatomic, unsafe_unretained) ALAssetsGroup *assetGroup;  // 设置links 的容器
@property (nonatomic, strong) NSArray *fbPhotos;
@property (nonatomic, assign) PhotoSource source;

@end
