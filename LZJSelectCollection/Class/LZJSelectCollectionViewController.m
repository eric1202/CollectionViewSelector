//
//  LZJSelectCollectionViewController.m
//  LZJSelectCollection
//
//  Created by Heyz on 2017/7/31.
//  Copyright © 2017年 LZJ. All rights reserved.
//

#import "LZJSelectCollectionViewController.h"
#import "LZJCollectionViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>
@interface LZJSelectCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,copy) NSArray *urls;
@property (nonatomic,copy) NSMutableArray *selects;
@property (nonatomic,copy) NSIndexPath *hanldeIndex;

@property (nonatomic,strong) UICollectionView *sourceCollectionView;
@property (nonatomic,strong) UICollectionView *selectCollectionView;
@end

@implementation LZJSelectCollectionViewController

-(instancetype)initWithImageURLs:(NSArray *)urls{
    self = [super init];
    if (self){
        self.urls = urls;
        self.selects = @[].mutableCopy;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_urls && _urls.count>0) {
        [self.view addSubview:self.sourceCollectionView];

    }else{
        _urls = @[@"https://lorempixel.com/400/400/",@"https://lorempixel.com/200/200/",@"https://lorempixel.com/300/300/",@"https://lorempixel.com/403/403/",@"https://lorempixel.com/450/450/",@"https://lorempixel.com/500/500/",@"https://lorempixel.com/402/402/",@"https://lorempixel.com/411/411/"];
        _selects = @[].mutableCopy;
        [self.view addSubview:self.sourceCollectionView];

    }

}

- (UICollectionView *)sourceCollectionView{
    if (_sourceCollectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumInteritemSpacing = 0;


        _sourceCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        [_sourceCollectionView registerNib:[UINib nibWithNibName:@"LZJCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LZJCollectionViewCell"];



        _sourceCollectionView.dataSource = self;
        _sourceCollectionView.delegate = self;
    }
    return _sourceCollectionView;
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section == 0? _selects.count :_urls.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    LZJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LZJCollectionViewCell" forIndexPath:indexPath  ];

    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:indexPath.section == 0?_selects[indexPath.item]: _urls[indexPath.item]]];
    cell.nameLbl.text = [NSString stringWithFormat:@"%ld -%ld",indexPath.section, indexPath.item];

    if (indexPath.section == 0) {
        //animation
        //
        //        cell.contentView.alpha = 0;
        //        [UIView animateWithDuration:0.3 animations:^{
        //            cell.contentView.alpha = 1;
        //        }];
    }

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {

        //remove
        [collectionView performBatchUpdates:^{
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [_selects removeObjectAtIndex:indexPath.item];
        } completion:^(BOOL finished) {

        }];

    }else{

        //add or remove
        NSString *str = _urls[indexPath.item];

        if (_selects.count == 0) {
            [_selects addObject:str];
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_selects.count-1 inSection:0]]];
            return;
        }


        if(![_selects containsObject:str]){

            [_selects addObject:str];
            [collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_selects.count-1 inSection:0]]];
            return;
        }

        [_selects enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([str isEqualToString:obj]) {

                [collectionView performBatchUpdates:^{
                    [collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:idx inSection:0]]];
                    [_selects removeObject:str];
                } completion:^(BOOL finished) {

                }];

                *stop = YES;
                return ;
            }

        }];

    }


}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat wid = CGRectGetWidth(self.view.frame)/4;
    return CGSizeMake(wid-1, wid /.618);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(2, 0, 20, 0);
}
@end
