//
//  DeckViewController.h
//  DeckPress
//
//  Created by Daren taylor on 05/08/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "Uploader.h"

@interface DeckViewController : UICollectionViewController
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) Uploader *uploader;
@end
