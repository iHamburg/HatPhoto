//
//  ContentImageView.m
//  XappCard
//
//  Created by  on 13.12.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import "ContentImageView.h"

@implementation ContentImageView


- (void)awakeFromNib
{
    L();
   
    [super awakeFromNib];

    UIImageView *iconV = (UIImageView*)[self viewWithTag:11];
    iconV.image = [UIImage imageWithContentsOfFile:GetFullPath(@"pic/Background/Camera.png")];

    stepL.text = NSLocalizedString(@"Step2",nil);

        
}

#pragma mark - from  SuperView
/*
- (void)addImgVs:(NSArray*)imgVs{
    L();
    [self addImgsFromAlbum:imgVs];
}

- (void)willMakeScreenshot{
    [super willMakeScreenshot];
}

- (void)didMakeScreenshot{
    [super didMakeScreenshot];
    
}
*/
@end
