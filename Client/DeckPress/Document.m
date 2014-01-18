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
    NSMutableArray *_pages;
    Uploader *_uploader;
    NSURL *_url;
    
    NSUInteger _currentPage;
}

- (id)initWithURL:(NSURL *)url room:(NSString *)room
{
    if (self = [super init]) {
        
        _url = url;
        
        _currentPage = 0;
        
        _pages = [[NSMutableArray alloc] init];
        
        for (NSUInteger i = 0 ; i < self.pageCount ; i++) {
            PageData *pageData = [[PageData alloc] init];
            [_pages addObject:pageData];
        }
        
        _uploader = [[Uploader alloc] initWithRoom:room];
        
    }
    
    return self;
}


- (NSUInteger)pageCount
{
    if(!_pageCount) {
        _pageCount = [PageGeneratorOperation numberOfPagesWithPDFURL:_url];
    }
    
    return _pageCount;
}

- (void)turnedToPage:(NSUInteger)index
{
    _currentPage = index;
    
    PageData *pageData = _pages[index];
    
    if(!pageData.generated) {
        
        [_uploader makePageDataForURL:_url index:index succcessBlock:^(PageData *pageData){      [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChangedNotification" object:pageData];
   
            [self storePage:pageData];
            
            [_uploader doUpload:pageData];
        }];
    }
    else {
        [_uploader doUpload:pageData ];
    }
    
    [self checkSurroundingPages];
}

- (void)checkSurroundingPages
{
    if(_currentPage+1 < self.pageCount) {
        
        PageData *pageData = _pages[_currentPage+1];
        
        if(!pageData.generated) {
            [_uploader makePageDataForURL:_url index:_currentPage+1 succcessBlock:^(PageData *pageData){ [[NSNotificationCenter defaultCenter] postNotificationName:@"pageChangedNotification" object:pageData];
                
                [self storePage:pageData];
            }];
        }
    }
}



- (void)storePage:(PageData *)pageData
{
    _pages[pageData.index] = pageData;
}

- (void)makePageData:(NSUInteger)index
{
    
}

- (void)doUpload:(PageData *)pageData
{
    
}

- (void)uploadAll
{
  for (NSInteger index = 0 ; index < self.pageCount ; index++) {
    [self turnedToPage:index];
  }
}






@end
