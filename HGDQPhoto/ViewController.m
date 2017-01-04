//
//  ViewController.m
//  HGDQPhoto
//
//  Created by hgdq on 2017/1/4.
//  Copyright © 2017年 hgdq. All rights reserved.
//

#import "ViewController.h"
#import "ZLDefine.h"

@interface ViewController ()
// 相册单选
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
// 相册单选带裁剪
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Cut;
@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnClick:(UIButton *)sender {
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1:{ // 相册单选  不裁剪
            ZLOnePhoto *one = [ZLOnePhoto shareInstance];
            [one presentPicker:PickerType_Photo photoCut:PhotoCutType_NO target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
                self.imageView.image = image;
            }];}
            break;
        case 2:{ // 相册单选  裁剪
            ZLOnePhoto *one = [ZLOnePhoto shareInstance];
            [one presentPicker:PickerType_Photo photoCut:PhotoCutType_YES target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
                self.imageView_Cut.image = image;
            }];}
            break;
        case 3:{ // 相机  不裁剪
            ZLOnePhoto *one = [ZLOnePhoto shareInstance];
            [one presentPicker:PickerType_Camera photoCut:PhotoCutType_NO target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
                self.imageView.image = image;
            }];}
            break;
        case 4:{ // 相机  裁剪
            ZLOnePhoto *one = [ZLOnePhoto shareInstance];
            [one presentPicker:PickerType_Camera photoCut:PhotoCutType_YES target:self callBackBlock:^(UIImage *image, BOOL isCancel) {
                self.imageView_Cut.image = image;
            }];}
            break;
        case 5:{ // 相册多选
            ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
            //设置照片最大选择数
            actionSheet.maxSelectCount = 5;
            [actionSheet showPhotoLibraryWithSender:self lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
                NSLog(@"%@", selectPhotos);
            }];}
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
