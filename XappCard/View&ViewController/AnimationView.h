//
//  AnimationView.h
//  XappCard
//
//  Created by  on 29.12.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "AnimatedGif.h"

@interface AnimationView : UIView

@property (nonatomic, assign) int index;
@property (nonatomic, strong) UIImageView *animationV;
@property (nonatomic, strong) UIImageView *staticV;

- (id)initWithIndex:(int)index;

- (void)showFirstImage;
- (void)showSecondImage;
- (void)hideImages;
@end
