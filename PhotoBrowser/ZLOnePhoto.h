//
//  ZLOnePhoto.h
//  JustFresh
//
//  Created by hgdq on 2016/12/28.
//  Copyright © 2016年 hgdq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, PickerType)
{
    PickerType_Camera = 0, // 拍照
    PickerType_Photo, // 照片
};
typedef NS_ENUM(NSInteger, PhotoCutType)
{
    PhotoCutType_YES = 0, // 裁剪
    PhotoCutType_NO, // 不裁剪
};

/**
 相片选择回调

 @param image 相片信息
 @param isCancel 是否取消  1：取消  0 没取消
 */
typedef void(^CallBackBlock)(UIImage *image, BOOL isCancel);


@interface ZLOnePhoto : NSObject


/**
 单例

 @return ZLOnePhoto
 */
+ (instancetype)shareInstance;

/**
 拍照或是选择相册

 @param pickerType PickerType
 @param photoCutType 是否裁剪
 @param vc 调用此方法的控制器
 @param callBackBlock 回调
 */
- (void)presentPicker:(PickerType)pickerType photoCut:(PhotoCutType)photoCutType target:(UIViewController *)vc callBackBlock:(CallBackBlock)callBackBlock;

@end
