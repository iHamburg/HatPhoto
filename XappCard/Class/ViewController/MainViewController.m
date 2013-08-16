//
//  MainViewController.m
//  HatPhoto
//
//  Created by AppDevelopper on 14.01.13.
//
//

#import "MainViewController.h"
#import "AVCamViewController.h"
#import "HatCatScrollView.h"
#import "HatScrollView.h"
#import "EffectViewController.h"
#import "UIResponder+MotionRecognizers.h"
#import "FXLabel.h"

@interface MainViewController ()


@end

@implementation MainViewController

@synthesize hatName;

- (void)loadView{
	root = [RootViewController sharedInstance];
	spriteManager = [SpriteManager sharedInstance];
	
	self.view = [[UIView alloc]initWithFrame:root.containerRect];
	_w = self.view.width;
	_h = self.view.height; // 436/524
	_wHatV = 300;
	
	
	self.view.backgroundColor = kDarkPatternColor;
	self.title = kAppName;

	_switchCameraB = [UIButton buttonWithFrame:CGRectMake(0, 0, 48, 30) title:nil image:[UIImage imageNamed:@"Icon_ToggleCamera.png"] target:self actcion:@selector(toolbarButtonClicked:)];
	_switchCameraBB = [[UIBarButtonItem alloc]initWithCustomView:_switchCameraB];
	self.navigationItem.rightBarButtonItem = _switchCameraBB;

	_hatCategoryBB = [[UIBarButtonItem alloc]initWithTitle:@"Category" style:UIBarButtonItemStyleBordered target:self action:@selector(toolbarButtonClicked:)];
	self.navigationItem.leftBarButtonItem = _hatCategoryBB;
	
	CGFloat hTopToolbar = 44;
	_topToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, _w, hTopToolbar)];
	_topToolbar.barStyle = UIBarStyleBlack;
	
	CGFloat hBottomToolbar = isPhoneRetina4?50:44;
	_bottomToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, _h-hBottomToolbar, _w, hBottomToolbar)];
	_bottomToolbar.barStyle = UIBarStyleBlack;


	_photoPickerB = [UIButton buttonWithFrame:CGRectMake(0, 0, 32, 32) title:nil image:[UIImage imageNamed:@"Icon_PhotoLibrary.png"] target:self actcion:@selector(toolbarButtonClicked:)];
	_photoPickerBB = [[UIBarButtonItem alloc]initWithCustomView:_photoPickerB];
	
//	_libraryBB =[[UIBarButtonItem alloc]initWithTitle:@"Library" style:UIBarButtonItemStylePlain target:self action:@selector(toolbarButtonClicked:)];
	

	_shootB = [UIButton buttonWithFrame:CGRectMake(0, 0, 80, 40) title:nil image:[UIImage imageNamed:@"Icon_CameraShoot.png"] target:self actcion:@selector(toolbarButtonClicked:)];
	_shootBB = [[UIBarButtonItem alloc]initWithCustomView:_shootB];
	
	_infoB = [UIButton buttonWithType:UIButtonTypeInfoLight];
	_infoB.frame = CGRectMake(0, 0, 25, 25);
	[_infoB addTarget:self action:@selector(toolbarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	
	_infoBB = [[UIBarButtonItem alloc]initWithCustomView:_infoB];
	
	UIBarButtonItem *flexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	NSArray *items = @[_photoPickerBB,flexible,_shootBB,flexible,_infoBB];
	_bottomToolbar.items = items;

	CGFloat yPhotoContainer = isPhoneRetina4?44:0;

    // Photo
	_photoContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yPhotoContainer, 320, 320)];
    _photoContainer.layer.borderColor = kPhotoBorderColor.CGColor;
	_photoContainer.layer.borderWidth = 5;
	_photoContainer.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.8].CGColor;
	_photoContainer.layer.shadowOpacity = 1;
	_photoContainer.layer.shadowOffset = isPad?CGSizeMake(2, 2):CGSizeMake(0, 2);
	_photoContainer.layer.shadowPath = [UIBezierPath bezierPathWithRect:_photoContainer.bounds].CGPath;

    _photoV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _w, 320)];
	_photoV.contentMode = UIViewContentModeScaleAspectFit;
	_photoV.backgroundColor = [UIColor blackColor];

    
    _photoHatV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _wHatV, _wHatV)];
    _photoHatV.userInteractionEnabled = YES;
    
    [_photoContainer addSubview:_photoV];
    [_photoContainer addSubview:_photoHatV];
    
    
    //Camera
    _cameraContainer = [[UIView alloc]initWithFrame:CGRectMake(0, yPhotoContainer, 320, 320)];
    
    _avCamVC = [[AVCamViewController alloc]initWithNibName:@"AVCamViewController" bundle:nil];

    _cameraScreenShotV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
    _cameraScreenShotV.layer.borderColor = kPhotoBorderColor.CGColor;
	_cameraScreenShotV.layer.borderWidth = 5;
	_cameraScreenShotV.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.8].CGColor;
	_cameraScreenShotV.layer.shadowOpacity = 1;
	_cameraScreenShotV.layer.shadowOffset = isPad?CGSizeMake(2, 2):CGSizeMake(0, 2);
	
	
	_hatV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _wHatV, _wHatV)];
	_hatV.userInteractionEnabled = YES;
	

    [_cameraContainer addSubview:_avCamVC.view];
    [_cameraContainer addSubview:_cameraScreenShotV];
    [_cameraContainer addSubview:_hatV];
    

     _controlV = [[MyView alloc]initWithFrame:CGRectZero];
	[_controlV addGestureRecognizersToPiece:_hatV];
    [_controlV addGestureRecognizersToPiece:_photoHatV];
	
	_categoryScrollView = [[HatCatScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(_bottomToolbar.frame)-60, _w, 60) parent:self];
	
	_hatScrollView = [[HatScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(_bottomToolbar.frame)-60, _w, 60) parent:self];
	_hatScrollView.hidden = YES;
    

	
    [self.view addSubview:_photoContainer];
	[self.view addSubview:_cameraContainer];
    [self.view addSubview:_controlV];
	
	
	[self.view addSubview:_categoryScrollView];
    [self.view addSubview:_hatScrollView];
	
	[self.view addSubview:_bottomToolbar];

    [self shake];
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];

    
    //取消上次拍摄的screenshot
	
	[self addMotionRecognizerWithAction:@selector(motionWasRecognized:)];
    
	_cameraScreenShotV.image = nil;
	
}

