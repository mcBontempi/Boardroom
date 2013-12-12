//
//  PageGenerator.h
//  DeckPress
//
//  Created by Daren David Taylor on 08/12/2013.
//
//

#import <Foundation/Foundation.h>

@interface PageGenerator : NSObject

- (id)objectAtIndex:(NSUInteger)index;

- (id)initWithDocURL:(NSURL *)docURL;

+ (NSString*)MD5StringOfData:(NSData*)inputData;

+ (NSInteger)numberOfPagesWithPDFURL:(NSURL *)url;

@end
