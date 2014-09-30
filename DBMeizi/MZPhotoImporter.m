//
//  MZPhotoImporter.m
//  DBMeizi
//
//  Created by hxx on 8/7/14.
//  Copyright (c) 2014 hxx. All rights reserved.
//

#import "MZPhotoImporter.h"
#import "TFHpple.h"
#import "MZPhotoModel.h"
#import "SDWebImageManager.h"

@implementation MZPhotoImporter
+ (RACReplaySubject *)importPhotos:(NSInteger)pageIndex{
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSURLRequest *request = [self allPhotoURLRequest:pageIndex];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (data){
//            id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *imagesData = [self parseData:data];
//            NSMutableArray *images = [self downLoadPicture:imagesData];
//            [subject sendNext:images];
            [subject sendNext:[[[imagesData rac_sequence] map:^id(id value){
                MZPhotoModel *model = [MZPhotoModel new];
                [self configModel:model withTFHppleElement:value];
                [self downloadThumbnailForPhotoModel:model];
                return model;
            }]array]];
            [subject sendCompleted];
        }
        else{
            [subject sendError:connectionError];
        }
    }];
    return subject;
}

+ (NSURLRequest *)allPhotoURLRequest:(NSInteger)pageIndex{
    NSString *urlString = [NSString stringWithFormat:@"http://dbmeizi.com?p=%d",pageIndex];
    NSLog(@"the url is :%@",urlString);
    return [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
}
+ (void)configModel:(MZPhotoModel *)model withTFHppleElement:(id)value{
    model.dataBigImg = [value objectForKey:@"data-bigimg"];
    model.dataHeight = [[value objectForKey:@"data-height"] floatValue];
    model.dataId = [[value objectForKey:@"data-id"] integerValue];
    model.dataTitle = [NSString stringWithString:[[value objectForKey:@"data-title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    model.dataUrl = [value objectForKey:@"data-url"];
    model.dataUserurl = [value objectForKey:@"data-userurl"];
    model.dataWidth = [[value objectForKey:@"data-width"] floatValue];
    model.src = [value objectForKey:@"data-src"];
}

+ (void)downloadThumbnailForPhotoModel:(MZPhotoModel *)photoModel{
    NSString *prefix = [photoModel.src substringToIndex:4];
    NSString *url = photoModel.src;
    if (![prefix isEqualToString:@"http"])
        url = [@"http://dbmeizi.com" stringByAppendingString:url];
//    [self download:url withCompletion:^(NSData *data){
//        photoModel.thumbnailData = data;
//    }];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize){
        NSLog(@"receivedSize:%d,expectedSize:%d",receivedSize,expectedSize);
    } completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType,BOOL finished){
        NSLog(@"cacheType:%d",cacheType);
        photoModel.thumbnailData = UIImagePNGRepresentation(image);
        if (!photoModel.thumbnailData)
            photoModel.thumbnailData = UIImageJPEGRepresentation(image,1.0);
    }];
}
+ (void)download:(NSString *)urlString withCompletion:(void (^)(NSData *data))completion{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (completion)
            completion(data);
    }];
}
+ (NSArray*)parseData:(NSData*) data
{
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    
    //在页面中查找img标签
    NSArray *images = [doc searchWithXPathQuery:@"//img"];
    return images;
}
//+ (NSMutableArray*)downLoadPicture:(NSArray *)images
//{
//    //创建存放UIImage的数组
//    NSMutableArray *downloadImages = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < [images count]; i++){
//        NSString *prefix = [[[images objectAtIndex:i] objectForKey:@"src"] substringToIndex:4];
//        NSString *url = [[images objectAtIndex:i] objectForKey:@"src"];
//        
//        //判断图片的下载地址是相对路径还是绝对路径，如果是以http开头，则是绝对地址，否则是相对地址
//        if ([prefix isEqualToString:@"http"] == NO){
//            url = [@"http://dbmeizi.com" stringByAppendingPathComponent:url];
//        }
//        
//        NSURL *downImageURL = [NSURL URLWithString:url];
//        
//        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:downImageURL]];
//        
//        if(image != nil){
//            [downloadImages addObject:image];
//        }
////        NSLog(@"下载图片的URL:%@", url);
//        NSLog(@"%d / %d",i,[images count]);
//    }
//    return downloadImages;
//}
/*
 
 苏宁发短信
 NSURL *url = [NSURL URLWithString:@"https://member.suning.com/emall/AjaxSendValidationCodeCmd"];
 
 //第二步，创建请求
 
 NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
 
 [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
 
 NSString *str = @"scenario=mobileRegister&mobile=18569410844";//设置参数
 
 NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
 
 [request setHTTPBody:data];
 
 //第三步，连接服务器
 
 NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
 
 NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
 
 NSLog(@"%@",str1);
 */
@end
