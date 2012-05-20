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

#import "KIFTestStep.h"

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
	
	NSLog(@"[INFO] spade loaded",self);
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
  TiThreadPerformOnMainThread(^{ 
    [view tap]; 
  }, YES);
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

  TiThreadPerformOnMainThread(^{ 
    [view tapAtPoint:point];
  }, YES);

  return true;
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

-(void)type:(id)args
{
  NSString * text;
  NSString * expectedResult;
  TiViewProxy * proxy;

  ENSURE_ARG_AT_INDEX(proxy, args, 0, TiViewProxy);
  ENSURE_ARG_AT_INDEX(text, args, 1, NSString);

  expectedResult = text;
  TiUIView * view = proxy.view;

  KIFTestStep * teststep = [[KIFTestStep alloc] init];

  // below is stolen from the square folks

  TiThreadPerformOnMainThread(^{ 
    // Wait for the keyboard
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);

    for (NSUInteger characterIndex = 0; characterIndex < [text length]; characterIndex++) {
      NSString *characterString = [text substringWithRange:NSMakeRange(characterIndex, 1)];

      if (![teststep _enterCharacter:characterString]) {
        // Attempt to cheat if we couldn't find the character
        if ([view respondsToSelector:@selector(setText:)]) {
          NSLog(@"Spade: Unable to find keyboard key for %@. Inserting manually.", characterString);
          [(UITextField *)view setText:[[(UITextField *)view text] stringByAppendingString:characterString]];
        } else {
          NSLog(@"Spade: Item does not look like a text entry field, can't insert character manually");
        }
      }
    }

    // This is probably a UITextField- or UITextView-ish view, so make sure it worked
    if ([view respondsToSelector:@selector(text)]) {
      // We trim \n and \r because they trigger the return key, so they won't show up in the final product on single-line inputs
      NSString *expected = [expectedResult ? expectedResult : text stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
      NSString *actual = [[view performSelector:@selector(text)] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
      if (![actual isEqualToString:expected]) {
        NSLog(@"Spade: failed to actually enter text \"%@\", instead it was \"%@\"", text, actual);
      }
    }
  }, YES);
}

-(TiViewProxy*)find:(id)arg
{
  ENSURE_SINGLE_ARG(arg, NSString);

  UIWindow * window = [UIApplication sharedApplication].keyWindow;
  if (!window) {
    window = [[UIApplication sharedApplication].windows objectAtIndex:0];
  }

  NSError * error = NULL;
  NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:arg options:0 error:&error];

  if (error) return NULL;

  UIView * found = [self findView:(UIView *)window withRegex: regex mustBeTiView: true];
  return [found proxy];
}

-(BOOL)tapText: (id) arg
{
  ENSURE_SINGLE_ARG(arg, NSString);

  UIWindow * window = [UIApplication sharedApplication].keyWindow;
  if (!window) {
    window = [[UIApplication sharedApplication].windows objectAtIndex:0];
  }

  NSError * error = NULL;
  NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:arg options:0 error:&error];

  if (error) return false;

  UIView * view = [self findView:(UIView *) window withRegex: regex mustBeTiView: false];

  if (view) {
    [view tap];
  } else {
    return false;
  }

  return true;
}

// findView is the powerhouse of view finding.  It takes a regex
// to match against.  With mustBeTiView we can only find views which have a
// proxy property, as these are Ti views.

-(UIView *)findView: (UIView *)view 
  withRegex: (NSRegularExpression *)regex 
  mustBeTiView: (BOOL)needsTiView
{
  NSString * text = NULL;

  // try to find some text to match against
  // This should work with buttons, textareas, textviews, and labels
  if ([view respondsToSelector:@selector(text)]) {
    text = [view text];
  } else if ([view respondsToSelector:@selector(titleLabel)]) {
    text = [[view titleLabel] text];
  } 


  // if we found some text, attempt a match against it
  if (text) {

    BOOL found = false;

    // run the regex on the text
    NSInteger matches = [regex 
      numberOfMatchesInString: text 
      options: 0 
      range: NSMakeRange(0, [text length])
    ];

    found = matches > 0 ? true : false;

    if (matches > 0) {
      if (needsTiView) {

        // only return views that are Titanium views
        if ([view respondsToSelector:@selector(proxy)]) {
          return view;
        }

        else {
          // try its parent
          UIView * parent = [view superview];
          if ([parent respondsToSelector:@selector(proxy)]) {
            return parent;
          }
        }
      } 

      else {
        // if we dont care whether or not its a ti view, just return the view
        return view;
      }
    } // if (matches > 0)
  } // if (text)

  // recurse
  if ([[view subviews] count] > 0) {
    for (id object in [view subviews]) {
      UIView * found = [self 
        findView: (UIView *)object 
        withRegex: regex 
        mustBeTiView: needsTiView
      ];
      if (found) return found;
    }
  }

  return nil;
}

@end

