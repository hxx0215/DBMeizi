//
//  MZHomeCell.m
//  DBMeizi
//
//  Created by hxx on 8/6/14.
//  Copyright (c) 2014 hxx. All rights reserved.
//

#import "MZHomeCell.h"
#import "MZPhotoModel.h"
@interface MZHomeCell()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, strong) RACDisposable *subscription;
@end

@implementation MZHomeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)setPhotoModel:(MZPhotoModel *)photoMode{
    self.subscription = [[[RACObserve(photoMode, thumbnailData) filter:^BOOL(id value){
        return value != nil;
    }] map:^id (id value){
        return [UIImage imageWithData:value];
    }] setKeyPath:@keypath(self.imageView, image) onObject:self.imageView];
}


- (void)prepareForReuse{
    [super prepareForReuse];
    
    [self.subscription dispose], self.subscription = nil;
}
@end
