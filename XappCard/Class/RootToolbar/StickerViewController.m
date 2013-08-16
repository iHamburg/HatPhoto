//
//  StickerViewController.m
//  XappCard
//
//  Created by  on 17.12.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import "StickerViewController.h"
#import "ELCAsset.h"
//#import "AnimatedGif.h"

@implementation StickerViewController

@synthesize imgVs,scrollView;



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    L();
    // Release any cached data, images, etc that aren't in use.
}


- (void)dealloc{
    L();
	NSLog(@"self:%@",self);
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    L();
	NSLog(@"self:%@",self);
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 411, 320)];
    self.view.backgroundColor = [UIColor whiteColor];
    
	self.title = NSLocalizedString(@"StickerTitel", nil);
    self.contentSizeForViewInPopover = CGSizeMake(411, 320);
 
    
	
	self.imgVs = [NSMutableArray array];
	
    for (int i = 1; i<7; i++) {
//        NSString *imgPath = [NSString stringWithFormat:@"pic/Sticker/Sticker%d_gif.gif",i];
//        
//		NSURL *url = [NSURL fileURLWithPath:GetFullPath(imgPath)];
//        UIImage *img = [UIImage imageWithContentsOfFile:GetFullPath(imgPath)];
//        img = [img imageByScalingAndCroppingForSize:CGSizeMake(128, 128)];
//        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 128, 128)] ;
//		imgV.image = img;
////		UIImageView *imgV = [AnimatedGif getAnimationForGifAtUrl:url];
//		
//		[imgV setSize:CGSizeMake(128, 128)];
//        [imgVs addObject:imgV];
//        [asset release];
    }
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.scrollEnabled = NO;
    scrollView.contentSize = CGSizeMake(0, 140*([imgVs count]/2+1));
    [scrollView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handelTap:)]];
    [self.view addSubview:scrollView];
    CGFloat leftPadding = 20;
	
    for (int i = 0;i<[imgVs count] ; i++) {
        
        
        UIImageView *asset = [imgVs objectAtIndex:i];
        CGRect frame = asset.frame;
        frame.size = CGSizeMake(128, 128);
        frame.origin.y = 20+140*(i/3);
        if (i%3 == 0) {
            frame.origin.x = leftPadding;
        }
        else if(i%3 == 1){
            frame.origin.x = leftPadding+140;
        }
        else if(i%3 == 2){
            frame.origin.x = leftPadding+280;
        }
        asset.frame = frame;
        [scrollView addSubview:asset];
        
    }


}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    L();
	NSLog(@"self:%@",self);
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = nil;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	L();
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
   return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
#pragma mark - Gesture
- (void)handelTap:(UITapGestureRecognizer*)gesture{
    L();
    CGPoint point = [gesture locationInView:scrollView];
    DLog(@"point:%@", NSStringFromCGPoint(point));
      for (int i = 0; i<7; i++) {
        ELCAsset *asset = [imgVs objectAtIndex:i];
        CGRect frame = asset.frame;
        if (CGRectContainsPoint(frame,point)) {
//            [rootVC addAnimation:[NSArray arrayWithObject:[NSNumber numberWithInt:i]]];
            [rootVC.popVC dismissPopoverAnimated:YES];
            break;
        }

    }
    
}

#pragma mark - Navigation
- (void)cancel:(id)sender{
	
//    [rootVC.popVC dismissPopoverAnimated:YES];
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:NotifiRootDismiss object:nil];
}

- (void)done:(id)sender{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i<[imgVs count]; i++) {
        // every asset.image to array
        ELCAsset *asset = [imgVs objectAtIndex:i];
        if (asset.selected) {
            // [array addObject:asset.imageView];
            [array addObject:[NSNumber numberWithInt:i]];
        }
    }
    DLog(@"selected:%@",array);
  
	//[rootVC addZettels:array];
    
	[[NSNotificationCenter defaultCenter]
	 postNotificationName:NotifiRootDismiss object:nil];
}
@end
