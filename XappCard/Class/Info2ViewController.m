//
//  Info2ViewController.m
//  InstaMagazine
//
//  Created by AppDevelopper on 13.10.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "Info2ViewController.h"
#import "FacebookManager.h"
#import "MoreApp.h"

@interface Info2ViewController ()

@end

@implementation Info2ViewController


#define kFontName @"Futura-CondensedMedium"

@synthesize root;

- (void)loadView{
	
	CGRect r = [UIScreen mainScreen].bounds;
	
	r = CGRectApplyAffineTransform(r, CGAffineTransformMakeRotation(90 * M_PI / 180.));
	r.origin = CGPointZero;
	
	self.view = [[UIView alloc] initWithFrame: r];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG_pattern_info.png"]];
	width = self.view.width;
	height = self.view.height;

	
	
	// w,h: 100/42, 有margin
	float faktor = kUniversalFaktor;
	CGFloat xBMargin = isPad?65:40;
	CGFloat yBMargin = isPad?80:26;
	CGFloat wButton = isPad?80:34;
	CGFloat hButton = isPad?80:34;
	CGFloat yButtonsMargin = isPad?20:7;
	CGFloat hLabel = isPad?30:14;
	
	backB = [UIButton buttonWithFrame:CGRectMake(3, 3, isPad?60:25, isPad?60:25) title:nil imageName:@"icon_back.png" target:self actcion:@selector(back)];
	
	instructionB = [UIButton buttonWithFrame:CGRectMake(xBMargin, yBMargin, wButton, hButton) title:nil imageName:@"Info_Instruction.png" target:self actcion:@selector(toInstruction)];
	UILabel *instructionL = [[UILabel alloc]initWithFrame:CGRectMake(xBMargin-20, CGRectGetMaxY(instructionB.frame), wButton+40, hLabel)];
	instructionL.text = @"Instruction";
	
	aboutB = [UIButton buttonWithFrame:CGRectMake(xBMargin, CGRectGetMaxY(instructionL.frame)+yButtonsMargin, wButton, hButton) title:nil imageName:@"Info_Xapp.png" target:self actcion:@selector(aboutus)];
	UILabel *aboutL = [[UILabel alloc]initWithFrame:CGRectMake(xBMargin-20, CGRectGetMaxY(aboutB.frame), wButton+40, hLabel)];
	aboutL.text = @"About Us";
	recommendB = [UIButton buttonWithFrame:CGRectMake(xBMargin, CGRectGetMaxY(aboutL.frame)+ yButtonsMargin, wButton, wButton*0.66) title:nil imageName:@"Info_Recommend.png" target:self actcion:@selector(email)];
	UILabel *recommendL = [[UILabel alloc]initWithFrame:CGRectMake(xBMargin-20, CGRectGetMaxY(recommendB.frame), wButton+40, hLabel)];
	recommendL.text = @"Recommend";
	supportB = [UIButton buttonWithFrame:CGRectMake(xBMargin, CGRectGetMaxY(recommendL.frame)+ yButtonsMargin, wButton, hButton) title:nil imageName:@"Info_Support.png" target:self actcion:@selector(supportEmail)];
	UILabel *supportL = [[UILabel alloc]initWithFrame:CGRectMake(xBMargin-20, CGRectGetMaxY(supportB.frame), wButton+40, hLabel)];
	supportL.text = @"Support";
	facebookB = [UIButton buttonWithFrame:CGRectMake(xBMargin, CGRectGetMaxY(supportL.frame)+ yButtonsMargin, wButton, hButton) title:nil imageName:@"Info_Facebook.png" target:self actcion:@selector(facebook)];
	twitterB = [UIButton buttonWithFrame:CGRectMake(xBMargin, CGRectGetMaxY(facebookB.frame)+ yButtonsMargin, wButton, hButton) title:nil imageName:@"Info_Twitter.png" target:self actcion:@selector(tweetus)];

	
	NSArray *buttons = @[instructionB,aboutB,recommendB,supportB,facebookB,twitterB];
	for (UIButton *b in buttons) {
		b.layer.shadowColor = [UIColor colorWithWhite:0.4 alpha:0.8].CGColor;
		b.layer.shadowOpacity = 1;
		b.layer.shadowOffset = isPad?CGSizeMake(2, 2):CGSizeMake(1, 1);
		b.layer.shadowRadius = 1;
//		b.backgroundColor = [UIColor redColor];
	}
	
	NSArray *labels = @[instructionL,aboutL,recommendL,supportL];
	for (UILabel *l in labels) {
		
		l.textAlignment = NSTextAlignmentCenter;
		l.backgroundColor = [UIColor clearColor];
		l.textColor = [UIColor colorWithRed:0 green:103.0/255 blue:132.0/255 alpha:1];
		l.font = [UIFont fontWithName:kFontName size:isPad?20:10];
		l.shadowColor = [UIColor colorWithWhite:0.6 alpha:0.8];
		l.shadowOffset = CGSizeMake(0, isPad?2:1);
		[self.view addSubview:l];
		
	}
	
	[self.view addSubview:instructionB];

	[self.view addSubview:facebookB];
	[self.view addSubview:supportB];
	[self.view addSubview:recommendB];
	[self.view addSubview:aboutB];

	if (kVersion>=5.0) {
		[self.view addSubview:twitterB];
	}
//
	//---------------- binder right
	
	binder = [[UIImageView alloc]initWithFrame:CGRectMake(0.18*width, 0, isPad?72:30, height)];
	binder.image = [UIImage imageWithContentsOfFileUniversal:@"Info_binder.png"];
	
	NSArray *moreAppNames = @[@"everalbum",@"tinykitchen",@"nsc"];
	NSString *moreAppsPlistPath = [[NSBundle mainBundle] pathForResource:@"MoreApps.plist" ofType:nil];
	NSDictionary *moreAppsDict = [NSDictionary dictionaryWithContentsOfFile:moreAppsPlistPath];
	moreApps = [NSMutableArray array];
	for (NSString *name in moreAppNames) {
		MoreApp *app = [[MoreApp alloc]initWithName:name dictionary:moreAppsDict[name]];
		[moreApps addObject:app];
	}

	CGFloat wRibbon = isPad?25:11;
	ribbon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, wRibbon, wRibbon)];
	ribbon.image = [UIImage imageWithContentsOfFileUniversal:@"Info_selected.png"];

	
	scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.3*width, (isPad?0.05:0.05)*height, 0.7*width, 0.2*height)];
	scrollView.clipsToBounds = YES;
	scrollView.showsHorizontalScrollIndicator = NO;
	
	CGFloat sVMargin = 0.05*scrollView.height;
	CGFloat sButtonWidth = 0.8*scrollView.height;
	CGFloat sHorizontMargin = (scrollView.width-3*sButtonWidth)/5;
	for (int i = 0; i<[moreApps count]; i++) {

		UIButton *b = [UIButton buttonWithFrame:CGRectMake(sHorizontMargin+(sHorizontMargin+sButtonWidth)*i, sVMargin, sButtonWidth, sButtonWidth) title:nil image:nil target:self actcion:@selector(buttonClicked:)];
		[b setImage:[UIImage imageWithContentsOfFileUniversal:[moreApps[i] imgName]] forState:UIControlStateNormal];
		b.tag = i+1;
		b.layer.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.8].CGColor;
		b.layer.shadowOpacity = 1;
		b.layer.shadowOffset = isPad?CGSizeMake(3, 3):CGSizeMake(1, 1);
		b.layer.shadowRadius = 1;
		
		[scrollView addSubview:b];
		[scrollView setContentSize:CGSizeMake(CGRectGetMaxX(b.frame)+200, 0)];
		
		if (i == 0) {
			firstAppB = b;
		}
	}

	//App Description TextView
	otherAppL = [[UILabel alloc]initWithFrame:CGRectMake(0.28*width, CGRectGetMaxY(scrollView.frame)+(isPad?30:14), 0.67*width, 0.1*height)];
	otherAppL.textAlignment = UITextAlignmentCenter;
	otherAppL.backgroundColor = [UIColor colorWithHEX:@"6c675f"];
	otherAppL.font = [UIFont fontWithName:kFontName size:isPad?50:21];
	otherAppL.textColor = [UIColor whiteColor];
	otherAppL.userInteractionEnabled = YES;
	otherAppL.shadowColor = [UIColor colorWithWhite:0 alpha:0.8];
	otherAppL.shadowOffset = CGSizeMake(0, isPad?4:2);

	
	CGFloat dBWidth = isPad?150:75;
	CGFloat dBHeight = isPad?50:25;
	CGFloat yDownloadBMargin = 10*faktor;
	downloadB = [UIButton buttonWithFrame:CGRectMake(CGRectGetMaxX(otherAppL.bounds)-dBWidth-5, yDownloadBMargin, dBWidth, dBHeight) title:nil image:nil target:self actcion:@selector(appstore)];
	[downloadB setImage:[UIImage imageWithContentsOfFileUniversal:@"Icon_AppstoreDownload.png"] forState:UIControlStateNormal];
	downloadB.center = CGPointMake(CGRectGetMaxX(otherAppL.bounds)-dBWidth/2-5 , otherAppL.height/2);
	downloadB.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.8].CGColor;
	downloadB.layer.shadowOpacity = 1;
	downloadB.layer.shadowOffset = isPad?CGSizeMake(2, 2):CGSizeMake(1, 1);
	downloadB.layer.cornerRadius = isPad?5:3;
	downloadB.layer.borderWidth = 2;
	downloadB.layer.borderColor = [UIColor whiteColor].CGColor;
	
	[otherAppL addSubview:downloadB];
	

	textV = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMinX(otherAppL.frame), CGRectGetMaxY(otherAppL.frame), otherAppL.width, 0.54*height)];
	textV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
	textV.textColor = [UIColor colorWithHEX:@"4d4e53"];
	textV.font = [UIFont boldSystemFontOfSize:isPad?22:11];
	textV.editable = NO;
	
	
	
	[self.view addSubview:textV];
	[self.view addSubview:otherAppL];
	[self.view addSubview:scrollView];
	[self.view addSubview:binder];
	[self.view addSubview:backB];
	
	[self buttonClicked:firstAppB];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
