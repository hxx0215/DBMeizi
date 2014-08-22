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

@implementation MZPhotoImporter
+ (RACReplaySubject *)importPhotos{
    RACReplaySubject *subject = [RACReplaySubject subject];
    NSURLRequest *request = [self allPhotoURLRequest];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (data){
//            id results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *imagesData = [self parseData:data];
//            NSMutableArray *images = [self downLoadPicture:imagesData];
//            [subject sendNext:images];
            [subject sendNext:[[[imagesData rac_sequence] map:^id(id value){
                MZPhotoModel *model = [MZPhotoModel new];
                [self configModel:model withTFHppleElement:value];
                NSLog(@"%@",value);
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

+ (NSURLRequest *)allPhotoURLRequest{
    return [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dbmeizi.com"]];
}
+ (void)configModel:(MZPhotoModel *)model withTFHppleElement:(id)value{
    model.dataBigImg = [value objectForKey:@"data-bigimg"];
    model.dataHeight = [[value objectForKey:@"data-height"] floatValue];
    model.dataId = [[value objectForKey:@"data-id"] integerValue];
    model.dataTitle = [NSString stringWithString:[[value objectForKey:@"data-title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    model.dataUrl = [value objectForKey:@"data-url"];
    model.dataUserurl = [value objectForKey:@"data-userurl"];
    model.dataWidth = [[value objectForKey:@"data-width"] floatValue];
    model.src = [value objectForKey:@"src"];
    NSLog(@"%@",value);
}

+ (void)downloadThumbnailForPhotoModel:(MZPhotoModel *)photoModel{
    NSString *prefix = [photoModel.src substringToIndex:4];
    NSString *url = photoModel.src;
    if (![prefix isEqualToString:@"http"])
        url = [@"http://dbmeizi.com" stringByAppendingString:url];
    [self download:url withCompletion:^(NSData *data){
        photoModel.thumbnailData = data;
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
@end
