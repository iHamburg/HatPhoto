//
//  ContentTextViewController.m
//  XappCard
//
//  Created by  on 09.12.11.
//  Copyright (c) 2011 Xappsoft. All rights reserved.
//

#import "ContentTextViewController.h"
#import "PortfolioView.h"
#import "Utilities.h"
#import "MyView.h"

@implementation ContentTextViewController

@synthesize contentVC;
@synthesize  textView,portfolioView,myView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       // L();
       
       
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
    L();
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // init zettel
    
  //   myView.contentTextVC = self;
    
    NSMutableArray *zettels = [NSMutableArray array];
    for (int i = 1; i<5; i++) {
        NSString *imgPath = [NSString stringWithFormat:@"pic/Zettel/EN/Zettel_%d_EN.png",i];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:GetFullPath(imgPath)]];
        [zettels addObject:imgV];
    }
    [myView addImgsFromZettel:zettels];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - From Root
- (void)changeFont:(UIFont*)font{
    L();
    [textView setFont:font];
}

- (void)setProfile:(UIImage*)img{
    L();
    portfolioView.portfolioPhoho.image = img;
}

#pragma mark - From Subview
- (void)pickProfile{
    L();
    DLog(@"rootVc:%@",contentVC.rootVC);
    
    [contentVC.rootVC pickProfile];
    
    
}


@end
