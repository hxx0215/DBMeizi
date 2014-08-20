//
//  MZPhotoModel.h
//  DBMeizi
//
//  Created by hxx on 8/6/14.
//  Copyright (c) 2014 hxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZPhotoModel : NSObject
@property (nonatomic, strong) NSData *thumbnailData;
@property (nonatomic, strong) NSData *bigImgData;
@property (nonatomic, strong) NSString *dataBigImg;
@property (nonatomic, strong) NSString *dataTitle;
@property (nonatomic, strong) NSString *dataUrl;
@property (nonatomic, strong) NSString *dataUserurl;
@property (nonatomic, strong) NSString *src;
@property (nonatomic, assign) CGFloat dataHeight;
@property (nonatomic, assign) NSInteger dataId;
@property (nonatomic, assign) CGFloat dataWidth;
@end
