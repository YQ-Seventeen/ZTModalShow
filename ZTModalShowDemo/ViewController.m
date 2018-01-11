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
#import "ViewController.h"
#import <UIViewController+ModalShow.h>
@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *customView;
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.customView                 = [UIView new];
    self.customView.backgroundColor = [UIColor redColor];
    self.customView.frame           = CGRectMake(0, 0, 200, 200);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString  *nameSource[] = {
            [0] = @"从下弹出customview",
            [1] = @"从上弹出customview",
            [2] = @"从左弹出customview",
            [3] = @"从右弹出customview",
            [4] = @"从中间弹出customview",
    };
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
    }
    cell.textLabel.text = nameSource[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ModalShowOption *option      = [ModalShowOption defaultOption];
    option.showCover             = YES;
    option.animationType         = ZTAnimationOptionEaseIn;
    option.animationDurationTime = 0.2f;
    switch (indexPath.row) {
        case 0: {
            option.showOption = ZTShowOptionDownToUp;
            break;
        }
        case 1: {
            option.showOption = ZTShowOptionUpToDown;
            break;
        }
        case 2: {
            option.showOption = ZTShowOptionLeftToRight;
            break;
        }
        case 3: {
            option.showOption = ZTShowOptionRightToLeft;
            break;
        }
        case 4: {
            option.showOption = ZTShowOptionCenter;
            break;
        }
        default:
            break;
    }
    [self zt_showView:self.customView WithConfiguration:option];
}
@end