- (void)viewDidAppear:(BOOL)animated{
	
	
	[super viewDidAppear:animated];
	
	[self test];
}

- (void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];
	
	[self removeMotionRecognizer];

}


#pragma mark - IBAction


- (IBAction)toolbarButtonClicked:(id)sender{
	
	if (sender == _photoPickerB) {
		[self openPhotoPicker];
	}
	else if(sender == _switchCameraBB || sender == _switchCameraB){
		[self switchCamera];
	}
	else if(sender == _shootB){
		[self shoot];
	}
	else if(sender == _hatBB){
		[self toggleHatScrollView];
	}
	else if(sender == _infoBB || sender == _infoB){
		[root toInfo];
	}
	else if(sender == _hatCategoryBB){
		
//		[_categorySheet showInView:self.view];
		[self applyCategory];
	}
	
}



#pragma mark - ImagePicker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//	NSURL *url = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
	UIImage *originalImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
	UIImage *editedImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];

	UIImage *image = ISEMPTY(originalImage)?editedImage:originalImage;
//	NSLog(@"image # %@, scale # %f",NSStringFromCGSize(image.size),image.scale);
	_photoV.image = image;
    
    _cameraContainer.hidden = YES;
    
	[self closePhotoPicker];
	
	self.hatName = @"PhotoLibrary";
	
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	
    _cameraContainer.hidden = NO;
    
	[self closePhotoPicker];
}

#pragma mark - Motion (Shake)

- (void) motionWasRecognized:(NSNotification*)notif{
	[[AudioController sharedInstance]playAudio:AudioTypeShake];
	
	[self shake];
	
}

#pragma mark - Navigation



- (void)openPhotoPicker{
	UIImagePickerController *imgPicker = root.imgPicker;
	imgPicker.delegate = self;
	imgPicker.allowsEditing = YES;
	
	[root presentModalViewController:imgPicker animated:YES];
	
}
- (void)closePhotoPicker{
	[root dismissModalViewControllerAnimated:YES];
}

#pragma mark -


- (BOOL)isCameraMode{
    return !_cameraContainer.hidden;
}

- (BOOL)isCategoryMode{
	return !_categoryScrollView.hidden;
}

/**
 如果是library就 root
 */
- (void)shoot{
	
	if (!self.isCameraMode) { // 如果是library

		[root toEffectVCWithImage:[self imageWithPhotoImage:_photoV.image]];
	}
	else{ // camera
		

		
		[_avCamVC captureStillImage:nil];
		[_avCamVC stopSesseion];
		
		// 重新启动session
		[_avCamVC performSelector:@selector(startSesseion) withObject:nil afterDelay:2];
	}
	


}

- (void)shake{
	
	if (self.isCategoryMode) {
		[self didSelectedCategory:spriteManager.hatCategorys[0]];
	}
	
	
	NSString *randomImageName = [_hatScrollView randomImgName];
	
	[self didSelectedHatNamed:randomImageName];
	
	[_hatScrollView scrollToImg:randomImageName];
	
}
- (void)switchCamera{
	
	[_avCamVC toggleCamera:nil];
    
    _cameraContainer.hidden = NO;
	
}


