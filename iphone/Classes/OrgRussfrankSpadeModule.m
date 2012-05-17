/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "CGGeometry-KIFAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIScrollView-KIFAdditions.h"
#import "UITouch-KIFAdditions.h"
#import "UIView-KIFAdditions.h"
#import "UIWindow-KIFAdditions.h"

#import "OrgRussfrankSpadeModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

#import "TiUIView.h"
#import "TiUIViewProxy.h"

@implementation OrgRussfrankSpadeModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"361f99ba-409a-4e4f-a95e-5481a4f14d92";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"org.russfrank.spade";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

// tap in the middle of the view
-(void)tap:(id)args
{
  ENSURE_SINGLE_ARG(args,TiViewProxy);
  TiUIView * view = ((TiViewProxy *) args).view;

  // view tap is given to us by the wonderful folks at square.  It actually taps
  // squarely in the center of the view.
  [view tap];
}

// tap at a particular point
-(void)tapAt:(id)args
{
  TiViewProxy * proxy;
  id arg1;

  ENSURE_ARG_AT_INDEX(proxy, args, 0, TiViewProxy);
  ENSURE_ARG_AT_INDEX(arg1, args, 1, NSObject);

  TiUIView * view = proxy.view;

  BOOL validPoint;
  CGPoint point = [TiUtils pointValue:arg1 valid:&validPoint];

  if (!validPoint) {
    [self throwException:TiExceptionInvalidType subreason:@"Parameter is not convertable to a TiPoint" location:CODELOCATION];
  }

  [view tapAtPoint:point];
}

// drag from one point to another
-(void)drag:(id)args
{
  TiViewProxy * proxy;
  id arg1, arg2;

  ENSURE_ARG_AT_INDEX(proxy, args, 0, TiViewProxy);
  ENSURE_ARG_AT_INDEX(arg1, args, 1, NSObject);
  ENSURE_ARG_AT_INDEX(arg2, args, 2, NSObject);

  TiUIView * view = proxy.view;

  BOOL validPoint;
  CGPoint from = [TiUtils pointValue:arg1 valid:&validPoint];

  if (!validPoint) {
    [self throwException:TiExceptionInvalidType subreason:@"Parameter is not convertable to a TiPoint" location:CODELOCATION];
  }

  CGPoint to = [TiUtils pointValue:arg2 valid:&validPoint];

  if (!validPoint) {
    [self throwException:TiExceptionInvalidType subreason:@"Parameter is not convertable to a TiPoint" location:CODELOCATION];
  }

  [view dragFromPoint:from toPoint:to];
}

// checks to see if a view is currently visible on screen
-(BOOL)visible:(id)args
{
  ENSURE_SINGLE_ARG(args,TiViewProxy);
  TiUIView * view = ((TiViewProxy *) args).view;

  return [view isTappable];
}

@end
