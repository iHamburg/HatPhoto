//
//  PRootViewController.m
//  iCamAlbum
//
//  Created by AppDevelopper on 13-10-11.
//  Copyright (c) 2013年 Xappsoft. All rights reserved.
//

#import "PRootViewController.h"
#import "Utilities.h"
@interface PRootViewController ()

@end

@implementation PRootViewController

- (void)loadView{
    
    [super loadView];
    _r = [UIScreen mainScreen].bounds;
	self.view = [[UIView alloc]initWithFrame:_r];
    _w = _r.size.width;
    _h = _r.size.height;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (NSUInteger)supportedInterfaceOrientations{
    
	return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}


@end
