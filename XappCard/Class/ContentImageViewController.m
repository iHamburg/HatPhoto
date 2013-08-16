//
//  ContentImageViewController.m
//  XappCard
//
//  Created by  on 09.12.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import "ContentImageViewController.h"
#import "MyView.h"
#import "Macros.h"

@implementation ContentImageViewController

@synthesize contentVC,photosBG;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    L();
   // photosBG.contentImageVC = self;
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	
}


#pragma mark - from  SuperView
- (void)addImgVs:(NSArray*)imgVs{
    L();
    [photosBG addImgsFromAlbum:imgVs];
}

- (void)willMakeScreenshot{
    photosBG.pocketHinter.hidden = YES;
    photosBG.pocketVorder.hidden = YES;
}

- (void)didMakeScreenshot{
    photosBG.pocketHinter.hidden = NO;
    photosBG.pocketVorder.hidden = NO;

}

@end
