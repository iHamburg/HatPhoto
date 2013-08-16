//
//  HatCatScrollView.m
//  HatPhoto
//
//  Created by AppDevelopper on 14.01.13.
//
//

#import "HatCatScrollView.h"
#import "FXLabel.h"
#import "MyStoreObserver.h"

@implementation HatCatScrollView

@synthesize parent;


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
//		self.backgroundColor = kRedColor;
		
		CGFloat imgW = isPad?50:50;

		CGFloat hMargin = isPad?20:5;
		CGFloat xMargin = 10;
		CGFloat hLabel = isPad?20:18;

		
		NSArray *hatCats = [[SpriteManager sharedInstance]hatCategorys];
		
		for (int i = 0; i<[hatCats count]; i++) {
			
			HatCategory *cat = hatCats[i];
			
			UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(xMargin+ (imgW+xMargin) *i, hMargin, imgW, imgW)];
            imgV.tag = i+1;
            imgV.userInteractionEnabled = YES;
			
            imgV.image = [UIImage imageNamed:cat.thumbImgName];

            [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
			imgV.layer.cornerRadius = isPad?10:5;
			imgV.layer.masksToBounds = YES;

		
			UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgV.frame), isPad?CGRectGetMaxY(imgV.frame):h-hLabel-5, imgW, hLabel)];
            l.textColor = [UIColor whiteColor];
            l.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
			l.font = [UIFont boldSystemFontOfSize:isPad?12:10];
            l.textAlignment = NSTextAlignmentCenter;
            l.text = cat.name;
			
			
            [self addSubview:imgV];
            [self addSubview:l];
			
			self.contentSize = CGSizeMake(CGRectGetMaxX(l.frame)+50, 0);

         

		}
	}
    return self;
}

- (IBAction)handleTap:(UITapGestureRecognizer*)tap{
	L();
	int index = [[tap view]tag]-1;
	
	HatCategory *cat = [[SpriteManager sharedInstance]hatCategorys][index];

	[parent didSelectedCategory:cat];
}


@end
