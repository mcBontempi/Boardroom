//
//  DDTMasterViewController.h
//  DeckPress
//
//  Created by Daren David Taylor on 12/09/2013.
//  Copyright (c) 2013 DarenDavidTaylor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDTDetailViewController;

#import <CoreData/CoreData.h>

@interface DDTMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DDTDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
