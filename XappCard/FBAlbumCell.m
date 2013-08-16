//
//  FBAlbumCell.m
//  InstaMagazine
//
//  Created by AppDevelopper on 06.12.12.
//  Copyright (c) 2012 Xappsoft. All rights reserved.
//

#import "FBAlbumCell.h"

@implementation FBAlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//		h = isPad?57:30;
		margin = isPad?5:3;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews{

	[super layoutSubviews];
	
//	L();
//	NSLog(@"cell height # %f",self.height);
	CGFloat h = self.height;
	
    self.imageView.frame = CGRectMake(0,0,h,h);
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	self.textLabel.frame = CGRectMake(h+margin, 0, self.width-h-margin, h);
}

@end
