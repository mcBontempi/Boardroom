//
//  Model.m
//  DeckPress
//
//  Created by daren taylor on 29/07/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import "UserDefaultsModel.h"

@implementation UserDefaultsModel
{
  NSArray *_decks;
}

- (void)makeTestData
{
  Deck *deck = [[Deck alloc] init];
  [deck makeTestData];
  
  _decks = [[NSArray alloc] initWithObjects:deck, nil];
}

- (Deck *)currentDeck
{
  return _decks[0];
}

@end
