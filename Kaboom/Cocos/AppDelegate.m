#import <cocos2d/cocos2d.h>
#import <iAd/iAd.h>
#import "AppDelegate.h"
#import "SizeService.h"
#import "CocosSizeStrategy.h"
#import "AdDelegate.h"
#import "CocosDirectorAdapter.h"
#import "GCHelperSpike.h"
#import "MainMenuLayer.h"

@interface AppController()

@property(strong) AdDelegate *adDelegate;

@end

@implementation AppController

@synthesize window=window_, director=director_;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
	director_.wantsFullScreenLayout = YES;

	// CCGLView creation
	// viewWithFrame: size of the OpenGL view. For full screen use [_window bounds]
	//  - Possible values: any CGRect
	// pixelFormat: Format of the render buffer. Use RGBA8 for better color precision (eg: gradients). But it takes more memory and it is slower
	//	- Possible values: kEAGLColorFormatRGBA8, kEAGLColorFormatRGB565
	// depthFormat: Use stencil if you plan to use CCClippingNode. Use Depth if you plan to use 3D effects, like CCCamera or CCNode#vertexZ
	//  - Possible values: 0, GL_DEPTH_COMPONENT24_OES, GL_DEPTH24_STENCIL8_OES
	// sharegroup: OpenGL sharegroup. Useful if you want to share the same OpenGL context between different threads
	//  - Possible values: nil, or any valid EAGLSharegroup group
	// multiSampling: Whether or not to enable multisampling
	//  - Possible values: YES, NO
	// numberOfSamples: Only valid if multisampling is enabled
	//  - Possible values: 0 to glGetIntegerv(GL_MAX_SAMPLES_APPLE)
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
                                 pixelFormat:kEAGLColorFormatRGB565
                                 depthFormat:0
                          preserveBackbuffer:NO
                                  sharegroup:nil
                               multiSampling:NO
                             numberOfSamples:0];
  
  // attach the openglView to the director
	[director_ setView:glView];
  [director_ setDelegate:self];
  
	// Display FSP and SPF
	[director_ setDisplayStats:YES];
	
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];
	
	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
	//	[director setProjection:kCCDirectorProjection3D];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change this setting at any time.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	
	// If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				    // Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-hd"];					          // Default on iPad is "ipad", but use hd for texturepacker
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"
	
	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

  [SizeService setStrategy:[CocosSizeStrategy new]];
	
	// set the director as the root view controller
	[window_ setRootViewController:director_];
	
	// make main window visible
	[window_ makeKeyAndVisible];

  // Need to store a ref to adDelegate so ARC doesn't let it get deleted
  // Stick this on KaboomLayer
  ADBannerView *banner = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
  CGSize flippedSize = CGSizeMake(window_.bounds.size.height, window_.bounds.size.width);
  CGSize bannerBounds = [banner sizeThatFits:flippedSize];
  [banner setFrame:CGRectMake(0, 0, bannerBounds.width, bannerBounds.height)];

  self.adDelegate = [AdDelegate newWithDirector: [CocosDirectorAdapter newWithCocosDirector:director_]];
  banner.delegate = _adDelegate;
  [director_.view addSubview:banner];

  [[GCHelperSpike sharedInstance] authenticateLocalUser];
  [director_ runWithScene: [MainMenuLayer scene]];

	return YES;
}

-(NSUInteger) supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskLandscape;
}

// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
  [director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[director_ setNextDeltaTimeZero:YES];
	[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
  [director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

@end
