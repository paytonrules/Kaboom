#import <cocos2d/CCScene.h>
#import "CCDirector.h"

@implementation CCDirector
@synthesize delegate = _delegate;

+ (CCDirector *)sharedDirector {
  return nil;
}

- (CGSize)winSize {
  CGSize result;
  return result;
}

- (CGSize)winSizeInPixels {
  CGSize result;
  return result;
}

- (void)reshapeProjection:(CGSize)newWindowSize {

}

- (void)setViewport {

}

- (CGPoint)convertToGL:(CGPoint)p {
  CGPoint result;
  return result;
}

- (CGPoint)convertToUI:(CGPoint)p {
  CGPoint result;
  return result;
}

- (float)getZEye {
  return 0;
}

- (void)runWithScene:(CCScene *)scene {

}

- (void)pushScene:(CCScene *)scene {

}

- (void)popScene {

}

- (void)popToRootScene {

}

- (void)popToSceneStackLevel:(NSUInteger)level {

}

- (void)replaceScene:(CCScene *)scene {

}

- (void)end {

}

- (void)pause {

}

- (void)resume {

}

- (void)stopAnimation {

}

- (void)startAnimation {

}

- (void)drawScene {

}

- (void)purgeCachedData {

}

- (void)setGLDefaultValues {

}

- (void)setAlphaBlending:(BOOL)on {

}

- (void)setDepthTest:(BOOL)on {

}

- (void)createStatsLabel {

}

- (void)setNextScene {

}

- (void)showStats {

}

- (void)calculateDeltaTime {

}

- (void)calculateMPF {

}


@end
