//
//  Document.h
//  DeckPress
//
//  Created by Daren David Taylor on 18/12/2013.
//
//

#import <Foundation/Foundation.h>

@interface Document : NSObject

- (id)initWithURL:(NSURL *)url room:(NSString *)room;

- (void)turnedToPage:(NSUInteger)index;
- (void)turnedToPageKnowingImageCorrect:(NSUInteger)index;

- (void)uploadAll;

@property (nonatomic) NSUInteger pageCount;


@end
