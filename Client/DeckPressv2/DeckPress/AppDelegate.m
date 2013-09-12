#import "AppDelegate.h"
#import "Model.h"
#import "UserDefaultsModel.h"
#import "Uploader.h"
#import "DeckViewControllerDelegate.h"
#import "DeckViewController.h"

@interface AppDelegate () <DeckViewControllerDelegate>
@end

@implementation AppDelegate {
  id<Model> _model;
  Uploader *_uploader;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  [_model save];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _model = [[UserDefaultsModel alloc] init];
  
  _uploader = [[Uploader alloc] init];
  
  DeckViewController *deckViewController = (DeckViewController *)self.window.rootViewController;
  
  deckViewController.deck = _model.currentDeck;
  deckViewController.uploader = _uploader;
  deckViewController.delegate = self;
  
  return YES;
}

- (void)saveDeck
{
  [_model save];
}
			
@end
