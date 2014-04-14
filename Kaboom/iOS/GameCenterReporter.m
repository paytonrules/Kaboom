#import "GameCenterReporter.h"
#import <GameKit/GameKit.h>

@implementation GameCenterReporter

-(void) reportScore:(int64_t) score forLeaderboardId:(NSString *) leaderboard
{
  GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier: leaderboard];
  scoreReporter.value = score;
  scoreReporter.context = 0;
  
  NSArray *scores = @[scoreReporter];
  [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
    //Do something interesting here.
  }];
}

-(void) report:(int64_t) score
{
  GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
  
  [localPlayer loadDefaultLeaderboardIdentifierWithCompletionHandler:
   ^(NSString *leaderboardIdentifier, NSError *error) {
     [self reportScore:score forLeaderboardId:leaderboardIdentifier];
   }];
}

@end
