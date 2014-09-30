//
//  MZSideMenuView.m
//  DBMeizi
//
//  Created by hxx on 8/31/14.
//  Copyright (c) 2014 hxx. All rights reserved.
//

#import "MZSideMenuView.h"
@interface MZSideMenuView() <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *titles;
@end
@implementation MZSideMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.menuTableView = [[UITableView alloc] initWithFrame:self.bounds];
        self.menuTableView.dataSource = self;
        self.menuTableView.delegate = self;
        [self addSubview:self.menuTableView];
        NSArray *girlsTitle = @[@"女人",@"全部",@"有沟",@"文艺",@"美腿",@"小清新",@"美臀",@"性感"];
        NSArray *boonTitle = @[@"福利",@"全部"];
        NSArray *boysTitle = @[@"男人",@"全部",@"文艺男",@"肌肉男",@"清新男"];
        NSArray *funnyTitle = @[@"有点意思",@"全部"];
        NSArray *favoriteTitle = @[@"收藏",@"收藏"];
        self.titles = [[NSMutableArray alloc] init];
        [self.titles addObject:girlsTitle];
        [self.titles addObject:boonTitle];
        [self.titles addObject:boysTitle];
        [self.titles addObject:funnyTitle];
        [self.titles addObject:favoriteTitle];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.titles count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.titles[section] count] - 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] init];
    label.text = [self.titles[section] objectAtIndex:0];
    return label;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifyString = @"sideCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyString];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifyString];
    }
    cell.textLabel.text = [self.titles[indexPath.section] objectAtIndex:indexPath.row + 1];
    return cell;
}
@end
