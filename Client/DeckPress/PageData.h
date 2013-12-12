//
//  pageData.h
//  DeckPress
//
//  Created by Daren David Taylor on 08/12/2013.
//
//

#import <Foundation/Foundation.h>

@interface PageData : NSObject

@property (nonatomic, strong) NSData *png;
@property (nonatomic, strong) NSString *hash;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) BOOL generated;

@end
