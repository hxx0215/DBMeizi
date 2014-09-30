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
@property (nonatomic, strong)UIRefreshControl *refresh;
@property (nonatomic, assign)NSInteger curIndex;
@property (nonatomic, assign)BOOL isLoadComplete;

@end
static NSString *CellIdentifier = @"Cell";
@implementation MZHomeViewController
@synthesize photoArray = _photoArray;
- (id)init{
    MZHomeFlowLayout *flowLayout = [[MZHomeFlowLayout alloc]init];
    self = [self initWithCollectionViewLayout:flowLayout];
    if (!self) return nil;
    self.curIndex = 0;
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
    [self loadPhotos:self.curIndex];
    
    self.refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(refreshPhoto:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refresh];
    self.isLoadComplete = NO;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(left_Clicked:)];
    self.navigationItem.leftBarButtonItem = left;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadPhotos:(NSInteger)pageIndex{
    NSLog(@"pageIndex:%d",pageIndex);
    [[MZPhotoImporter importPhotos:pageIndex] subscribeNext:^(id x){
        if (!self.photoArray || pageIndex == 0)
            self.photoArray = [x mutableCopy];
        else
            [self.photoArray addObjectsFromArray:x];
    }error:^(NSError *error){
        NSLog(@"%@",error);
    }completed:^(void){
        [self loadCompleted];
    }];
}
- (void)refreshPhoto:(id)sender{
    [self loadPhotos:0];
}
- (void)loadCompleted{
    NSLog(@"loadcompleted");
    [self.collectionView reloadData];
    [self.refresh endRefreshing];
    self.isLoadComplete = YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)left_Clicked:(id)sender{
    NSLog(@"%@",[NSDate dateWithTimeIntervalSince1970:1409328000]);
    CGFloat now = [[NSDate date] timeIntervalSince1970];
    NSInteger iNow = (NSInteger)now;
    iNow =iNow - (iNow + 8 * 3600) % 86400;
    NSTimeInterval tNow = (NSTimeInterval)iNow;
    NSLog(@"%@", [NSDate dateWithTimeIntervalSince1970:tNow]);

//    [UIView animateWithDuration:0.5 animations:^{
//        CGRect frame = self.view.frame;
//        frame.origin.x += 100;
//        self.view.frame = frame;
//        frame = self.navigationController.navigationBar.frame;
//        frame.origin.x += 100;
//        [self.navigationController.navigationBar setFrame:frame];
//    }];
    
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
#pragma scroll delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float ScrollAllHeight =self.collectionView.contentOffset.y+self.collectionView.frame.size.height;
    float tabviewSizeHeight =self.collectionView.contentSize.height;
   if ((ScrollAllHeight>tabviewSizeHeight+50)&&self.isLoadComplete)
   {
       NSLog(@"nextpage");
       self.curIndex ++;
       self.isLoadComplete = NO;
       [self loadPhotos:self.curIndex];
//       [self.nextPageActivityIndicator startAnimating];
   }
}
#pragma collection delegate && datasource
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
