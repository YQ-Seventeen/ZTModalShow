//MIT License
//
//Copyright (c) 2018 YQ-Seventeen (https://github.com/YQ-Seventeen )
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
#import <UIKit/UIKit.h>
// a enum that describe customview show or dismiss animation type
typedef NS_ENUM(NSUInteger, ZTAnimationOption) {
    ZTAnimationOptionNone,
    ZTAnimationOptionEaseInOut,
    ZTAnimationOptionEaseIn,
    ZTAnimationOptionEaseOut,
    ZTAnimationOptionLinear
};
// a enum that describe customview show or dismiss transition direction
typedef NS_ENUM(NSUInteger, ZTShowOption) {
    ZTShowOptionDownToUp,//transition direction is down to up
    ZTShowOptionUpToDown,//transition direction is up to down
    ZTShowOptionLeftToRight,//transition direction is left to right
    ZTShowOptionRightToLeft,//transition direction is right to left
    ZTShowOptionCenter//transition direction is enlarge from the center point of the superview‘s bounds
};
@class ModalShowOption;
typedef void (^commomBlock)(void);
@interface UIViewController (ModalShow)
// just show a customview Modally
- (void)zt_showViewPresently:(UIView *)view;

/**
 just show a customview Modally

 @param view customview instance
 @param inWindow a flag determine customview will show on window or not
 */
- (void)zt_showViewPresently:(UIView *)view InWindow:(BOOL)inWindow;

/**
 just show a customview Modally

 @param view customview instance
 @param inWindow a flag determine customview will show on window or not
 @param showBlock a callBlock when customview didShow
 @param dismissBlock a callBlock when customview didDismiss
 */
- (void)zt_showViewPresently:(UIView *)view InWindow:(BOOL)inWindow ShowBlock:(void (^)(void))showBlock DismissBlock:(void (^)(void))dismissBlock;

/**
 just show a customview Modally
 
 @param view customview instance
 @param inWindow a flag determine customview will show on window or not
 @param showCover a flag determine customview will show with a coverview
 @param showBlock a callBlock when customview didShow
 @param dismissBlock a callBlock when customview didDismiss
 */
- (void)zt_showViewPresently:(UIView *)view InWindow:(BOOL)inWindow ShowCover:(BOOL)showCover ShowBlock:(void (^)(void))showBlock DismissBlock:(void (^)(void))dismissBlock;

/**
 just show a customview Modally
 
 @param view customview instance
 @param inWindow a flag determine customview will show on window or not
 @param showCover a flag determine customview will show with a coverview
 @param dismissWhenClick a flag determine customview will dismiss when user click coverview
 @param showBlock a callBlock when customview didShow
 @param dismissBlock a callBlock when customview didDismiss
 */
- (void)zt_showViewPresently:(UIView *)view InWindow:(BOOL)inWindow ShowCover:(BOOL)showCover dismissWhenClickCover:(BOOL)dismissWhenClick ShowBlock:(void (^)(void))showBlock DismissBlock:(void (^)(void))dismissBlock;
// show customView with a full setting Option Object.for detail. see ModalShowOption interface
- (void)zt_showView:(UIView *)view WithConfiguration:(ModalShowOption *)option;
// make customView dismiss
- (void)zt_dismissView;
@end
@interface ModalShowOption : NSObject
// 'modalSuperView' set this property to appoint a superview that customview will show on it default is use category method caller's view
@property (strong, nonatomic) UIView *modalSuperView;
// 'coverBackgroundColor' set this property to change cover backgroundColor.default is [UIColor blackColor] with 0.7 alpha
@property (strong, nonatomic) UIColor *coverBackgroundColor;
// 'modalInWindow' set this property to YES so  that customview will modally show on window.default is NO
@property (assign, nonatomic) BOOL modalInWindow;
// 'showCover' set this property to NO so  that customview will modally show without coverView.default is YES
@property (assign, nonatomic) BOOL showCover;
// 'dismissWhenClickCover' this property is determine if customview dismiss when click coverview .if showCover set to 'NO' this property is invalid.default is YES
@property (assign, nonatomic) BOOL dismissWhenClickCover;
// 'animationType' this property decide the transition animationType.default is 'ZTAnimationOptionLinear'
@property (assign, nonatomic) ZTAnimationOption animationType;
// 'animationDurationTime' this property decide the transition durationTime.default is 0.2 sec
@property (assign, nonatomic) NSTimeInterval animationDurationTime;
// 'showOption' this property decide the transition direction.default is 'ZTShowOptionDownToUp'
@property (assign, nonatomic) ZTShowOption showOption;
// a block that call when ModalView will show
@property (copy, nonatomic) commomBlock willShowBlock;
// a block that call when ModalView did show
@property (copy, nonatomic) commomBlock showBlock;
// a block that call when ModalView will dismiss
@property (copy, nonatomic) commomBlock willDismissBlock;
// a block that call when ModalView did  dismiss
@property (copy, nonatomic) commomBlock dismissBlock;
// if you want some custom transform you can use this. so that this categories will not opeation view behaviors
@property (copy, nonatomic) void(^customTransformShowHandle)(UIView *) ;
@property (copy, nonatomic) void(^customTransformDismissHandle)(UIView *,UIView *);
//return a default ModalView Option Object
+ (instancetype)defaultOption;
@end
