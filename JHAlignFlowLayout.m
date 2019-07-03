//
//  JHAlignFlowLayout.m
//
//
//  Created by 金华 on 2019/5/26.
//  Copyright © 2019 金华. All rights reserved.
//

#import "JHAlignFlowLayout.h"

@interface JHAlignFlowLayout ()

@property (assign,nonatomic)JHCollectionViewAlignType type;

@property (assign,nonatomic)CGFloat rowCellTotalWidth;

@end

@implementation JHAlignFlowLayout

#pragma mark -
#pragma mark - init

-(instancetype)initWithAlighType:(JHCollectionViewAlignType)type{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        _type = type;
    }
    return self;
}


#pragma mark -
#pragma mark - overwrite

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSArray* layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    NSArray* layoutAttributes = [[NSArray alloc]initWithArray:layoutAttributes_t copyItems:YES];
    
    NSMutableArray* layoutAttributesTmp = [[NSMutableArray alloc]init];
    
    for (int index = 0; index < layoutAttributes.count; index ++) {
        UICollectionViewLayoutAttributes* currentAttr = layoutAttributes[index];                                                //当前cell
//        UICollectionViewLayoutAttributes* previousAttr = index == 0 ? nil : layoutAttributes[index - 1];                        //上一个cell
        UICollectionViewLayoutAttributes* nextAttr = index + 1 == layoutAttributes.count ? nil : layoutAttributes[index + 1];   //下一个cell
        
        [layoutAttributesTmp addObject:currentAttr];
        _rowCellTotalWidth += currentAttr.frame.size.width;
        
        if ([currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader] || [currentAttr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
            _rowCellTotalWidth = 0.0;
            [layoutAttributesTmp removeAllObjects];
            continue;
        }
        
//        CGFloat previousY = previousAttr == nil ? 0 : CGRectGetMaxY(previousAttr.frame);
        CGFloat currentY = CGRectGetMaxY(currentAttr.frame);
        CGFloat nextY = nextAttr == nil ? 0 : CGRectGetMaxY(nextAttr.frame);
        
        //cell未换行
        if (currentY != nextY) {
            [self resetLayoutAttributes:layoutAttributesTmp];
            
            _rowCellTotalWidth = 0.0;
            [layoutAttributesTmp removeAllObjects];
        }
    }
    
    return layoutAttributes;
}


#pragma mark -
#pragma mark - private

-(void)resetLayoutAttributes:(NSMutableArray*)layoutAttributes{
    switch (_type) {
        case JHCollectionViewAlignLeft:
        {
            [self alignLeftByLayoutAttributes:layoutAttributes];
        }
            break;
            
        case JHCollectionViewAlignCenter:
        {
            [self alignCenterByLayoutAttributes:layoutAttributes];
        }
            break;
            
        case JHCollectionViewAlignRight:
        {
            [self alignRightByLayoutAttributes:layoutAttributes];
        }
            break;
            
        default:
            break;
    }
}


-(void)alignLeftByLayoutAttributes:(NSArray*)layoutAttributes{
    UICollectionViewLayoutAttributes* firstAttributes = layoutAttributes.firstObject;
    CGFloat left = [self evaluatedSectionInsetForItemAtSection:firstAttributes.indexPath.section].left;
    
    for (UICollectionViewLayoutAttributes* attributes in layoutAttributes) {
        CGRect frame = attributes.frame;
        frame.origin.x = left;
        attributes.frame = frame;
        left += (frame.size.width + self.minimumInteritemSpacing);
    }
}


-(void)alignCenterByLayoutAttributes:(NSArray*)layoutAttributes{
    UICollectionViewLayoutAttributes* firstAttributes = layoutAttributes.firstObject;
    UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtSection:firstAttributes.indexPath.section];
    CGFloat left = (self.collectionView.frame.size.width  - sectionInset.left - sectionInset.right - _rowCellTotalWidth - self.minimumInteritemSpacing * (layoutAttributes.count - 1)) / 2.0;
    
    for (UICollectionViewLayoutAttributes* attributes in layoutAttributes) {
        CGRect frame = attributes.frame;
        frame.origin.x = left;
        attributes.frame = frame;
        left += (frame.size.width + self.minimumInteritemSpacing);
    }
}


-(void)alignRightByLayoutAttributes:(NSArray*)layoutAttributes{
    UICollectionViewLayoutAttributes* firstAttributes = layoutAttributes.firstObject;
    UIEdgeInsets sectionInset = [self evaluatedSectionInsetForItemAtSection:firstAttributes.indexPath.section];
    CGFloat width = self.collectionView.frame.size.width - sectionInset.right;
    
    for (NSInteger index = layoutAttributes.count - 1; index >= 0; index --) {
        UICollectionViewLayoutAttributes* attributes = layoutAttributes[index];
        CGRect frame = attributes.frame;
        frame.origin.x = width - frame.size.width;
        attributes.frame = frame;
        width -= (frame.size.width + self.minimumInteritemSpacing);
    }
}




-(UIEdgeInsets)evaluatedSectionInsetForItemAtSection:(NSInteger)section{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [(id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    else{
        return self.sectionInset;
    }
}



@end
