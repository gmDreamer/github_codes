//
//  ZXSearchField.m
//  zhixin
//
//  Created by linyi on 17/7/18.
//  Copyright © 2017年 oa. All rights reserved.
//

#import "ZXSearchField.h"
#import "ZXSearchFieldCell.h"
@implementation ZXSearchField
+(void)setCellClass:(Class)factoryId{
    [super setCellClass:[ZXSearchFieldCell class]];
}
+(Class)cellClass{
    return [ZXSearchFieldCell class];
}
@end
