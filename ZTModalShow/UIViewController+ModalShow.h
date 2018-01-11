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
typedef NS_ENUM(NSUInteger, ZTAnimationOption) {
    ZTAnimationOptionNone,
    ZTAnimationOptionEaseInOut,
    ZTAnimationOptionEaseIn,
    ZTAnimationOptionEaseOut,
    ZTAnimationOptionLinear
};
typedef NS_ENUM(NSUInteger, ZTShowOption) {
    ZTShowOptionDownToUp,
    ZTShowOptionUpToDown,
    ZTShowOptionLeftToRight,
    ZTShowOptionRightToLeft,
    ZTShowOptionCenter
};
@class ModalShowOption;
typedef void (^commomBlock)(void);
@interface UIViewController (ModalShow)
- (void)zt_showViewPresently:(UIView *)view;
- (void)zt_showViewPresently:(UIView *)view InWindow:(BOOL)inWindow;
- (void)zt_showViewPresently:(UIView *)view InWindow:(BOOL)inWindow ShowBlock:(void (^)(void))showBlock DismissBlock:(void (^)(void))dismissBlock;
- (void)zt_showViewPresently:(UIView *)view InWindow:(BOOL)inWindow ShowCover:(BOOL)showCover ShowBlock:(void (^)(void))showBlock DismissBlock:(void (^)(void))dismissBlock;
- (void)zt_showViewPresently:(UIView *)view InWindow:(BOOL)inWindow ShowCover:(BOOL)showCover dismissWhenClickCover:(BOOL)dismissWhenClick ShowBlock:(void (^)(void))showBlock DismissBlock:(void (^)(void))dismissBlock;
- (void)zt_showView:(UIView *)view WithConfiguration:(ModalShowOption *)option;
- (void)zt_dismissView;
@end
@interface ModalShowOption : NSObject
@property (strong, nonatomic) UIView *modalSuperView;
@property (strong, nonatomic) UIColor *coverBackgroundColor;
@property (assign, nonatomic) BOOL modalInWindow;
@property (assign, nonatomic) BOOL showCover;
@property (assign, nonatomic) BOOL dismissWhenClickCover;
@property (assign, nonatomic) ZTAnimationOption animationType;
@property (assign, nonatomic) NSTimeInterval animationDurationTime;
@property (assign, nonatomic) ZTShowOption showOption;
@property (copy, nonatomic) commomBlock willShowBlock;
@property (copy, nonatomic) commomBlock showBlock;
@property (copy, nonatomic) commomBlock willDismissBlock;
@property (copy, nonatomic) commomBlock dismissBlock;
+ (instancetype)defaultOption;
@end
