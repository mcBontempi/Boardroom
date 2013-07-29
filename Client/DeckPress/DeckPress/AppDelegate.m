#import "AppDelegate.h"
#import "Model.h"
#import "UserDefaultsModel.h"

#import "PresentationViewController.h"

@implementation AppDelegate {
  id<Model> _model;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  _model = [[UserDefaultsModel alloc] init];
  [_model makeTestData];
  
  PresentationViewController *presentationViewController = (PresentationViewController *)self.window.rootViewController;
  
  presentationViewController.deck = _model.currentDeck;
  
  return YES;
}
			
@end
