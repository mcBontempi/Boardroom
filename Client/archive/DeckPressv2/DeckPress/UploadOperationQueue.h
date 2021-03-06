//
//  Uploader.h
//  DeckPress
//
//  Created by Daren taylor on 05/08/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Slide.h"

@interface UploadOperationQueue : NSObject

- (void)addOperation:(NSOperation *)operation;

- (void)reset;

- (BOOL)isBusy;

@end
