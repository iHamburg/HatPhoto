//
//  AdView.h
//  MyeCard
//
//  Created by AppDevelopper on 02.02.13.
//
//

#import <UIKit/UIKit.h>

#import <iAd/iAd.h>
#import "GADBannerView.h"

@protocol AdViewDelegate;


@interface AdView : UIView<GADBannerViewDelegate,ADBannerViewDelegate>{
	
	ADBannerView *_iadView;
	GADBannerView *_gadView;
	
}

@property (nonatomic, unsafe_unretained) id<AdViewDelegate> delegate;

- (BOOL)bannerLoaded;
- (void)setupIAD;
- (void)setupGAD;

@end



@protocol AdViewDelegate <NSObject>

- (void)layoutBanner:(BOOL)loaded;

@end