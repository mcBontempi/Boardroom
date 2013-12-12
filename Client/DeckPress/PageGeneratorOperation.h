//
//  PageGeneratorOperation.h
//  DeckPress
//
//  Created by Daren David Taylor on 12/12/2013.
//
//


#import <Foundation/Foundation.h>
#import "PageData.h"

typedef void (^pageDataBlock)(PageData *pageData);

@interface PageGeneratorOperation : NSOperation

- (id)initWitdocURL:(NSURL *)docURL index:(NSUInteger)index successBlock:(pageDataBlock)successBlock;

+ (NSInteger)numberOfPagesWithPDFURL:(NSURL *)url;
@end
