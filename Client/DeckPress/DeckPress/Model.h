#import <Foundation/Foundation.h>
#import "Deck.h"

@protocol Model <NSObject>

- (void)makeTestData;
- (Deck *)currentDeck;

@end

/*

 - (NSData *)getJSONForPlan:(NSString *)planName;
 - (void)makeTestData;
 - (void)save;
 - (BOOL)load;
 - (NSArray *)getWeek:(NSInteger)weekIndex;
 - (void) setWeek:(NSInteger)weekIndex array:(NSArray *)array;
 - (NSMutableArray *)makeCopyOfWeek:(NSArray *)weekToCopy;
 - (NSInteger)weekCount;
 - (NSUInteger)planCount;
 - (NSString *)planName:(NSUInteger)index;
 - (void)deletePlan:(NSString *)index;
 - (void)clearPlan;
 - (void)makePlanNamed:(NSString *)planName;
 - (void)selectPlan:(NSString *)planName;
 - (void)createPlanFromJSONDataAndMakeCurrent:(NSData *)jsonData named:(NSString *)name;
 - (NSString *)currentPlan;
 - (BOOL) checkPlanNameIsAlreadyTaken:(NSString *)testName;

*/