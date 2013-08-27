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
#import "DeckViewControllerDelegate.h"

@interface DeckViewController : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) Deck *deck;
@property (nonatomic, strong) Uploader *uploader;
@property (nonatomic, weak) id<DeckViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *ROOMTEXTFIELD;
@end
