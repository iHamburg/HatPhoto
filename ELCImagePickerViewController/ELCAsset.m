//
//  Asset.m
//
//  Created by Matt Tuzzolo on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAsset.h"
#import "ELCAssetTablePicker.h"
#import "Constant.h"
//#import "PictureWithFrameView.h"

@implementation ELCAsset

@synthesize asset;
@synthesize parent,imageView;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(id)initWithAsset:(ALAsset*)_asset {
	
	if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
		
		self.asset = _asset;
		NSLog(@"location:%@",[_asset valueForProperty:ALAssetPropertyLocation]);
		
		CGRect viewFrames = CGRectMake(0, 0, 75, 75);
		
		UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
		[assetImageView setImage:[UIImage imageWithCGImage:[self.asset thumbnail]]];
		[self addSubview:assetImageView];
		
		overlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		[overlayView setImage:[UIImage imageNamed:@"Overlay.png"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
    }
    
	return self;	
}

- (id)initWithImage:(UIImage*)img{
    if (self = [super initWithFrame:CGRectMake(0, 0, 0, 0)]) {
		
	//	self.asset = _asset;
		
		CGRect viewFrames = CGRectMake(0, 0, 75, 75);
		
		UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
		[assetImageView setImage:[UIImage imageWithCGImage:[self.asset thumbnail]]];
		[self addSubview:assetImageView];
		
		overlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		[overlayView setImage:[UIImage imageNamed:@"Overlay.png"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
    }
    
	return self;	
}

- (id)initWithZettelImage:(UIImage*)img{
    if (self = [super initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)]) {
        CGRect viewFrames = CGRectMake(0, 0, img.size.width, img.size.height);
        UIImageView *assetImageView = [[UIImageView alloc] initWithFrame:viewFrames];
		assetImageView.autoresizingMask = AUTORESIZINGMASK;
		[assetImageView setContentMode:UIViewContentModeScaleToFill];
        assetImageView.userInteractionEnabled = YES;
		[assetImageView setImage:img];
		[self addSubview:assetImageView];
        self.imageView = assetImageView;
		
		overlayView = [[UIImageView alloc] initWithFrame:viewFrames];
		overlayView.autoresizingMask = AUTORESIZINGMASK;
		[overlayView setImage:[UIImage imageNamed:@"OverlayZettel.png"]];
		[overlayView setHidden:YES];
		[self addSubview:overlayView];
    }
    return self;
}

-(void)toggleSelection {
    
   // NSLog(@"toggleSection");
	overlayView.hidden = !overlayView.hidden;
    
    if([(ELCAssetTablePicker*)self.parent totalSelectedAssets] >= 5) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Maximum Reached" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
		[alert show];

        [(ELCAssetTablePicker*)self.parent doneAction:nil];
    }

//	NSURL *url;
//	ALAssetRepresentation *representation = [asset defaultRepresentation];
//	url = representation.url;
//
//	UIImage *img = [UIImage imageWithCGImage:representation.fullScreenImage];
//	PictureWithFrameView *v = [[PictureWithFrameView alloc] initWithImage:img];
//	v.originalSize = img.size;
//	v.url = url;
//	
//	[[NSNotificationCenter defaultCenter] postNotificationName:NotifiAddPicture object:[NSArray arrayWithObject:v]];
}

-(BOOL)selected {
	
	return !overlayView.hidden;
}

-(void)setSelected:(BOOL)_selected {
    
	[overlayView setHidden:!_selected];
}


@end

