//
//  FrameScrollView.m
//  HatPhoto
//
//  Created by AppDevelopper on 19.01.13.
//
//

#import "FrameScrollView.h"
#import "Utilities.h"

@implementation FrameScrollView

@synthesize viewDelegate, frames, imageIndex = _imageIndex;

- (void)setImageIndex:(int)imageIndex{


	UIView *oldV = [self viewWithTag:_imageIndex+1];
	oldV.layer.borderWidth = 0;
	_imageIndex = imageIndex;
	
	UIView *newV = [self viewWithTag:_imageIndex+1];
	newV.layer.borderColor = kRedColor.CGColor;
	newV.layer.borderWidth = 3;
	

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

		
		w = frame.size.width;
		h = frame.size.height;
		
        CGFloat imgW = isPad?50:50;
        CGFloat margin = isPad?20:10;
		CGFloat hMargin = isPad?20:10;

		self.showsHorizontalScrollIndicator = NO;
		
		NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"frame" ofType:@"plist"];
		NSArray *frameArray = [NSArray arrayWithContentsOfFile:plistPath];
		frames = [NSMutableArray array];
		for (NSString *imgName in frameArray) {
			Frame *frame = [[Frame alloc]init];
			frame.imgName = imgName;
			[frames addObject:frame];
		}
		
		
        imgVs = [NSMutableArray array];
        for (int i = 0; i<[frames count]  ; i++) {

			Frame *frame = frames[i];
			UIImage *frameThumb = [UIImage imageWithContentsOfFileName:frame.imgName];
		

			
            UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(margin+ (imgW+margin) *i, hMargin, imgW, imgW)];
            imgV.tag = i+1;
            imgV.userInteractionEnabled = YES;
			imgV.backgroundColor = [UIColor blackColor];
			imgV.contentMode = UIViewContentModeCenter;
            [imgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)]];
			imgV.layer.cornerRadius = 5;
			imgV.layer.masksToBounds = YES;
			imgV.image = [frameThumb imageByScalingAndCroppingForWidth:45];
            [imgVs addObject:imgV];
            

            [self addSubview:imgV];

        }
        
        self.contentSize = CGSizeMake((imgW+margin)*([imgVs count]+1), 0);
   	
		[self applyShadowBorder:kCALayerTopEdge withColor:[UIColor blackColor] indent:5];

    }
    return self;
}



- (void)handleTap:(UITapGestureRecognizer*)tap{
    
    UIView *v = [tap view];
	
    
    int index = v.tag - 1;
  	Frame *frame = frames[index];
	[viewDelegate frameScrollViewDidSelectedFrame:frame];

	
	self.imageIndex = index;

}


- (void)selectRandom{
	
	int randomIndex = arc4random()%[frames count];
	while (randomIndex == _imageIndex) {
		randomIndex = arc4random()%[frames count];
		
	}
	
	
	[viewDelegate frameScrollViewDidSelectedFrame:frames[randomIndex]];
	
	self.imageIndex = randomIndex;
	
	UIView *v = [self viewWithTag:randomIndex+1];
	[self setContentOffset:CGPointMake(v.frame.origin.x-100, 0) animated:YES];
	
	
}

@end
