//
//  LIXCardForm.h
//  LIXCardFormDemo
//
//  Created by lixu on 2016/11/28.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIXCollectionViewBasicFlowLayout.h"

#import <Availability.h>
#undef weak_delegate
#undef __weak_delegate
#if __has_feature(objc_arc) && __has_feature(objc_arc_weak) && \
(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif





NS_ASSUME_NONNULL_BEGIN

@protocol LIXCardFormDataSource, LIXCardFormDelegate;

@interface LIXCardForm : UIView< UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) LIXCardFormType type;
@property (nonatomic, weak_delegate) IBOutlet __nullable id<LIXCardFormDataSource> dataSource;
@property (nonatomic, weak_delegate) IBOutlet __nullable id<LIXCardFormDelegate> delegate;

@property (nonatomic, assign) NSInteger itemsCount;

@end


@protocol LIXCardFormDataSource <NSObject>

- (NSInteger)numberOfItemsInCardForm:(LIXCardForm *)cardForm;
- (UIView *)cardForm:(LIXCardForm *)cardForm viewForItemAtIndexPath:(NSIndexPath*)indexPath;

@optional

- (NSInteger)numberOfPlaceholdersInCardForm:(LIXCardForm *)cardForm;
- (UIView *)cardForm:(LIXCardForm *)cardForm placeHolderViewAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol LIXCardFormDelegate <NSObject>


@end

NS_ASSUME_NONNULL_END
