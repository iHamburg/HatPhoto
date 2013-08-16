//
//  FBAlbumsViewController.h
//  InstaMagazine
//
//  Created by AppDevelopper on 07.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "FacebookManager.h"



/**

 placeholder : ipad: 57x57 iphone: 30
 */


@class PhotoDisplayViewController;

@interface FBAlbumsViewController : UITableViewController<FBRequestDelegate>{
	NSMutableArray *albums; // fb
	PhotoDisplayViewController *photoDisplayVC;
	
	UIBarButtonItem *reloadBB;
	FacebookManager *fbManager;
	
	BOOL reloadingFlag;
//	CGSize imgSize;
}

- (void)updateFBAlbums;
- (void)reloadAlbums;
@end
