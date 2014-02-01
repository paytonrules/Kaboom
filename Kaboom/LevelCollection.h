@class Level;

@protocol LevelCollection

-(void) next;
-(Level *) current;
-(void) reset;
@end