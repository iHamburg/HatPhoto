//
//  ContentImageViewController.h
//  XappCard
//
//  Created by  on 09.12.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"


@class PocketView;
@class MyView;
@interface ContentImageViewController : UIViewController{

}


@property (nonatomic, retain) ContentViewController *contentVC;

@property (nonatomic, retain) IBOutlet MyView *photosBG;

- (void)addImgVs:(NSArray*)imgVs;

- (void)willMakeScreenshot;
- (void)didMakeScreenshot;
@end
