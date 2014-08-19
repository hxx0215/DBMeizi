//
//  MZHomeViewController.m
//  DBMeizi
//
//  Created by hxx on 8/6/14.
//  Copyright (c) 2014 hxx. All rights reserved.
//

#import "MZHomeViewController.h"
#import "MZHomeFlowLayout.h"
#import "MZHomeCell.h"
#import "MZPhotoImporter.h"

@interface MZHomeViewController ()

@end
static NSString *CellIdentifier = @"Cell";
@implementation MZHomeViewController

- (id)init{
    MZHomeFlowLayout *flowLayout = [[MZHomeFlowLayout alloc]init];
    self = [self initWithCollectionViewLayout:flowLayout];
    if (!self) return nil;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"DBMeizi";
    
    [self.collectionView registerClass:[MZHomeCell class] forCellWithReuseIdentifier:CellIdentifier];
    
    @weakify(self);
    [RACObserve(self, photoArray) subscribeNext:^(id x){
        @strongify(self);
        [self.collectionView reloadData];
    }];
    [self loadPhotos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPhotos{
    [[MZPhotoImporter importPhotos] subscribeNext:^(id x){
        NSLog(@"x:%@",x);
    }error:^(NSError *error){
        NSLog(@"%@",error);
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
