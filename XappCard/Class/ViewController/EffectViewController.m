//
//  EffectViewController.m
//  HatPhoto
//
//  Created by AppDevelopper on 14.01.13.
//
//

#import "EffectViewController.h"
#import "UIResponder+MotionRecognizers.h"


@interface EffectViewController ()

@end

@implementation EffectViewController

@synthesize img = _img;

- (void)setImg:(UIImage *)img{

	_img = img;
	_originalImage = img;
	_imgV.image = _img;
	_frameIndex = 1;
	_effectIndex = 1;
	
	[self imageDidSelectedFilter:_functionScrollView.colorFilters[_effectIndex]];
	[self imageDidSelectedFrame:_frameScrollView.frames[_frameIndex]];
	_functionScrollView.imageIndex = _effectIndex;
	_frameScrollView.imageIndex = _frameIndex;
	
}

- (void)loadImgContainer {
    CGFloat yImgContainer = isPhoneRetina4?44:0;
	if (isIOS7) {
        yImgContainer +=44;
    }
    
    _imgContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yImgContainer, 320, 320)];
	_imgContainer.layer.borderColor = kPhotoBorderColor.CGColor;
	_imgContainer.layer.borderWidth = 5;
	_imgContainer.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
	_imgContainer.layer.shadowOpacity = 1;
	_imgContainer.layer.shadowOffset = isPad?CGSizeMake(2, 2):CGSizeMake(0, 3);
	_imgContainer.layer.shadowPath = [UIBezierPath bezierPathWithRect:_imgContainer.bounds].CGPath;
	
	_imgV = [[UIImageView alloc]initWithFrame:_imgContainer.bounds];
	_imgV.backgroundColor = [UIColor yellowColor];
	_imgV.contentMode = UIViewContentModeScaleAspectFit;
	
	_frameV = [[UIImageView alloc]initWithFrame:_imgContainer.bounds];
	
	[_imgContainer addSubview:_imgV];
	[_imgContainer addSubview:_frameV];
	
	UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
	swipe.direction = UISwipeGestureRecognizerDirectionLeft;
	[_imgContainer addGestureRecognizer:swipe];
	
	swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
	swipe.direction = UISwipeGestureRecognizerDirectionRight;
	[_imgContainer addGestureRecognizer:swipe];
}

- (void)loadButtonContainer {
    CGFloat yMarginButton = isPhoneRetina4?54:10;
	
	_buttonContainer = [[UIView alloc]initWithFrame:CGRectMake(75, CGRectGetMaxY(_imgContainer.frame)+yMarginButton, 170, 32)];
	_buttonContainer.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	
	_functionB = [UIButton buttonWithFrame:CGRectMake(3, 3, 80, 26) title:@"Effect" imageName:nil target:self actcion:@selector(buttonDidClicked:)];
	
    _frameB    = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(_functionB.frame)+3, 3, 80, 26) title:@"Frame" imageName:nil target:self actcion:@selector(buttonDidClicked:)];
	
	
	NSArray *buttons = @[_functionB,_frameB];
	for (UIButton *b in buttons) {
		[b.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
		b.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.8];
		b.titleLabel.shadowOffset = CGSizeMake(0, 1);
	}
	
	_buttonBGV = [[UIImageView alloc]initWithFrame:_functionB.bounds];
	_buttonBGV.image = [UIImage imageNamed:@"EffectButton.png"];
	_buttonContainer.layer.cornerRadius = 5;
	
	[_buttonContainer addSubview:_buttonBGV];
	[_buttonContainer addSubview:_functionB];
	[_buttonContainer addSubview:_frameB];
}

- (void)loadScrollVContainer {
    CGFloat hfunctionSV = 70;
	
	_scrollViewContainer = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_buttonContainer.frame)+3, _w, hfunctionSV)];
	_functionScrollView = [[PhotoEditFunctionScrollView alloc]initWithFrame:_scrollViewContainer.bounds];
	_functionScrollView.viewDelegate = self;
	
	_frameScrollView = [[FrameScrollView alloc]initWithFrame:_scrollViewContainer.bounds];
	_frameScrollView.viewDelegate = self;
    
	[_scrollViewContainer addSubview:_frameScrollView];
	[_scrollViewContainer addSubview:_functionScrollView];
}

- (void)loadView{
	root = [RootViewController sharedInstance];
	
    spriteManager = [SpriteManager sharedInstance];
    [self registerNotifications];
	
//	self.view = [[UIView alloc]initWithFrame:root.containerRect];
//	self.view = [[UIView alloc]initWithFrame:_r];
      self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _w, isIOS7?_h:_h-44)];
    
	self.view.backgroundColor = kDarkPatternColor;


	self.title = @"Effect";
	
    
	[self loadImgContainer];
	
	
	_shareBB = [[UIBarButtonItem alloc]initWithTitle:@"Share" style:UIBarButtonItemStyleBordered target:self action:@selector(buttonDidClicked:)];
	self.navigationItem.rightBarButtonItem = _shareBB;
	
	
	[self loadButtonContainer];
	
	[self loadScrollVContainer];
	
	
	[self.view addSubview:_imgContainer];
	[self.view addSubview:_buttonContainer];
	[self.view addSubview:_scrollViewContainer];

	
	[self applyFilter];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 
  如果是Main过来的会调用setimage
 
 
 */
- (void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = NO;
	[self addMotionRecognizerWithAction:@selector(motionWasRecognized:)];
}

- (void)viewDidAppear:(BOOL)animated{
	
	[super viewDidAppear:animated];

	
}

