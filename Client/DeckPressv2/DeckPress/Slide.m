//
//  Slide.m
//  DeckPress
//
//  Created by daren taylor on 29/07/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import "Slide.h"

@implementation Slide

- (void)encodeWithCoder:(NSCoder *)coder
{
  [coder encodeObject:self.text forKey:@"text"];
  [coder encodeObject:self.backgroundColor forKey:@"backgroundColor"];
  [coder encodeObject:self.textColor forKey:@"textColor"];
  [coder encodeObject:self.image forKey:@"image"];
}

- (id)initWithCoder:(NSCoder *)decoder{
  
  if(self = [super init]){
    self.text = [decoder decodeObjectForKey:@"text"];
    self.backgroundColor = [decoder decodeObjectForKey:@"backgroundColor"];
    self.textColor = [decoder decodeObjectForKey:@"textColor"];
    self.image = [decoder decodeObjectForKey:@"image"];
  }
  return self;
}


@end
