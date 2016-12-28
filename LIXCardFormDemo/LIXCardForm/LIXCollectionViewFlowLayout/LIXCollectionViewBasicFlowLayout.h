//
//  LIXCollectionViewBasicFlowLayout.h
//  LIXCardFormDemo
//
//  Created by lixu on 2016/11/28.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LIXCardFormType) {
    LIXCardFormType_Linear = 0,
    LIXCardFormType_CoverFlow
};

@interface LIXCollectionViewBasicFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) LIXCardFormType layoutType;

+ (instancetype)instanceOfType:(LIXCardFormType)type;



@end
