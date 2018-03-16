//
//  Sousenkyo_Vote-Bridging-Header.h
//  Sousenkyo_Vote
//
//  Created by Yuhang Huang on 2015/05/15.
//  Copyright (c) 2015年 Niko Kou@LOS_studio. All rights reserved.
//

#ifndef Sousenkyo_Vote_Sousenkyo_Vote_Bridging_Header_h
#define Sousenkyo_Vote_Sousenkyo_Vote_Bridging_Header_h

#import <TesseractOCR/TesseractOCR.h>
#import "Foundation/Foundation.h"
#import "UIKit/UIKit.h"
#import <GoogleMobileAds/GoogleMobileAds.h>   // バナー広告

@interface TOpenCV : NSObject

+(UIImage *)DetectWithImage:(UIImage *)image;

@end

#endif
