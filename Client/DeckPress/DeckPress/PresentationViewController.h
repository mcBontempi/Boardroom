//
//  PresentationViewController.h
//  DeckPress
//
//  Created by Daren taylor on 20/06/2013.
//  Copyright (c) 2013 Daren taylor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LXReorderableCollectionViewFlowLayout/LXReorderableCollectionViewFlowLayout.h>

#import <NeoveraColorPicker/NEOColorPickerViewController.h>
#import "Deck.h"

@interface PresentationViewController : UIViewController <UIScrollViewDelegate, UITextViewDelegate, LXReorderableCollectionViewDatasource, LXReorderableCollectionViewDelegate, NEOColorPickerViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *oldDeck;

@property (nonatomic, strong) Deck *deck;

@end
