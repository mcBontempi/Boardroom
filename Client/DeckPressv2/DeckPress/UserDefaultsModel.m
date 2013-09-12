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


-(id) init{
  
  if (self = [super init]){
    
    if(![self load]){
      [self makeTestData];
    }
    
  }
  return self;
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

- (BOOL)load
{
  NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentDeckName"];
  self.currentDeckName = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding ];
  
  data = [[NSUserDefaults standardUserDefaults] objectForKey:@"decks"];
  if(data){
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(obj){
      _decks = obj;
      return YES;
    }
  }
  
  return NO;
}

- (void) save
{
  NSLog(@"saving model");
  
//  [[NSNotificationCenter defaultCenter] postNotificationName:TTTModelChanged object:nil];
  
  NSData *data = [self.currentDeckName dataUsingEncoding:NSUTF8StringEncoding];
  [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"currentDeckName"];
  
  data = [NSKeyedArchiver archivedDataWithRootObject:_decks];
  [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"decks"];
  [[NSUserDefaults standardUserDefaults] synchronize];

  NSLog(@"model saved");
}


@end
