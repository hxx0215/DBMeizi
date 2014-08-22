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
#import "MZPhotoModel.h"

@interface MZHomeViewController ()

@end
static NSString *CellIdentifier = @"Cell";
@implementation MZHomeViewController
@synthesize photoArray = _photoArray;
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
    self.collectionView.backgroundColor = [UIColor whiteColor];
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
        self.photoArray = x;
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
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MZHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setPhotoModel:self.photoArray[indexPath.row]];
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:self.photoArray[indexPath.row]];
//    imgView.contentMode = UIViewContentModeScaleAspectFit;
//    imgView.frame = CGRectMake(0, 0, 145, 145);
//    [cell.contentView addSubview:imgView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    MZHomeCell *cell =(MZHomeCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MZPhotoModel *model = (MZPhotoModel *)self.photoArray[indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:model.dataTitle delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
