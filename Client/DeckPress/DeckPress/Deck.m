//
//  Deck.m
//  DeckPress
//
//  Created by daren taylor on 29/07/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import "Deck.h"
#import "Slide.h"

@implementation Deck

- (void)makeTestData
{
  Slide *slide1 = [[Slide alloc] init];
  slide1.text = @"\nDarenDavidTaylor.com\n\niOS Developer";
  slide1.backgroundColor = [UIColor grayColor];
  slide1.textColor = [UIColor whiteColor];
  
  Slide *slide2 = [[Slide alloc] init];
  slide2.text = @"\n\nDelegation Pattern";
  slide2.backgroundColor = [UIColor redColor];
  slide2.textColor = [UIColor whiteColor];
  
  Slide *slide3 = [[Slide alloc] init];
  slide3.text = @"\nDelegates a task to another object";
  slide3.backgroundColor = [UIColor redColor];
  slide3.textColor = [UIColor whiteColor];
  
  Slide *slide4 = [[Slide alloc] init];
  slide4.text = @"@protocol TaxiDelegate <NSObject>\n- (Location *)destination;\n@end";
  slide4.backgroundColor = [UIColor blackColor];
  slide4.textColor = [UIColor greenColor];
  
  Slide *slide5 = [[Slide alloc] init];
  slide5.text = @"@implementation Person : NSObject  <TaxiDelegate>";
  slide5.backgroundColor = [UIColor blackColor];
  slide5.textColor = [UIColor greenColor];
  
  self.slides = [[NSMutableArray alloc] initWithObjects:slide1, slide2, slide3, slide4, slide5, nil];
}

- (void)moveFrom:(NSUInteger)from to:(NSUInteger)to
{
  Slide *slide = [self.slides objectAtIndex:from];
  [self.slides removeObjectAtIndex:from];
  [self.slides insertObject:slide atIndex:to];
}
@end
