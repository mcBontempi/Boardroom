//
//  SwipeViewControllerDelegate.h
//  Pods
//
//  Created by Daren David Taylor on 28/10/2013.
//
//

#import <Foundation/Foundation.h>
#import "PageData.h"

@protocol SwipeViewControllerDelegate <NSObject>

- (void)doUpload:(PageData *)pageData;
- (void)makePageData:(NSUInteger)index;

@end
