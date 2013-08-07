//
//  Uploader.m
//  DeckPress
//
//  Created by Daren taylor on 05/08/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import "UploadOperationQueue.h"

@implementation UploadOperationQueue
{
  NSOperationQueue *_operationQueue;
}

- (id)init
{
  if (self = [super init]) {
    _operationQueue = [[NSOperationQueue alloc] init];
  }
  return self;
}

- (void)addOperation:(NSOperation *)operation
{
  [_operationQueue addOperation:operation];
}

- (void)reset
{
  [_operationQueue cancelAllOperations];
}

@end
