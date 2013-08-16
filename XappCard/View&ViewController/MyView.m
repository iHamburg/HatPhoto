/*
    File: MyView.m
Abstract: MyView several subviews, each of which can be moved by gestures. Illustrates handling gesture events, incluing multiple gestures.
 Version: 1.13



 */


#import "MyView.h"

//#import "PictureWithFrameView.h"
//#import "CardEditView.h"
#import "TextWidget.h"

@interface MyView ()

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer*)gesture;
//- (void)copyPiece:(UIView*)piece;
//- (void)editTextLabelView:(UIView*)v;

@end

@implementation MyView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
	}
	
	return self;
}

- (void)awakeFromNib
{
    L();
	self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
	
}


#pragma mark -
#pragma mark === Setting up and tearing down ===
#pragma mark

/**
 
 如果piece已经有gesture了，就不重复加了！
 */

// adds a set of gesture recognizers to one of our piece subviews
- (void)addGestureRecognizersToPiece:(UIView *)piece
{
	
	if (!ISEMPTY(piece.gestureRecognizers)) {
		return;
	}
	
//	L();
	
	UIRotationGestureRecognizer* rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    
	UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
  	
	
	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [tapGesture setNumberOfTapsRequired:2];
    
	UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tap setNumberOfTapsRequired:1];
    
	UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
  	
	UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showLock:)];
	

        

	[piece addGestureRecognizer:rotationGesture];
	
	[piece addGestureRecognizer:pinchGesture];
	
	
	[piece addGestureRecognizer:tapGesture];
	
	[piece addGestureRecognizer:tap];
	
	[piece addGestureRecognizer:panGesture];
	
	[piece addGestureRecognizer:longPressGesture];

    
}

- (void)addGestureRecognizersToMaskPhoto:(UIView*)piece{
	if (!ISEMPTY(piece.gestureRecognizers)) {
		return;
	}
	
	
	UIRotationGestureRecognizer* rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
    
	UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
  	
	
	UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [tapGesture setNumberOfTapsRequired:2];
    
	UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tap setNumberOfTapsRequired:1];
    
	UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
  	
//	UILongPressGestureRecognizer* longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showLock:)];
	
	
	
	
	[piece addGestureRecognizer:rotationGesture];
	
	[piece addGestureRecognizer:pinchGesture];
	
	
	[piece addGestureRecognizer:tapGesture];
	
	[piece addGestureRecognizer:tap];
	
	[piece addGestureRecognizer:panGesture];
	
//	[piece addGestureRecognizer:longPressGesture];
}




#pragma mark -  === Utility methods  ===
// scale and rotation transforms are applied relative to the layer's anchor point
// this method moves a gesture recognizer's view's anchor point between the user's fingers
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
   
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
      //  NSLog(@"anchorPoint:%@,center:%@",NSStringFromCGPoint(piece.layer.anchorPoint),NSStringFromCGPoint(piece.center));
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
		
		
    }
}

// display a menu with a single item to allow the piece's transform to be reset
- (void)showResetMenu:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *resetMenuItem = [[UIMenuItem alloc] initWithTitle:@"Reset" action:@selector(resetPiece:)];
        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        
        [self becomeFirstResponder];
        [menuController setMenuItems:[NSArray arrayWithObject:resetMenuItem]];
        [menuController setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[gestureRecognizer view]];
        [menuController setMenuVisible:YES animated:YES];
        
//        selectedPiece = (CardEditView*)[gestureRecognizer view];
        
    }
}

