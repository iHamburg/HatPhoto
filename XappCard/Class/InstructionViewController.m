//
//  InstructionViewController.m
//  XappCard
//
//  Created by  on 03.02.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "InstructionViewController.h"
#import "IHRootViewController.h"
#import "Utilities.h"

@implementation InstructionViewController

@synthesize delegate;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
	L();
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{

	self.view = [[UIView alloc] initWithFrame:[[IHRootViewController sharedInstance]r]];
	self.view.backgroundColor = kDarkPatternColor;
	
	UIView *container = [[UIView alloc]initWithFrame:self.view.bounds];

	
	pageNum = 3;
	width = 320;
	self.view.autoresizingMask = AUTORESIZINGMASK;

	CGFloat height = 480;
	

	NSArray *imgs = @[@"instruction1.jpg",@"instruction2.jpg",@"instruction3.jpg"];
	
	scrollView = [[UIScrollView alloc]initWithFrame:container.bounds];

	scrollView.alpha = 0.9;
	scrollView.pagingEnabled = YES;
	scrollView.contentSize = CGSizeMake(width*pageNum+100, 0);
	scrollView.delegate = self;
	for (int i = 0; i<pageNum; i++) {
		
		UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(width*i, isPhoneRetina4?44:0, width, height)];
		imgV.image = [UIImage imageWithContentsOfFileName:imgs[i]];
		[scrollView addSubview:imgV];

	}
	
	pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.view.height-30, self.view.width, 30)];
	pageControl.numberOfPages = 3;
	
	
	[container addSubview:scrollView];
	//	[container addSubview:quitB];
	
	[container addSubview:pageControl];
	
	[self.view addSubview:container];


}





- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationPortrait;
}


- (NSUInteger)supportedInterfaceOrientations{
	//	L();
	return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - IBAction

- (IBAction)quit:(id)sender{
	L();
	[self.view removeFromSuperview];
}

#pragma mark - ScrollView

- (void)scrollViewDidScroll:(UIScrollView *)ascrollView{
//	L();
	CGFloat offset = scrollView.contentOffset.x;
	if (offset>2*320 + 5) {
		
		
		[delegate closeInstruction:self];
		
		[scrollView setContentOffset:CGPointZero];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)ascrollView{
	
	
	CGFloat xOffset = scrollView.contentOffset.x;
	int page = xOffset/scrollView.width;
	pageControl.currentPage = page;
}
@end