- (void)viewWillDisappear:(BOOL)animated{
	[self removeMotionRecognizer];
}

- (void)viewDidDisappear:(BOOL)animated{
	
	[super viewDidDisappear:animated];
	
//	_frameV.image = nil;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Notification

- (void)registerNotifications{
    
    //
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleAdviewNotification:) name:NotificationAdChanged object:nil];
    
}

- (void)handleAdviewNotification:(NSNotification*)notification{
    [self layoutADBanner:notification.object];
    
}

#pragma mark - Adview


- (void)layoutADBanner:(AdView *)banner{
    
    L();
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (banner.isAdDisplaying) { // 从不显示到显示banner
            
			[banner setOrigin:CGPointMake(0, _h - banner.height)];
                [_scrollViewContainer setOrigin:CGPointMake(0, self.view.height - _scrollViewContainer.height - banner.height)];
                [_buttonContainer setOrigin:CGPointMake(75, self.view.height - _scrollViewContainer.height - _buttonContainer.height - banner.height)];

			[root.view addSubview:banner];
		}
		else{
			[banner setOrigin:CGPointMake(0, _h)];

            [_scrollViewContainer setOrigin:CGPointMake(0, self.view.height - _scrollViewContainer.height)];
            [_buttonContainer setOrigin:CGPointMake(75, self.view.height - _scrollViewContainer.height - _buttonContainer.height)];
		}
		
    }];
    
}


#pragma mark - IBAction
- (IBAction)buttonDidClicked:(id)sender{
	
	if (sender == _shareBB) {

		[self toShare];
	
	}
	else if(sender == _functionB){
		
		[self applyFilter];
	
	}
	else if(sender == _frameB){
		
		[self applyFrame];
		
	}
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer*)swipe{
//	L();
	if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
		NSLog(@"swipe left"); // to share
		
		[self toShare];
	}
	else if(swipe.direction == UISwipeGestureRecognizerDirectionRight){
		NSLog(@"swipe right"); // back
		
		[self.navigationController popViewControllerAnimated:YES];

	}
	
}

#pragma mark - Motion (Shake)

- (void) motionWasRecognized:(NSNotification*)notif{
	[[AudioController sharedInstance]playAudio:AudioTypeShake];

	if (self.isEffectMode) {
		[self imageSelectRandomFilter];
	}
	else
		[self imageSelectRandomFrame];
	
}


#pragma mark - FrameScrollView
- (void)frameScrollViewDidSelectedFrame:(Frame *)frame{
	
	
	[self imageDidSelectedFrame:frame];
}
//
//- (void)frameScrollViewDidUnselectedFrame{
//	
//	[self imageDidUnselectedFrame];
//}

#pragma mark - PhotoEditFunctionSV
- (void)photoEditFunctionScrollViewDidSelected:(ImageFilter*)filter{
	[self imageDidSelectedFilter:filter];
}

//- (void)photoEditFunctionScrollViewDidSelectedNormal{
//    [self imageDidUnselectedFilter];
//}
//


#pragma mark - Function

- (BOOL)isEffectMode{
	return !_functionScrollView.hidden;
}

- (void)applyFilter{
	
	_frameScrollView.hidden = YES;
	_functionScrollView.hidden = NO;
	
	[UIView animateWithDuration:0.2 animations:^{
		_buttonBGV.center = _functionB.center;

	}];
 }
- (void)applyFrame{
	
	_frameScrollView.hidden = NO;
	_functionScrollView.hidden = YES;
	
	[UIView animateWithDuration:0.2 animations:^{
		_buttonBGV.center = _frameB.center;
		
	}];

}

- (void)imageDidSelectedFilter:(ImageFilter*)filter{
	_imgV.image = [filter imageByFilteringImage:_img];
}


- (void)imageDidSelectedFrame:(Frame*)frame{
	
//	NSLog(@"frame.imgName # %@",frame.imgName);
	
	UIImage *img = [UIImage imageWithContentsOfFileName:frame.imgName];
	

	_frameV.image = img;
}



- (void)imageSelectRandomFilter{
	
	[_functionScrollView selectRandom];

}
- (void)imageSelectRandomFrame{

	[_functionScrollView selectRandom];
}
- (void)toShare{
	
	//get image
	UIImage *img;
	if (_frameV.image) { // if there is frame applied
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320),NO,0);
		
        [_imgContainer.layer renderInContext:UIGraphicsGetCurrentContext()];
		
		img = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();

		
	}
	else{
		img = _imgV.image;
	}
	
	[root toShareVCWithImage:img];
}


#pragma mark - ADView


- (void)layoutBanner:(UIView*)banner loaded:(BOOL)loaded{
	
	[UIView animateWithDuration:0.25 animations:^{
		
		if (loaded) { // 从不显示到显示banner
			[_buttonContainer setOrigin:CGPointMake(75, _h-_scrollViewContainer.height-_buttonContainer.height- 50)];
			[_scrollViewContainer setOrigin:CGPointMake(0, _h-_scrollViewContainer.height - 50)];
			[banner setOrigin:CGPointMake(0, _h)];
			
		}
		else{
			[_buttonContainer setOrigin:CGPointMake(75, _h-_scrollViewContainer.height-_buttonContainer.height)];
			[_scrollViewContainer setOrigin:CGPointMake(0, _h-_scrollViewContainer.height)];
			[banner setOrigin:CGPointMake(0, _h+_hAdBanner)];
		}
		
    }];
	
	//	NSLog(@"H# %f,hBanner # %f,banner # %@",_h,_hAdBanner,banner);
	
	
}



@end
