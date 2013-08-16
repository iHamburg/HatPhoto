//
//  Macros.h
//  XappSoft
//
//  Created by Xapp on 27.05.11.
//  Copyright 2011 Xappsoft. All rights reserved.
//

#define LString(x) NSLocalizedString(x, nil)

#define GetFullPath(_filePath_) [[NSBundle mainBundle] pathForResource:[_filePath_ lastPathComponent] ofType:nil inDirectory:[_filePath_ stringByDeletingLastPathComponent]]

#define ISEMPTY(x)	((x) == nil ||[(x) isKindOfClass:[NSNull class]] ||([(x) isKindOfClass:[NSString class]] &&  [(NSString*)(x) length] == 0) || ([(x) isKindOfClass:[NSArray class]] && [(NSArray*)(x) count] == 0)|| ([(x) isKindOfClass:[NSDictionary class]] && [(NSDictionary*)(x) count] == 0))
#define kAutoResize (UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin)

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isPhone  (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
#define isPhoneRetina4 ([UIDevice resolution] == UIDeviceResolution_iPhoneRetina4)

#define isIAPFullVersion ([[NSUserDefaults standardUserDefaults] boolForKey:kIAPFullVersion])
//#define isIAPFullVersion (YES)




#define isRetina [[UIScreen mainScreen] scale] != 1.0f
#define kRetinaPadScale (isPad&&isRetina)?2.0f:1.0f

#define isLandscape [UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft||[UIDevice currentDevice].orientation==UIInterfaceOrientationLandscapeRight

#define isPortrait [UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown||[UIDevice currentDevice].orientation==UIDeviceOrientationPortrait

#define NEVERSHOWPHOTOALARM 0

#define ROUND(x)	(round((x)*10)/10.0)

#define DEG_TO_RAD(x)	((x)/180.0f*M_PI)
#define degreesToRadians(x) ((x)/180.0f*M_PI)

#define TRANSFORM(degree) CGAffineTransformMakeRotation(M_PI*(degree)/180.0)

#pragma mark -
#pragma mark UIViewTable

#define kSectionFactor	10
#define CELLINDEX(indexPath) (indexPath.section*kSectionFactor + indexPath.row)

#pragma mark -
#pragma mark Log

#define LOG_RETAIN(x)	NSLog(@"retainCount = %d", [(x) retainCount])

#ifdef DEBUG
#define DebugLog(...)	NSLog(__VA_ARGS__)
#define DLog(...) NSLog(__VA_ARGS__)
#define DDLog(x) NSLog(@"%s %@",__FUNCTION__,x)
#define LocLog() NSLog(@"%s",__FUNCTION__)
#define LocLogEnd() NSLog(@"%s End",__FUNCTION__)
#define L() NSLog(@"%s",__FUNCTION__)
#define M(x) NSLog(@"%s,%@",__FUNCTION__,x)
#else
#define DebugLog(...)
#define DLog(...)
#define DDLog(...)
#define LocLog()
#define LocLogEnd()
#define L() 
#define M(x)
#endif

#define LView(x) NSLog(@"%@,bounds:%@,center:%@",x,NSStringFromCGRect(x.bounds),NSStringFromCGPoint(x.center));


#pragma mark -
#pragma mark Misc

#define kNewLine @"\r\n"

