//
//  ShareViewController.h
//  HatPhoto
//
//  Created by AppDevelopper on 16.01.13.
//
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "SpriteManager.h"

@interface ShareViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextViewDelegate>{
	RootViewController *root;
	SpriteManager *spriteManager;
	
	UIImageView *_imgV;
	UITextView *_captionTextV;
	UITableView *_tableView;
	
	NSArray *_tableKeys;
	NSMutableArray *_tableImgs;
//	CGFloat _w, _h;
    
    BOOL _isTextViewUnused;
}

@property (nonatomic, strong) UIImage *img;


- (void)layoutBanner:(UIView*)banner loaded:(BOOL)loaded;

@end