- (void)didSelectedCategory:(HatCategory*)cat{
	_hatCategory = cat;
	_hatScrollView.category = _hatCategory;
	
	
	_categoryScrollView.hidden = YES;
    _hatScrollView.hidden = NO;

}

- (void)didSelectedHatNamed:(NSString*)imgName{
	
	self.hatName = imgName;
	
	UIImage *img = [UIImage imageWithContentsOfFileUniversal:imgName];
	
	UIImageView *hatV ;
	if (self.isCameraMode) {
		
		hatV = _hatV;
		
	}
	else{
		hatV = _photoHatV;

		
    }
	
	[hatV resetAnchorPoint];
	
	hatV.transform = CGAffineTransformIdentity;
	hatV.image = img;
	[hatV setSize:CGSizeMake(img.size.width/2, img.size.height/2)];
	
	hatV.center = CGPointMake(160, hatV.height/2);
	
	
	displayL.text = imgName;

}


- (void)toggleHatScrollView{
	
	_hatScrollView.hidden = !_hatScrollView.hidden;
	_categoryScrollView.hidden = !_categoryScrollView.hidden;
	
}


- (void)applyHat{
	_hatScrollView.hidden = NO;
	_categoryScrollView.hidden = YES;
}
- (void)applyCategory{
	
	_hatScrollView.hidden = YES;
	_categoryScrollView.hidden = NO;
}

/**
 
 photoImage Size: 480x640/720x1280/n(n<640)*640/640*n
 
 return imageSize: 480x480/720x720/640x640/640x640
 */
- (UIImage*)imageWithPhotoImage:(UIImage*)photoImage{
	UIImage *img;
	if (!self.isCameraMode) { // 如果是library
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320),NO,0);

        [_photoContainer.layer renderInContext:UIGraphicsGetCurrentContext()];
		
		img = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();

	}
	else{ // camera
		
		// _camV显示的不是0，0，320，320？

		CGFloat wCameraPhoto = photoImage.size.width;
		CGFloat hCameraPhoto = photoImage.size.height;

		
		CGRect cropRect = CGRectMake((hCameraPhoto-wCameraPhoto)/2, 0, wCameraPhoto, wCameraPhoto);

		CGImageRef imageRef= CGImageCreateWithImageInRect([photoImage CGImage], cropRect);
		
		UIImage *croppedPhoto;
		if (photoImage.size.width < 640) { // 480x480, 前置摄像头
						
			croppedPhoto= [UIImage imageWithCGImage:imageRef scale:2 orientation:UIImageOrientationLeftMirrored];
			
		}
		else{ // 720, 后置
			
			croppedPhoto= [UIImage imageWithCGImage:imageRef scale:2 orientation:UIImageOrientationRight];
		}
		
        
        _cameraScreenShotV.image = croppedPhoto;
		
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 320),NO,0);
        
		[_cameraContainer.layer renderInContext:UIGraphicsGetCurrentContext()];
		
		img = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();

    }
	
	return img;
}



#pragma mark - ADView

- (void)layoutBanner:(UIView*)banner loaded:(BOOL)loaded{
	
	[UIView animateWithDuration:0.25 animations:^{
		
		if (loaded) { // 从不显示到显示banner
			[_bottomToolbar setOrigin:CGPointMake(0, _h-_bottomToolbar.height-50)];
			[_categoryScrollView setOrigin:CGPointMake(0, _h-_bottomToolbar.height-_categoryScrollView.height -50)];
			[_hatScrollView setOrigin:CGPointMake(0, _h-_bottomToolbar.height-_hatScrollView.height -50)];
			[banner setOrigin:CGPointMake(0, _h)];
			
		}
		else{
			[_bottomToolbar setOrigin:CGPointMake(0, _h-_bottomToolbar.height)];
			[_categoryScrollView setOrigin:CGPointMake(0, _h-_bottomToolbar.height-_categoryScrollView.height)];
			[_hatScrollView setOrigin:CGPointMake(0, _h-_bottomToolbar.height-_hatScrollView.height)];
			[banner setOrigin:CGPointMake(0, _h+_hAdBanner)];
		}
		
    }];

	
//	NSLog(@"H# %f,hBanner # %f,banner # %@",_h,_hAdBanner,banner);
	
	
}


#pragma mark - Test
- (void)test{
	
//	UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 320)];
////	imgV.image = [UIImage imageNamed:@"Hat_Valentine_1.png"];
////	imgV.image = [UIImage imageNamed:@"Normal.png"];
//	[self.view addSubview:imgV];

}

@end
