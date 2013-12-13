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
        _operationQueue.maxConcurrentOperationCount = 10;
    }
    return self;
}

- (void)addOperation:(NSOperation *)operation
{
    [_operationQueue addOperation:operation];
}


- (void)cancelOperationWithTypeArray:(NSArray *)cancelOperationClasses
{
    NSLog(@"operations before %@", [_operationQueue operations]);
    
    [[_operationQueue operations] enumerateObjectsUsingBlock:^(NSOperation *runningOperation, NSUInteger idx, BOOL *stop) {
        [cancelOperationClasses enumerateObjectsUsingBlock:^(Class cancelOperationClass , NSUInteger idx, BOOL *stop) {
            if ([runningOperation isKindOfClass:cancelOperationClass]) {
                [runningOperation cancel];
            }
        }];
    }];
    
    NSLog(@"operations before %@", [_operationQueue operations]);
}

- (void)reset
{
    [_operationQueue cancelAllOperations];
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = 10;
}

- (BOOL)isBusy
{
    return _operationQueue.operationCount;
}

@end
