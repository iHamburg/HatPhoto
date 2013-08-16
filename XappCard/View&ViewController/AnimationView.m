//
//  AnimationView.m
//  XappCard
//
//  Created by  on 29.12.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import "AnimationView.h"
#import "Macros.h"

@implementation AnimationView

@synthesize animationV,staticV,index;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithIndex:(int)index{
	
	CGRect frame = CGRectMake(0, 0, 100, 100);
	
	if (self = [super initWithFrame:frame]) {
//		self.index = index;
//		NSString *path = [NSString stringWithFormat:@"pic/Sticker/Sticker%d_gif.gif",index];
//		NSURL *url = [NSURL fileURLWithPath:GetFullPath(path)];
//		self.animationV = [AnimatedGif  getAnimationForGifAtUrl:url];
//		self.staticV = [[UIImageView alloc] initWithFrame:frame];
//		staticV.hidden = YES;
//		[self addSubview:staticV];
//		[self addSubview:animationV];

		
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
- (void)showFirstImage{
	L();
	staticV.hidden = NO;
	animationV.hidden = YES;
	NSString *str = [NSString stringWithFormat:@"pic/Sticker/Sticker%d_1.png",index];
	NSLog(@"str:%@",str);
	staticV.image = [UIImage imageWithContentsOfFile:GetFullPath(str)];
}
- (void)showSecondImage{
	L();
	NSString *str = [NSString stringWithFormat:@"pic/Sticker/Sticker%d_0.png",index];
	staticV.image = [UIImage imageWithContentsOfFile:GetFullPath(str)];
}
- (void)hideImages{
	L();
	animationV.hidden = NO;
	staticV.hidden = YES;
}

@end
