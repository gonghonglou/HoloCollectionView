//
//  HoloCollectionViewHeaderProtocol.h
//  HoloCollectionView
//
//  Created by 与佳期 on 2020/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HoloCollectionViewHeaderProtocol <NSObject>

@required

- (void)holo_configureHeaderWithModel:(id)model;


@optional

+ (CGSize)holo_sizeForHeaderWithModel:(id)model;

- (void)holo_willDisplayHeaderWithModel:(id)model;

- (void)holo_didEndDisplayingHeaderWithModel:(id)model;

@end

NS_ASSUME_NONNULL_END