//	L();
	
	[super viewDidAppear:animated];
	NSLog(@"instructionB # %@",instructionB);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    
}

- (NSUInteger)supportedInterfaceOrientations{
	//	L();
	return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

#pragma mark - IBAction
- (IBAction)buttonClicked:(id)sender{
	L();
	UIButton *b = sender;
	selectedIndex = [sender tag]-1;
	
	MoreApp *app = moreApps[selectedIndex];

	ribbon.frame = CGRectMake(b.center.x-ribbon.width/2, CGRectGetMaxY(b.frame)-(isPad?5:1), ribbon.width, ribbon.height);

	[scrollView insertSubview:ribbon belowSubview:b];
	
	textV.text = app.description;
	otherAppL.text = app.title;
	[textV setContentOffset:CGPointMake(0, 0)];
}

#pragma mark -
- (void)back{
	
	[root closeInfo];
}

- (void)toInstruction{

	if(!instructionVC){
		instructionVC = [[InstructionViewController alloc]init];
		instructionVC.view.frame = self.view.bounds;
		instructionVC.delegate = self;
	}
	
	[self.view addSubview:instructionVC.view];
}

- (void)closeInstruction:(InstructionViewController *)vc{
	[vc.view removeFromSuperview];
}

- (void)aboutus{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.xappsoft.de/index.php?lang=en"]];
}
- (void)tweetus{
	

	[[ExportController sharedInstance]sendTweetWithText:STwitter image:nil];
}
- (void)facebook{
	

//	[[FBViewController sharedInstance]feed];
	[[FacebookManager sharedInstance]feed];
}
- (void)email{
	
//	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
//						  SRecommendEmailTitle, @"subject",
//						  SRecommendEmailBody,@"emailBody",
//						  nil];
//	
//	[[ExportController sharedInstance] sendEmail:dict];
	
}
- (void)supportEmail{
	
	
	NSDictionary *dict2 = @{
	@"subject": SSupportEmailTitle,
	@"toRecipients": @[@"support@xappsoft.de"]
	};

	[[ExportController sharedInstance] sendEmail:dict2];
}

- (void)appstore{
	MoreApp *app = moreApps[selectedIndex];
	NSString *appid =isPaid()?app.pAppid:app.fAppid;
	
	NSString *urlStr = [NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@&mt=8",appid];
	NSURL *url = [NSURL URLWithString:urlStr];
	[[UIApplication sharedApplication] openURL:url];
}
@end
