//
//  GCHelperSpike.h
//  Kaboom
//
//  Created by Eric Smith on 2/26/14.
//  Copyright (c) 2014 Eric Smith. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCHelperSpike : NSObject

@property (assign, readonly) BOOL gameCenterAvailable;

+(instancetype) sharedInstance;
-(void) authenticateLocalUser;

@end
