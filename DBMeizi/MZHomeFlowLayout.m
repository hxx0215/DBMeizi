//
//  MZHomeFlowLayout.m
//  DBMeizi
//
//  Created by hxx on 8/6/14.
//  Copyright (c) 2014 hxx. All rights reserved.
//

#import "MZHomeFlowLayout.h"

@implementation MZHomeFlowLayout
- (instancetype)init{
    self = [super init];
    if (self){
        self.itemSize = CGSizeMake(290, 290);
        self.minimumInteritemSpacing = 10;
        self.minimumLineSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return self;
}
@end
