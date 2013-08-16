//
//  StickerViewController.h
//  XappCard
//
//  Created by  on 17.12.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverContentViewController.h"
#import "RootViewController.h"

@interface StickerViewController : PopoverContentViewController

//@property (nonatomic, strong) RootViewController *rootVC; 
@property (nonatomic, strong) NSMutableArray *imgVs;


@property (nonatomic, strong) UIScrollView *scrollView;
@end
