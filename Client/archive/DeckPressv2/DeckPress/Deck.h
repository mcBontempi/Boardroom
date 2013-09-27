//
//  Deck.h
//  DeckPress
//
//  Created by daren taylor on 29/07/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Deck : NSObject

  @property(nonatomic, strong) NSMutableArray *slides;

- (void)makeTestData;

- (void)moveFrom:(NSUInteger)from to:(NSUInteger)to;

@end
