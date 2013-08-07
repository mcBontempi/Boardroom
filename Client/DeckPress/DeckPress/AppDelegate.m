#import "AppDelegate.h"
#import "Model.h"
#import "UserDefaultsModel.h"
#import "Uploader.h"
#import "DeckViewController.h"

@implementation AppDelegate {
  id<Model> _model;
  Uploader *_uploader;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _model = [[UserDefaultsModel alloc] init];
  [_model makeTestData];
  
  _uploader = [[Uploader alloc] init];
  
  DeckViewController *deckViewController = (DeckViewController *)self.window.rootViewController;
  
  deckViewController.deck = _model.currentDeck;
  deckViewController.uploader = _uploader;
  
  return YES;
}
			
@end
