//
//  ShareViewController.m
//  HatPhoto
//
//  Created by AppDevelopper on 16.01.13.
//
//

#import "ShareViewController.h"
#import "FacebookManager.h"
#import "FXLabel.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

@synthesize img = _img;

- (void)setImg:(UIImage *)img{
    _img = img;
    _imgV.image = [_img imageByScalingAndCroppingForSize:_imgV.bounds.size];
    
}

- (void)loadView{
	
	root = [RootViewController sharedInstance];
	spriteManager = [SpriteManager sharedInstance];
	
	self.view = [[UIView alloc] initWithFrame:root.containerRect];
	self.view.backgroundColor = kLightGrayPatternColor;
	
	self.title = @"Share Photo";
	
    _w = self.view.width;
	_h = self.view.height;
	
	UIView *shareContainer = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 100)];
	shareContainer.backgroundColor = kShareLightGrayColor;
	shareContainer.layer.cornerRadius = 10;
    [shareContainer addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
	[shareContainer applyShadowRasterized:NO];

	
	CGFloat wImgV = 60;
	_imgV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, wImgV, wImgV)];
//	_imgV.backgroundColor = [UIColor redColor];
	_imgV.layer.shadowColor = [UIColor colorWithWhite:0.2 alpha:0.8].CGColor;
	_imgV.layer.shadowOpacity = 1;
	_imgV.layer.shadowOffset = isPad?CGSizeMake(2, 2):CGSizeMake(1, 1);
	
	_captionTextV = [[UITextView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imgV.frame)+10, 0, 210, 90)];
	_captionTextV.backgroundColor = [UIColor clearColor];
    _captionTextV.font = kShareTextFont;
    _captionTextV.text = @"Say something...";
    _captionTextV.delegate = self;
	_captionTextV.textColor = [UIColor colorWithWhite:0.4 alpha:0.8];
    _isTextViewUnused = YES;
    
	[shareContainer addSubview:_imgV];
	[shareContainer addSubview:_captionTextV];
	
	_tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(shareContainer.frame)+5, 300, 300) style:UITableViewStyleGrouped];
	_tableView.dataSource = self;
	_tableView.delegate = self;
	_tableView.scrollEnabled = NO;
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.backgroundView = nil;
	
	UIView *controlV = [[UIView alloc]initWithFrame:self.view.bounds];
	[controlV setBackgroundColor:[UIColor clearColor]];
	[controlV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
	
	[self.view addSubview:controlV];
	[self.view addSubview:shareContainer];
	[self.view addSubview:_tableView];
	
    
	_tableKeys = @[@"Photo Library",@"Email",@"Facebook", @"Twitter",@"Instagram"];
	
	NSArray *tableImgNames = @[@"Info_Photo.png",@"Info_Email.png",@"Info_Facebook.png",@"Info_Twitter.png",@"Info_Instagram.png"];
	_tableImgs = [NSMutableArray array];
	for (NSString *imgName in tableImgNames) {
		UIImage *img = [UIImage imageWithContentsOfFileName:imgName];
		[_tableImgs addObject:[img imageByScalingAndCroppingForSize:CGSizeMake(34, 34)]];
	}
	
	UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
	swipe.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:swipe];
	swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
	swipe.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:swipe];

	
	
}

- (void)viewWillAppear:(BOOL)animated{
	
	[super viewWillAppear:animated];


}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_captionTextV resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_tableKeys count];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	FXLabel *label = [[FXLabel alloc]initWithFrame:CGRectMake(20, 0, 300, 44)];
//	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
	label.text = @"Share";
	label.font = kHatCategoryFont;
	label.textColor = kDarkTextColor;
	label.backgroundColor = [UIColor clearColor];
	label.innerShadowColor = [UIColor colorWithWhite:1 alpha:0.8];
	label.innerShadowOffset = CGSizeMake(0, 1);
	label.shadowColor = [UIColor colorWithWhite:0 alpha:1];
	label.shadowOffset = CGSizeMake(0, 1);
//	label.shadowBlur = 3;
	return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	
	int row = indexPath.row;
	//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (!cell) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.backgroundColor = kShareLightGrayColor;
		cell.textLabel.textColor = kDarkTextColor;
		cell.textLabel.shadowColor = [UIColor colorWithWhite:1 alpha:0.8];
		cell.textLabel.shadowOffset = CGSizeMake(0, 1);
	
	}
    // Configure the cell...
    
	cell.textLabel.text = [_tableKeys objectAtIndex:row];

	cell.imageView.image = _tableImgs[row];
	[cell.imageView applyShadow];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
//    @[@"Save",@"Email",@"Facebook", @"Twitter",@"Instagram"];
    int row = indexPath.row;
    ShareType type;
    if (row == 0) {

        type = ShareToAlbum;
		
    }
    else if(row == 1){

        type = ShareToEmail;
    }
    else if(row == 2){
        type = ShareToFacebook;
    }
    else if(row == 3){
        type = ShareToTwitter;
    }
    else if(row == 4){
        type = ShareInstagram;
    }
    
    [[ExportController sharedInstance]shareImage:_img text:_isTextViewUnused?@" ":_captionTextV.text type:type];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [_captionTextV resignFirstResponder];
}

#pragma mark - TextView
- (void)textViewDidBeginEditing:(UITextView *)textView{

    // 第一次处理placeholder string
    if (_isTextViewUnused) {
        _isTextViewUnused = NO;
        textView.text = nil;
		textView.textColor = kDarkTextColor;
    }
}

#pragma mark - IBAction
- (IBAction)handleTap:(id)sender{
    L();
    [_captionTextV resignFirstResponder];
}



- (IBAction)handleSwipe:(UISwipeGestureRecognizer*)swipe{
	//	L();
	if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
//		NSLog(@"swipe left"); // to share
		
		CATransition *transition = [CATransition animation];
        transition.duration = 0.4;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        transition.delegate = self;
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
		
        [self.navigationController popToRootViewControllerAnimated:NO];

		
	}
	else if(swipe.direction == UISwipeGestureRecognizerDirectionRight){
//		NSLog(@"swipe right"); // back
		
		[self.navigationController popViewControllerAnimated:YES];
		
	}
	
}

#pragma mark - ADView
- (void)layoutBanner:(UIView*)banner loaded:(BOOL)loaded{
	
	[UIView animateWithDuration:0.25 animations:^{
		
		if (loaded) { // 从不显示到显示banner

			[banner setOrigin:CGPointMake(0, _h)];
			
		}
		else{

			[banner setOrigin:CGPointMake(0, _h+_hAdBanner)];
		}
		
    }];
	
	//	NSLog(@"H# %f,hBanner # %f,banner # %@",_h,_hAdBanner,banner);
	
	
}


@end
