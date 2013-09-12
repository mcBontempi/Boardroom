//
//  DPCollectionViewLayout.m
//  DeckPress
//
//  Created by Daren taylor on 05/08/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import "DPCollectionViewLayout.h"

@implementation DPCollectionViewLayout

- (void)setDefaults
{
  // only one row.
  CGRect bounds = [[UIScreen mainScreen] bounds];
  CGFloat spacing = bounds.size.height  - self.itemSize.height ;
  self.sectionInset = UIEdgeInsetsMake(0, 0, spacing, 0);
}

@end
