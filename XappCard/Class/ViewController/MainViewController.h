//
//  MainViewController.h
//  HatPhoto
//
//  Created by AppDevelopper on 14.01.13.
//
//

#import <UIKit/UIKit.h>
#import "Utilities.h"
#import "IHRootViewController.h"
#import "MyView.h"

@class AVCamViewController;
@class HatCatScrollView, HatScrollView;

@interface MainViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>{
	IHRootViewController *root;
	SpriteManager *spriteManager;
	
	
	UIToolbar *_bottomToolbar;
	UIBarButtonItem *_photoPickerBB, *_shootBB, *_infoBB, *_libraryBB, *_hatBB, *_switchCameraBB, *_hatCategoryBB;
	UIButton *_switchCameraB,*_shootB,*_photoPickerB,*_infoB;
	HatCatScrollView *_categoryScrollView; // cat names
	HatScrollView *_hatScrollView;
	MyView *_controlV;
	AVCamViewController *_avCamVC;
	UIView *_cameraContainer, *_photoContainer;
    UIView *scrollVContainer;
	
	UIActionSheet *_categorySheet;
	
	UILabel *displayL;
	UIImageView *_hatV, *_photoHatV;  // image for hat
	UIImageView *_photoV; // image for photo picker
    UIImageView *_cameraScreenShotV; // for camre screenshot
	
	
	HatCategory *_hatCategory;
	
	CGFloat  _wHatV;
    CGFloat hBottomToolbar;
    CGFloat hScrollView;
}

@property (nonatomic, strong) NSString *hatName;

- (BOOL)isCameraMode;
- (BOOL)isCategoryMode;

- (void)openPhotoPicker;
- (void)closePhotoPicker;



- (void)shoot;
- (void)shake;
- (void)switchCamera;
- (void)toggleHatScrollView;
- (void)applyHat;
- (void)applyCategory;

- (UIImage*)imageWithPhotoImage:(UIImage*)photoImage;


- (void)didSelectedCategory:(HatCategory*)cat;
- (void)didSelectedHatNamed:(NSString*)imgName;

- (void)layoutBanner:(UIView*)banner loaded:(BOOL)loaded;

- (void)test;

@end
