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

- (PageData *)turnedToPage:(NSInteger)page;

@end
