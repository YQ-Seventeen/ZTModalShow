//MIT License
//
// Copyright (c) 2018 YQ-Seventeen (https://github.com/YQ-Seventeen )
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
#import "UIViewController+ModalShow.h"
#import <objc/runtime.h>
@interface UIViewController (Association)
@property (strong, nonatomic) ModalShowOption *zt_option;
@end
@implementation UIViewController (Association)
- (ModalShowOption *)zt_option {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setZt_option:(ModalShowOption *)zt_option {
    SEL storeKey = @selector(zt_option);
    objc_setAssociatedObject(self, storeKey, zt_option, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
@interface ModalShowOption ()
@property (strong, nonatomic) UIView *modalView;
@property (weak, nonatomic) UIView *zt_superView;
@property (weak, nonatomic) UIView *zt_coverView;
@property (assign, nonatomic) CGRect modalOriginalRect;
@property (assign, nonatomic) CGRect modalDestinationRect;
@property (assign, nonatomic) CGRect modalViewOriginalRect;
@end
@implementation ModalShowOption
+ (instancetype)defaultOption {
    ModalShowOption *option      = [[ModalShowOption alloc] init];
    option.showCover             = YES;
    option.dismissWhenClickCover = YES;
    option.animationType         = ZTAnimationOptionLinear;
    option.showOption            = ZTShowOptionDownToUp;
    option.animationDurationTime = 0.2;
    option.coverBackgroundColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    return option;
}

- (void)setShowOption:(ZTShowOption)showOption {
    _showOption = showOption;
	__block CGSize viewSize;
    if(showOption == ZTShowOptionCenter){
        self.customTransformDismissHandle = ^(UIView *view,UIView *superView){
			viewSize = CGSizeMake(view.bounds.size.width, view.bounds.size.height);
            CGFloat x, y;
            CGFloat w = 1,h=1;
            x = (CGRectGetWidth(superView.frame) - w) / 2;
            y = (CGRectGetHeight(superView.frame) - h) / 2;
            view.frame = CGRectMake(x, y, w, h);
        };
        self.customTransformShowHandle = ^(UIView *view,UIView *superView){
			CGFloat x, y;
            CGFloat w = viewSize.width, h = viewSize.height;
            x = (CGRectGetWidth(superView.frame) - w) / 2;
            y = (CGRectGetHeight(superView.frame) - h) / 2;
            view.frame = CGRectMake(x, y, w, h);
        };
    }
}

@end
@implementation UIViewController (ModalShow)
- (void)zt_showViewPresently:(UIView *)view {
    ModalShowOption *option = [ModalShowOption defaultOption];
    [self zt_showView:view WithConfiguration:option];
}
- (void)zt_showViewPresently:(UIView *)view InWindow:(BOOL)inWindow {
    ModalShowOption *option = [ModalShowOption defaultOption];
    option.modalInWindow    = inWindow;
    [self zt_showView:view WithConfiguration:option];
}
- (void)zt_showViewPresently:(UIView *)view InWindow:(BOOL)inWindow ShowBlock:(void (^)(void))showBlock DismissBlock:(void (^)(void))dismissBlock {
    ModalShowOption *option = [ModalShowOption defaultOption];
    option.modalInWindow    = inWindow;
    option.showBlock        = showBlock;
    option.dismissBlock     = dismissBlock;
    [self zt_showView:view WithConfiguration:option];
}
- (void)zt_showViewPresently:(UIView *)view InWindow:(BOOL)inWindow ShowCover:(BOOL)showCover ShowBlock:(void (^)(void))showBlock DismissBlock:(void (^)(void))dismissBlock {
    ModalShowOption *option = [ModalShowOption defaultOption];
    option.modalInWindow    = inWindow;
    option.showBlock        = showBlock;
    option.showCover        = showCover;
    option.dismissBlock     = dismissBlock;
    [self zt_showView:view WithConfiguration:option];
}
- (void)zt_showViewPresently:(UIView *)view InWindow:(BOOL)inWindow ShowCover:(BOOL)showCover dismissWhenClickCover:(BOOL)dismissWhenClick ShowBlock:(void (^)(void))showBlock DismissBlock:(void (^)(void))dismissBlock {
    ModalShowOption *option      = [ModalShowOption defaultOption];
    option.modalInWindow         = inWindow;
    option.showBlock             = showBlock;
    option.dismissWhenClickCover = dismissWhenClick;
    option.showCover             = showCover;
    option.dismissBlock          = dismissBlock;
    [self zt_showView:view WithConfiguration:option];
}
- (void)zt_showView:(UIView *)view WithConfiguration:(ModalShowOption *)option {
    
    if (nil == view && !option.modalInWindow) {
        NSLog(@"view is invalid ,so no modal will show");
        return;
    }
    option.modalView = view;
    option.modalViewOriginalRect = view.frame;
    if (option.willShowBlock) {
        option.willShowBlock();
    }
    UIView *modalSuperView = option.modalSuperView;
    if (!modalSuperView) {
        if ([self isKindOfClass:[UIViewController class]] && self.navigationController) {
            modalSuperView = self.navigationController.view;
        } else {
            modalSuperView = self.view;
        }
    }
    if (option.modalInWindow) {
        modalSuperView = [self lastWindow];
    }
    option.zt_superView = modalSuperView;
    typedef CGRect (^originalRectTranslateBlock)(UIView *modalView, UIView *modalSuperView);
    static originalRectTranslateBlock blocks[5] = {0};
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    {
        blocks[ZTShowOptionDownToUp] = ^(UIView * blk_modalView,UIView *blk_modalSuperView){return CGRectMake(0,blk_modalSuperView.frame.origin.y+blk_modalSuperView.frame.size.height, CGRectGetWidth(blk_modalSuperView.frame), CGRectGetHeight(blk_modalView.frame));
    };
    }
    {
        blocks[ZTShowOptionUpToDown] = ^(UIView *blk_modalView, UIView *blk_modalSuperView) {
            return CGRectMake(0, -CGRectGetHeight(blk_modalView.frame), CGRectGetWidth(blk_modalSuperView.frame), CGRectGetHeight(blk_modalView.frame));
        };
    }
    {
        blocks[ZTShowOptionLeftToRight] = ^(UIView *blk_modalView, UIView *blk_modalSuperView) {
            return CGRectMake(-CGRectGetWidth(blk_modalView.frame), 0, CGRectGetWidth(blk_modalView.frame), CGRectGetHeight(blk_modalSuperView.frame));
        };
    }
    {
        blocks[ZTShowOptionRightToLeft] = ^(UIView *blk_modalView, UIView *blk_modalSuperView) {
            return CGRectMake(CGRectGetWidth(blk_modalSuperView.frame), 0, CGRectGetWidth(blk_modalView.frame), CGRectGetHeight(blk_modalSuperView.frame));
        };
    }
    {
        blocks[ZTShowOptionCenter] = ^(UIView *blk_modalView, UIView *blk_modalSuperView) {
            CGFloat x, y;
            CGFloat w = blk_modalView.bounds.size.width, h = blk_modalView.bounds.size.height;
            x = (CGRectGetWidth(blk_modalSuperView.frame) - w) / 2;
            y = (CGRectGetHeight(blk_modalSuperView.frame) - h) / 2;
            return CGRectMake(x, y, w, h);
        };
    }
    });
    typedef CGRect (^destinationRectTranslateBlock)(UIView *modalView, UIView *modalSuperView);
    static destinationRectTranslateBlock dBlocks[5] = {0};
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        {
            dBlocks[ZTShowOptionDownToUp] = ^(UIView * blk_modalView,UIView *blk_modalSuperView){return CGRectMake(0,blk_modalSuperView.frame.origin.y+blk_modalSuperView.frame.size.height-CGRectGetHeight(blk_modalView.frame), CGRectGetWidth(blk_modalSuperView.frame), CGRectGetHeight(blk_modalView.frame));
    }
    ;
    }
    {
        dBlocks[ZTShowOptionUpToDown] = ^(UIView *blk_modalView, UIView *blk_modalSuperView) {
            return CGRectMake(0, 0, CGRectGetWidth(blk_modalSuperView.frame), CGRectGetHeight(blk_modalView.frame));
        };
    }
    {
        dBlocks[ZTShowOptionLeftToRight] = ^(UIView *blk_modalView, UIView *blk_modalSuperView) {
            return CGRectMake(0, 0, CGRectGetWidth(blk_modalView.frame), CGRectGetHeight(blk_modalSuperView.frame));
        };
    }
    {
        dBlocks[ZTShowOptionRightToLeft] = ^(UIView *blk_modalView, UIView *blk_modalSuperView) {
            return CGRectMake(CGRectGetWidth(blk_modalSuperView.frame) - CGRectGetWidth(blk_modalView.frame), 0, CGRectGetWidth(blk_modalView.frame), CGRectGetHeight(blk_modalSuperView.frame));
        };
    }
    {
        dBlocks[ZTShowOptionCenter] = ^(UIView *blk_modalView, UIView *blk_modalSuperView) {
            CGFloat x, y, w, h;
            x = (CGRectGetWidth(blk_modalSuperView.frame) - CGRectGetWidth(blk_modalView.frame)) / 2;
            y = (CGRectGetHeight(blk_modalSuperView.frame) - CGRectGetHeight(blk_modalView.frame)) / 2;
            w = CGRectGetWidth(blk_modalView.frame);
            h = CGRectGetHeight(blk_modalView.frame);
            return CGRectMake(x, y, w, h);
        };
    }
    });
    CGRect originalRect         = blocks[option.showOption](option.modalView, option.zt_superView);
    CGRect destinationRect      = dBlocks[option.showOption](option.modalView, option.zt_superView);
    option.modalOriginalRect    = originalRect;
    option.modalDestinationRect = destinationRect;
    if (view.superview) {
        [view removeFromSuperview];
    }
    if(option.customTransformDismissHandle){
        option.customTransformDismissHandle(option.modalView,option.zt_superView);
    } else {
        view.frame = originalRect;
    }
    [modalSuperView addSubview:view];
    UIView *coverView;
    if (option.showCover) {
        coverView                 = [[UIView alloc] init];
        coverView.frame           = modalSuperView.bounds;
        coverView.backgroundColor = option.coverBackgroundColor;
        coverView.alpha           = 0;
        [modalSuperView insertSubview:coverView belowSubview:view];
        option.zt_coverView = coverView;
    }
    static const NSInteger viewAnimationOptionSet[] = {
            [ZTAnimationOptionNone]      = -1,
            [ZTAnimationOptionEaseInOut] = UIViewAnimationOptionCurveEaseInOut,
            [ZTAnimationOptionEaseIn]    = UIViewAnimationOptionCurveEaseIn,
            [ZTAnimationOptionEaseOut]   = UIViewAnimationOptionCurveEaseOut,
            [ZTAnimationOptionLinear]    = UIViewAnimationOptionCurveLinear,
    };
    NSInteger animationType   = viewAnimationOptionSet[option.animationType];
    void (^changeBlock)(void) = ^{
        coverView.alpha = 0.7;
        if(option.customTransformShowHandle){
			option.customTransformShowHandle(option.modalView,option.zt_superView);
        } else {
            view.frame      = destinationRect;
        }
    };
    if (animationType >= 0) {
        [UIView animateWithDuration:option.animationDurationTime
            delay:0
            options:animationType
            animations:^{
                changeBlock();
            }
            completion:^(BOOL finished) {
                if (option.showBlock) {
                    option.showBlock();
                }
            }];
    } else {
        changeBlock();
        if (option.showBlock) {
            option.showBlock();
        }
    }
    if (option.dismissWhenClickCover) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zt_clickCover)];
        coverView.userInteractionEnabled   = YES;
        [coverView addGestureRecognizer:tapGesture];
    }
    self.zt_option = option;
}
- (void)zt_dismissView {
    if (!self.zt_option) {
        return;
    }
    ModalShowOption *option = self.zt_option;
    if (option.willDismissBlock) {
        option.willDismissBlock();
    }
    UIView *view                                    = option.modalView;
    UIView *coverView                               = option.zt_coverView;
    CGRect destinationRect                          = option.modalOriginalRect;
    static const NSInteger viewAnimationOptionSet[] = {
            [ZTAnimationOptionNone]      = -1,
            [ZTAnimationOptionEaseInOut] = UIViewAnimationOptionCurveEaseInOut,
            [ZTAnimationOptionEaseIn]    = UIViewAnimationOptionCurveEaseIn,
            [ZTAnimationOptionEaseOut]   = UIViewAnimationOptionCurveEaseOut,
            [ZTAnimationOptionLinear]    = UIViewAnimationOptionCurveLinear,
    };
    NSInteger animationType   = viewAnimationOptionSet[option.animationType];
    void (^changeBlock)(void) = ^{
        coverView.alpha = 0;
        if(option.customTransformDismissHandle) {
            option.customTransformDismissHandle(option.modalView,option.zt_superView);
        } else {
            view.frame      = destinationRect;
        }
    };
    void (^removeBlock)(void) = ^{
//        if(option.customTransformShowHandle){
//            option.customTransformShowHandle(option.modalView);
//        } else {
//            view.frame = option.modalViewOriginalRect;
//        }
        [coverView removeFromSuperview];
        [view removeFromSuperview];
		view.frame = option.modalViewOriginalRect;
    };
    if (animationType >= 0) {
        [UIView animateWithDuration:option.animationDurationTime
            delay:0
            options:animationType
            animations:^{
                changeBlock();
            }
            completion:^(BOOL finished) {
                removeBlock();
                if (option.dismissBlock) {
                    option.dismissBlock();
                }
            }];
    } else {
        changeBlock();
        removeBlock();
        if (option.dismissBlock) {
            option.dismissBlock();
        }
    }
}
- (void)zt_clickCover {
    [self zt_dismissView];
}
- (NSInteger)getModalViewUniqueTagWithOption:(ModalShowOption *)option {
    static const float locationOffsetSet[] = {
            [ZTShowOptionDownToUp]    = 1,
            [ZTShowOptionUpToDown]    = 2,
            [ZTShowOptionLeftToRight] = 3,
            [ZTShowOptionRightToLeft] = 4,
            [ZTShowOptionCenter]      = 5};
    NSInteger baseTag = 1700;
    return (baseTag + locationOffsetSet[option.showOption]);
}
- (NSInteger)getModalCoverViewUniqueTagWithOption:(ModalShowOption *)option {
    static const float locationOffsetSet[] = {
            [ZTShowOptionDownToUp]    = 1,
            [ZTShowOptionUpToDown]    = 2,
            [ZTShowOptionLeftToRight] = 3,
            [ZTShowOptionRightToLeft] = 4,
            [ZTShowOptionCenter]      = 5};
    NSInteger baseTag = 7100;
    return (baseTag + locationOffsetSet[option.showOption]);
}
- (UIWindow *)lastWindow {
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}
@end
