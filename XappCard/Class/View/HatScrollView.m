//
//  CatScrollView.m
//  HatPhoto
//
//  Created by AppDevelopper on 14.01.13.
//
//

#import "HatScrollView.h"
#import "MyStoreObserver.h"

@implementation HatScrollView

@synthesize parent, category = _category, index = _index;

/**
 
 更新Bord的UI
 */
- (void)setIndex:(int)index{
	
	UIView *oldV = [self viewWithTag:_index+1];
	oldV.layer.borderWidth = 0;
	
	_index = index;
	
	UIView *newV = [self viewWithTag:_index+1];
	newV.layer.borderColor = kRedColor.CGColor;
	newV.layer.borderWidth = 3;
	
}

/**
 
 初始化所有的einheit
 
 */
- (void)setCategory:(HatCategory *)category{
	_category = category;
	
	[self removeAllSubviews];

	[self addSubview:_categoryB];


		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

		@autoreleasepool {
		
			int availableNum = category.availableNum;
			for (int i = 0; i< [_category.hatImgNames count]; i++) {
				
				UIImage * img = [UIImage imageWithContentsOfFileName:[_category imgNameWithIndex:i]];
				img = [img imageByScalingAndCroppingForWidth:45];
				UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(margin+(margin+wImgV)*(i+1), 5, wImgV, wImgV)];
				imgV.contentMode = UIViewContentModeCenter;
				imgV.image = img;
				imgV.userInteractionEnabled = YES;
				[imgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
				imgV.tag = i+1;
				imgV.layer.cornerRadius = 5;
				
				
				if (i>=availableNum) {
					
					UIImageView *lockV = [[UIImageView alloc]initWithFrame:CGRectMake(wImgV-20, 0, 20, 20)];
					lockV.image = [UIImage imageNamed:@"icon_lock.png"];
					[imgV addSubview:lockV];
					
					
				}
				dispatch_async(dispatch_get_main_queue(), ^{
					
					[self addSubview:imgV];
				});
				
				[self setContentSize:CGSizeMake(CGRectGetMaxX(imgV.frame)+120, 0)];
			}
			
		
		}

	});
	
	
}

- (id)initWithFrame:(CGRect)frame parent:(id)_parent{
	parent = _parent;
	return [self initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

		w = self.width;
		h = self.height;
		margin = 20;
		wImgV = 50;
		
		_categoryB = [UIButton buttonWithFrame:CGRectMake(5, 10, 60, 40) title:@"Back" bgImageName:@"EffectButton.png" target:self actcion:@selector(buttonClicked:)];
		_categoryB.titleLabel.font = kHatCategoryFont;
		_categoryB.titleLabel.minimumFontSize = 10;
		_categoryB.titleLabel.numberOfLines = 1;
		[_categoryB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		
		[self addSubview:_categoryB];
	
	}
    return self;
}

- (IBAction)buttonClicked:(id)sender{

	[parent applyCategory];

}

- (IBAction)handleTap:(UITapGestureRecognizer*)tap{
	int index = [[tap view]tag]-1;
	
	if (index>=_category.availableNum) {
		// show iap
		[[MyStoreObserver sharedInstance]showFullVersionAlert];
	}
	else{

		NSString *imgName = [_category imgNameWithIndex:index];
		[parent didSelectedHatNamed:imgName];
		
		self.index = index;
	}
	
	
}


- (NSString*)randomImgName{
	
	int index = arc4random()%[_category.availableImgNames count];
	while (index == _lastIndex) {
		index = arc4random()%[_category.availableImgNames count];
	}
	_lastIndex= index;
	//	NSLog(@"all # %d,randomIndex # %d",[_availableHatImageNames count],index);
	return _category.availableImgNames[index];
}


- (void)scrollToImg:(NSString*)imgName{
	int index = [_category.availableImgNames indexOfObject:imgName];

	if (index>=0 && index<100) {
		UIView *v = [self viewWithTag:index+1];
		self.index = index;
		[self setContentOffset:CGPointMake(v.frame.origin.x-100, 0) animated:YES];
	}
}

@end
