//
//  DDTAppDelegate.h
//  DeckPress
//
//  Created by Daren David Taylor on 12/09/2013.
//  Copyright (c) 2013 DarenDavidTaylor.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