- (void)showLock:(UILongPressGestureRecognizer *)gestureRecognizer{
	if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
			
//        UIMenuController *menuController = [UIMenuController sharedMenuController];
		
		
//        CGPoint location = [gestureRecognizer locationInView:[gestureRecognizer view]];
        
//        [self becomeFirstResponder];

//		selectedPiece = [gestureRecognizer view];
//		NSArray *menuItems;
//		if ([selectedPiece isKindOfClass:[CardEditView class]]) {
//			menuItems = [(CardEditView*)selectedPiece menuArray ];
//		}
//		else if([selectedPiece isKindOfClass:[TextWidget class]]){
//			menuItems = [(TextWidget*)selectedPiece menuItems];
//		}
//
//		NSLog(@"menuItems # %@,location # %@,view # %@",menuItems,NSStringFromCGPoint(location),selectedPiece);
//		
//		[menuController setMenuItems:menuItems];
//        [menuController setTargetRect:CGRectMake(location.x, location.y, 0, 0) inView:[gestureRecognizer view]];
//        [menuController setMenuVisible:YES animated:YES];
//        
    }
}

// animate back to the default anchor point and transform
- (void)resetPiece:(UIMenuController *)controller
{
    CGPoint locationInSuperview = [selectedPiece convertPoint:CGPointMake(CGRectGetMidX(selectedPiece.bounds), CGRectGetMidY(selectedPiece.bounds)) toView:[selectedPiece superview]];
    
    [[selectedPiece layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
    [selectedPiece setCenter:locationInSuperview];
    
    [UIView beginAnimations:nil context:nil];
    [selectedPiece setTransform:CGAffineTransformIdentity];
    [UIView commitAnimations];
}



// UIMenuController requires that we can become first responder or it won't display
- (BOOL)canBecomeFirstResponder
{
    return YES;
	
}

#pragma mark -
#pragma mark === Touch handling  ===
#pragma mark


// shift the piece's center by the pan amount
// reset the gesture recognizer's translation to {0, 0} after applying so the next callback is a delta from the current position
- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
//	L();
	// if it go to far, delete it
	if ([delegate respondsToSelector:@selector(willPanPiece:inView:)]) {
		[delegate willPanPiece:gestureRecognizer inView:self];
	}
   


	UIView *piece = [gestureRecognizer view];

	// 当移动piece时alpha ＝ 0.7
	if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
		piece.alpha = 0.7;
	}
	else {
		piece.alpha = 1;
	}
	
	
	[self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
	

    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
        
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
     

//	[self addSubview:piece];
	
  }

// rotate the piece by the current rotation
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current rotation
- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{


    if ([delegate respondsToSelector:@selector(willRotatePiece:inView:)]) {
		[delegate willRotatePiece:gestureRecognizer inView:self];
	}
	
	UIView *piece = [gestureRecognizer view];
//	if ([piece isKindOfClass:[CardEditView class]]) {
//		if ([(CardEditView*)piece locked]) {
//			return;
//		}
//	}
//	else if([piece isKindOfClass:[TextWidget class]]){
//		if ([(TextWidget*)piece lockFlag]) {
//			return;
//		};
//	}

	
	if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
		piece.alpha = 0.7;
	}
	else {
		piece.alpha = 1;
	}
	
	[self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
		
	
        [gestureRecognizer view].transform = CGAffineTransformRotate([[gestureRecognizer view] transform], [gestureRecognizer rotation]);
        [gestureRecognizer setRotation:0];

    }
    
    
}

// scale the piece by the current scale
// reset the gesture recognizer's rotation to 0 after applying so the next callback is a delta from the current scale
- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{


	if ([delegate respondsToSelector:@selector(willScalePiece:inView:)]) {
		[delegate willScalePiece:gestureRecognizer inView:self];
	}
    
	UIView *piece = [gestureRecognizer view];
//	if ([piece isKindOfClass:[CardEditView class]]) {
//		if ([(CardEditView*)piece locked]) {
//			return;
//		}
//	}
//	else if([piece isKindOfClass:[TextWidget class]]){
//		if ([(TextWidget*)piece lockFlag]) {
//			return;
//		};
//	}

	
	if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
		piece.alpha = 0.7;
	}
	else {
		piece.alpha = 1;
	}
	
	[self adjustAnchorPointForGestureRecognizer:gestureRecognizer];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {


		if ([piece isKindOfClass:[TextWidget class]]) {
			
			float scale = gestureRecognizer.scale;
			
			[gestureRecognizer setScale:1];
			
			[(TextWidget*)piece applyScale:scale];
			
		}
		else{
			[gestureRecognizer view].transform = CGAffineTransformScale([[gestureRecognizer view] transform], [gestureRecognizer scale], [gestureRecognizer scale]);
			[gestureRecognizer setScale:1];
			
		}
    }
}

