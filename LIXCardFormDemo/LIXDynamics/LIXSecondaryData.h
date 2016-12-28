//
//  LIXSecondaryData.h
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/5.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

extern NSString *const LIXScondaryIdentifier;

@interface LIXSecondaryData : NSObject<UICollectionViewDelegate, UICollectionViewDataSource>

- (void)collectionView:(UICollectionView *)collectionView registerClass:(Class)cellClass;

@end
