//
//  JHAlignFlowLayout.h
//  
//
//  Created by 金华 on 2019/5/26.
//  Copyright © 2019 金华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,JHCollectionViewAlignType){
    GHCollectionViewAlignLeft,
    GHCollectionViewAlignCenter,
    GHCollectionViewAlignRight,
};

@interface JHAlignFlowLayout : UICollectionViewFlowLayout

-(instancetype)initWithAlighType:(JHCollectionViewAlignType)type;

@end