- (void)handleTap:(UITapGestureRecognizer*)gesture{
	L();
}

- (void)handleDoubleTap:(UITapGestureRecognizer*)gesture{
    L();
//	UIView *piece = [gesture view];
	
//	if ([piece isKindOfClass:[CardEditView class]]) {
//		if ([(CardEditView*)piece locked]) {
//			return;
//		}
//	}
//	else if([piece isKindOfClass:[TextWidget class]]){
//		if ([(TextWidget*)piece lockFlag]) {
//			return;
//		};
//	}
//
	
//    UIView *v = [gesture view];
//	if ([v isKindOfClass:[PictureWithFrameView class]]) {  
//		 [self copyPiece: v];
//	}
	
}


// ensure that the pinch, pan and rotate gesture recognizers on a particular view can all recognize simultaneously
// prevent other gesture recognizers from recognizing simultaneously
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    // if the gesture recognizers's view isn't one of our pieces, don't allow simultaneous recognition
//    if (gestureRecognizer.view != firstPieceView && gestureRecognizer.view != secondPieceView && gestureRecognizer.view != thirdPieceView)
//        return NO;
//    
    // if the gesture recognizers are on different views, don't allow simultaneous recognition
    if (gestureRecognizer.view != otherGestureRecognizer.view)
        return NO;  
    
    // if either of the gesture recognizers is the long press, don't allow simultaneous recognition
    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]] || [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        return NO;
    
    return YES;
}



//
//
//- (void)editTextLabelView:(UIView*)v{
//
//	
//	[[NSNotificationCenter defaultCenter]
//	 postNotificationName:NotifiRootOpenTextLabelVC object:[NSArray arrayWithObject:v]];	
//
//}

#pragma mark - Menu

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{


	
    if (action == @selector(menuLockPiece:) || action == @selector(menuUnlockPiece:)|| action == @selector(menuEditPiece:) ||
        action == @selector(menuCropPiece:))
        
        return YES;

    return [super canPerformAction:action withSender:sender];
	
	
}
- (void)lockPiece:(UIMenuController *)controller{

	
	if ([delegate respondsToSelector:@selector(handleMenuAction:withPiece:)])
		[delegate handleMenuAction:MA_Lock withPiece:selectedPiece];
}

- (void)unlockPiece:(UIMenuController *)controller{

	if ([delegate respondsToSelector:@selector(handleMenuAction:withPiece:)])
		[delegate handleMenuAction:MA_Unlock withPiece:selectedPiece];

}

- (void)setBackground:(UIMenuController *)controller{
	L();

	if ([delegate respondsToSelector:@selector(handleMenuAction:withPiece:)])
		[delegate handleMenuAction:MA_SetBG withPiece:selectedPiece];

}

- (void)edit:(UIMenuController*)controller{
	L();

	if ([delegate respondsToSelector:@selector(handleMenuAction:withPiece:)])
		[delegate handleMenuAction:MA_Edit withPiece:selectedPiece];

}


/**
 
 textwidget
 */
- (void)menuLockPiece:(UIMenuController*)controller{
	[(TextWidget*)selectedPiece setLockFlag:YES];
}

- (void)menuUnlockPiece:(UIMenuController*)controller{
	[(TextWidget*)selectedPiece setLockFlag:NO];

}

- (void)menuEditPiece:(UIMenuController*)controller{
//	L();
//	[[NSNotificationCenter defaultCenter]
//	 postNotificationName:NotifiRootOpenTextLabelVC object:[NSArray arrayWithObject:selectedPiece]];
}
@end
