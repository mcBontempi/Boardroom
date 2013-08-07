#import "AppDelegate.h"
#import "Model.h"
#import "UserDefaultsModel.h"

#import "DeckViewController.h"

@implementation AppDelegate {
  id<Model> _model;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _model = [[UserDefaultsModel alloc] init];
  [_model makeTestData];
  
  DeckViewController *deckViewController = (DeckViewController *)self.window.rootViewController;
  
  deckViewController.deck = _model.currentDeck;
  
  return YES;
}
			
@end
