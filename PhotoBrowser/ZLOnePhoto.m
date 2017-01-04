//
//  ZLOnePhoto.m
//  JustFresh
//
//  Created by hgdq on 2016/12/28.
//  Copyright © 2016年 hgdq. All rights reserved.
//

#import "ZLOnePhoto.h"
#import "VPImageCropperViewController.h"
#import "ZLDefine.h"

@interface ZLOnePhoto ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,VPImageCropperDelegate>
{
    UIImagePickerController        *_imgPickC;
    UIViewController               *_vc;
    CallBackBlock                  _callBackBlock;
    PhotoCutType                   _photoCutType;
}
@end


@implementation ZLOnePhoto

+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static ZLOnePhoto *pickManager;
    dispatch_once(&once, ^{
        pickManager = [[ZLOnePhoto alloc] init];
    });
    
    return pickManager;
}
- (instancetype)init
{
    if([super init]){
        if(!_imgPickC){
            _imgPickC = [[UIImagePickerController alloc] init];  // 初始化 _imgPickC
        }
    }
    
    return self;
}

- (void)presentPicker:(PickerType)pickerType photoCut:(PhotoCutType)photoCutType target:(UIViewController *)vc callBackBlock:(CallBackBlock)callBackBlock
{
    _vc = vc;
    _photoCutType = photoCutType;
    _callBackBlock = callBackBlock;
    if(pickerType == PickerType_Camera){
        // 拍照
        if([self isCameraAvailable]){
            _imgPickC.delegate = self;
            _imgPickC.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imgPickC.allowsEditing = NO;
            _imgPickC.showsCameraControls = YES;
            UIView *view = [[UIView  alloc] init];
            view.backgroundColor = [UIColor grayColor];
            _imgPickC.cameraOverlayView = view;
            [_vc presentViewController:_imgPickC animated:YES completion:nil];
        }else{
            //无相机访问权限
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在IPhone的“设置-隐私-相机”中允许****访问您的相机" preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:okAction];
            [_vc presentViewController:alertController animated:YES completion:nil];
            
            return;

        }
    }
    
    else if(pickerType == PickerType_Photo){
        // 相册
        if([self isPhotoLibraryAvailable]){
            _imgPickC.delegate = self;
            _imgPickC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            _imgPickC.allowsEditing = NO;
            [_vc presentViewController:_imgPickC animated:YES completion:nil];
        }else{
            //无相册访问权限
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在IPhone的“设置-隐私-照片”中允许****访问您的照片" preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [alertController addAction:okAction];
            [_vc presentViewController:alertController animated:YES completion:nil];
            return;
        }
        
    }
}




#pragma mark ---- UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info 
{
    [_vc dismissViewControllerAnimated:YES completion:^{
         UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        // 裁剪
        if (_photoCutType == PhotoCutType_YES) {
            VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, CGRectGetMidY(_vc.view.frame)-kViewWidth*1/2.0-32, kViewWidth, kViewWidth*1) limitScaleRatio:3.0];
            imgEditorVC.view.backgroundColor = [UIColor whiteColor];
            imgEditorVC.delegate = self;
            [_vc presentViewController:imgEditorVC animated:YES completion:^{
                ;
            }];
        }else{
            _callBackBlock(portraitImg, NO); // block回调
        }
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_vc dismissViewControllerAnimated:YES completion:^{
        _callBackBlock(nil, YES); // block回调
    }];
}

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    NSLog(@"editedImage = %@",editedImage);
    _callBackBlock(editedImage, NO); // block回调
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    NSLog(@"imageCropperDidCancel");
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}



- (void)dealloc
{
    _imgPickC.delegate = nil;
}

// 检查摄像头是否支持拍照
- (BOOL) isCameraAvailable{
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied || ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        return NO;
    }
    return YES;
}


// 前面的摄像头是否可用
- (BOOL) isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

// 后面的摄像头是否可用
- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark - Album
// 相册是否可用
- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary];
}


@end
