//
//  Document.m
//  DeckPress
//
//  Created by Daren David Taylor on 18/12/2013.
//
//

#import "Document.h"
#import "PageGeneratorOperation.h"
#import "Uploader.h"

@implementation Document {
    NSArray *_pages;
    Uploader *_uploader;
    NSURL *_url;
}

- (id)initWithURL:(NSURL *)url room:(NSString *)room
{
    if (self = [super init]) {
        
        
        NSMutableArray *mutablePages = [[NSMutableArray alloc] init];
        
        for (NSUInteger i = 0 ; i < self.pageCount ; i++) {
            PageData *pageData = [[PageData alloc] init];
            [mutablePages addObject:pageData];
        }
        
        _pages = [mutablePages copy];
        
        _uploader = [[Uploader alloc] initWithRoom:room];
        
        _url = url;
    }
    
    return self;
}


- (NSUInteger)pageCount
{
    return [PageGeneratorOperation numberOfPagesWithPDFURL:_url];
}

- (void)turnedToPage:(NSUInteger)index
{
     [_uploader makePageDataForURL:_url index:index];
    
   // [_uploader doUpload:pageData ];
}

- (void)turnedToPageKnowingImageCorrect:(NSUInteger)index
{
    PageData *pageData = _pages[index];
    
    if (pageData) {
        [_uploader doUpload:pageData];
    }
}



- (void)makePageData:(NSUInteger)index
{
   
}

- (void)doUpload:(PageData *)pageData
{

}






@end
