//
//  DDTDetailViewController.h
//  DeckPress
//
//  Created by Daren David Taylor on 12/09/2013.
//  Copyright (c) 2013 DarenDavidTaylor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDTDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
