//
//  TOpenCV.m
//  Sousenkyo_Vote
//
//  Created by Yuhang Huang on 2015/05/18.
//  Copyright (c) 2015年 Niko Kou@LOS_studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "Sousenkyo_Vote-Bridging-Header.h"

#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>

@implementation TOpenCV : NSObject

+(UIImage *)DetectWithImage:(UIImage *)image{
    cv::Mat mat;
    UIImageToMat(image, mat);
    
    cv::Mat gray;
    cv::cvtColor(mat, gray, CV_BGR2GRAY);
    
    cv::Mat matT;
    cv::threshold(gray, matT, 0, 255, cv::THRESH_BINARY|cv::THRESH_OTSU);
    
    return MatToUIImage(matT);

}


@end
