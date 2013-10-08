//
//  Constant.h
//  TheBootic
//
//  Created by AppDevelopper on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//



	

#ifdef PAID  //  paid

	#define kAppID @"601940277"
	#define kApplink @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=601940277&mt=8"

#else   // free



	#define kAppID @"605339875"
	#define kApplink @"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=605339875&mt=8"

#endif


#define kAppName @"ShakeHat"
#define kAppShortLink @"bit.ly/XiMF52"
#define kIAPFullVersion @"de.xappsoft.shakehatfree.fullversion"

#pragma mark - UI

#define kPhotoBorderColor [UIColor colorWithRed:39.0/255 green:41.0/255 blue:44.0/255 alpha:1]
#define kDarkTextColor [UIColor colorWithRed:50.0/255 green:50.0/255 blue:50.0/255 alpha:1]
#define kDarkGreenColor [UIColor colorWithRed:107.0/255 green:154.0/255 blue:50.0/255 alpha:1]
#define kShareLightGrayColor [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]

#define kLightBlueColor [UIColor colorWithRed:126.0/255 green:157.0/255 blue:181.0/255 alpha:1]
#define kBlueColor [UIColor colorWithRed:46.0/255 green:96.0/255 blue:135.0/255 alpha:1]
#define kGreenColor [UIColor colorWithRed:155.0/255 green:196.0/255 blue:64.0/255 alpha:1]
#define kRedColor   [UIColor colorWithRed:220.0/255 green:70.0/255 blue:0.0/255 alpha:1]
#define kDarkPatternColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkBGPattern2.png"]]
#define kLightGrayPatternColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"LighGrayPattern.png"]]



#define kHatCategoryFont [UIFont fontWithName:@"Archive" size:18]
#define kShareTextFont [UIFont systemFontOfSize:18]

#define kPlaceholderImage [UIImage imageNamed:@"placeholder.jpg"]



#define kWPhoto 320
#define kHPhoto 320

#define kUniversalFaktor isPad?1:2

#define kSize960 isPad?CGSizeMake(960,640):CGSizeMake(480,320)
#define kUIContainerFrame isPad?CGRectMake(0,0,960,640):CGRectMake(0,0,480,320)

#define ROOTZETTELFRAME isPad?CGRectMake(0,0,480,500):CGRectMake(0,0,480,276)
#define ROOTTEXTLABELFRAME CGRectMake(0,0,480,276)

#define PNGKARTEFRAME CGRectMake(0,0,960,1280)
#define PNGCOVERFRAME CGRectMake(0,0,960,640)
#define PNGCOVERSIZE  CGSizeMake(960,640)



#define CORNERRADIUS 20


#define PopPhotoWidth isPad?320:600
#define PopPhotoHeight isPad?500:500

#define POPCoverPhotoWidth isPad?320:600



#pragma mark - Others

#define kVersion [[[UIDevice currentDevice] systemVersion] floatValue]

#define AUTORESIZINGMASK UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin

#define kKeyFirstOpen @"firstOpen"
#define kKeyUpdate    @"update"
#define kKeyBundleVersion @"bundleVersion"

#define kJPEGCompressionQuality 0.8

#define isIOS7 (kVersion >= 7.0)



typedef enum{
    ST_Cover,
    ST_Content
    
} ScreenshotType;

typedef enum{
    RSCover,
    RSContent,
    RSPreview
}RootStatus;

typedef enum {
	RAF_None,
	RAF_Action,
	RAF_Image
}RootActionFlag;

typedef enum{
    RPSCover,
    RPSProfile,
    RPSContent
} RootPhotoSource;

typedef enum {
	MA_Lock,
	MA_Unlock,
	MA_SetBG,
	MA_Edit
} MenuAction;

typedef enum{
	RootModeChoose,
	RootModeCover,
	RootModeContent,
	RootModeCards,
	RootModeCardsDate
}RootMode;

typedef enum{
	AppVersionPaid,
	AppVersionIAP,
	AppVersionFree
}AppVersion;


typedef enum{
	PS_None,
	PS_Text,
	PS_TextLabel,
	PS_Image,
	PS_OneImage,
	PS_Zettel,
	PS_Sticker,
	PS_Love,
	PS_Setting,
	PS_Info,
	PS_Action,
	PS_Cards,
	PS_SendLater,
	RootVCStatusRateAlert,
	RootVCStatusNewCardAlert
} PopOverStatus;

typedef enum{
	ToolbarTagAdd,
	ToolbarTagSwitch,
	ToolbarTagCoverPhoto,
	ToolbarTagCoverText,
	ToolbarTagChooseCover,
	ToolbarTagInfo,
	ToolbarTagContentPhoto,
	ToolbarTagContentText,
	ToolbarTagZettel,
	ToolbarTagLove,
	ToolbarTagAction,
	ToolbarTagSetting,
	
}ToolbarTag;
