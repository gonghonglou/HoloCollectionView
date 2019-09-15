//
//  HoloCollectionViewUpdateRowMaker.m
//  HoloCollectionView
//
//  Created by 与佳期 on 2019/9/14.
//

#import "HoloCollectionViewUpdateRowMaker.h"
#import <objc/runtime.h>
#import "HoloCollectionViewSectionMaker.h"

////////////////////////////////////////////////////////////
@implementation HoloUpdateCollectionRowMaker

- (HoloUpdateCollectionRowMaker * (^)(NSString *))cell {
    return ^id(id obj) {
        self.row.cell = obj;
        return self;
    };
}

@end

////////////////////////////////////////////////////////////
@interface HoloCollectionViewUpdateRowMaker ()

@property (nonatomic, copy) NSArray<HoloCollectionSection *> *holoSections;

@property (nonatomic, assign) BOOL isRemark;

@property (nonatomic, strong) HoloCollectionRow *targetRow;

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *holoUpdateRows;

@property (nonatomic, strong) NSMutableDictionary *rowIndexPathsDict;

@end

@implementation HoloCollectionViewUpdateRowMaker

- (instancetype)initWithProxyDataSections:(NSArray<HoloCollectionSection *> *)sections isRemark:(BOOL)isRemark {
    self = [super init];
    if (self) {
        _holoSections = sections;
        _isRemark = isRemark;
        
        for (HoloCollectionSection *section in self.holoSections) {
            for (HoloCollectionRow *row in section.rows) {
                NSString *dictKey = row.tag ?: kHoloRowTagNil;
                if (self.rowIndexPathsDict[dictKey]) continue;
                
                NSMutableDictionary *dict = @{kHoloTargetRow : row}.mutableCopy;
                NSInteger sectionIndex = [self.holoSections indexOfObject:section];
                NSInteger rowIndex = [section.rows indexOfObject:row];
                dict[kHoloTargetIndexPath] = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                self.rowIndexPathsDict[dictKey] = [dict copy];
            }
        }
    }
    return self;
}

- (HoloUpdateCollectionRowMaker *(^)(NSString *))tag {
    return ^id(NSString *tag) {
        HoloUpdateCollectionRowMaker *rowMaker = [HoloUpdateCollectionRowMaker new];
        HoloCollectionRow *updateRow = rowMaker.row;
        updateRow.tag = tag;
        
        NSString *dictKey = tag ?: kHoloRowTagNil;
        NSDictionary *rowIndexPathDict = self.rowIndexPathsDict[dictKey];
        
        NSIndexPath *targetIndexPath = rowIndexPathDict[kHoloTargetIndexPath];
        HoloCollectionRow *targetRow = rowIndexPathDict[kHoloTargetRow];
        if (!self.isRemark && targetRow) {
            // set value of CGFloat and BOOL
            unsigned int outCount;
            objc_property_t * properties = class_copyPropertyList([targetRow class], &outCount);
            for (int i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                const char * propertyAttr = property_getAttributes(property);
                char t = propertyAttr[1];
                if (t == 'd' || t == 'B') { // CGFloat or BOOL
                    const char *propertyName = property_getName(property);
                    NSString *propertyNameStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
                    id value = [targetRow valueForKey:propertyNameStr];
                    if (value) [updateRow setValue:value forKey:propertyNameStr];
                }
            }
            // set value of SEL
            updateRow.configSEL = targetRow.configSEL;
            updateRow.sizeSEL = targetRow.sizeSEL;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary new];
        if (targetRow) {
            dict[kHoloTargetRow] = targetRow;
            dict[kHoloTargetIndexPath] = targetIndexPath;
        }
        dict[kHoloUpdateRow] = updateRow;
        [self.holoUpdateRows addObject:dict];
        
        return rowMaker;
    };
}

- (NSArray<NSDictionary *> *)install {
    return [self.holoUpdateRows copy];
}

#pragma mark - getter
- (NSMutableArray<NSDictionary *> *)holoUpdateRows {
    if (!_holoUpdateRows) {
        _holoUpdateRows = [NSMutableArray new];
    }
    return _holoUpdateRows;
}

- (NSMutableDictionary *)rowIndexPathsDict {
    if (!_rowIndexPathsDict) {
        _rowIndexPathsDict = [NSMutableDictionary new];
    }
    return _rowIndexPathsDict;
}

@end