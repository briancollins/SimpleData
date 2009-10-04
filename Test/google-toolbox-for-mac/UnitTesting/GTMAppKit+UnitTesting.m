//
//  GTMAppKit+UnitTesting.m
//  
//  Categories for making unit testing of graphics/UI easier.
//  
//  Copyright 2006-2008 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
// 
//  http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import "GTMDefines.h"
#import "GTMAppKit+UnitTesting.h"
#import "GTMGeometryUtils.h"
#import "GTMMethodCheck.h"

#if MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_4
 #define ENCODE_NSINTEGER(coder, i, key) [(coder) encodeInt:(i) forKey:(key)]
#else
 #define ENCODE_NSINTEGER(coder, i, key) [(coder) encodeInteger:(i) forKey:(key)]
#endif

@implementation NSApplication (GMUnitTestingAdditions) 
GTM_METHOD_CHECK(NSObject, gtm_unitTestEncodeState:);  // COV_NF_LINE

- (void)gtm_unitTestEncodeState:(NSCoder*)inCoder {
  [super gtm_unitTestEncodeState:inCoder];
  ENCODE_NSINTEGER(inCoder, [[self mainWindow] windowNumber], @"ApplicationMainWindow");
   
  // Descend down into the windows allowing them to store their state
  NSEnumerator *windowEnum = [[self windows] objectEnumerator];
  NSWindow *window = nil;
  int i = 0;
  while ((window = [windowEnum nextObject])) {
    if ([window isVisible]) {
      // Only record visible windows because invisible windows may be closing on us
      // This appears to happen differently in 64 bit vs 32 bit, and items
      // in the window may hold an extra retain count for a while until the 
      // event loop is spun. To avoid all this, we just don't record non
      // visible windows.
      // See rdar://5851458 for details.      
      [inCoder encodeObject:window forKey:[NSString stringWithFormat:@"Window %d", i]];
      i = i + 1;
    }
  }
  
  // and encode the menu bar
  NSMenu *mainMenu = [self mainMenu];
  if (mainMenu) {
    [inCoder encodeObject:mainMenu forKey:@"MenuBar"];
  }
}
@end

@implementation NSWindow (GMUnitTestingAdditions) 

- (CGImageRef)gtm_createUnitTestImage {  
  return [[[self contentView] superview] gtm_createUnitTestImage];
}

- (void)gtm_unitTestEncodeState:(NSCoder*)inCoder {
  [super gtm_unitTestEncodeState:inCoder];
  [inCoder encodeObject:[self title] forKey:@"WindowTitle"];
  [inCoder encodeBool:[self isVisible] forKey:@"WindowIsVisible"];
  // Do not record if window is key, because users running unit tests 
  // and clicking around to other apps, could change this mid test causing 
  // issues.
  // [inCoder encodeBool:[self isKeyWindow] forKey:@"WindowIsKey"];
  [inCoder encodeBool:[self isMainWindow] forKey:@"WindowIsMain"];
  [inCoder encodeObject:[self contentView] forKey:@"WindowContent"];
}

@end

@implementation NSControl (GTMUnitTestingAdditions) 

//  Encodes the state of an object in a manner suitable for comparing
//  against a master state file so we can determine whether the
//  object is in a suitable state.
//
//  Arguments:
//    inCoder - the coder to encode our state into
- (void)gtm_unitTestEncodeState:(NSCoder*)inCoder {
  [super gtm_unitTestEncodeState:inCoder];
  [inCoder encodeObject:[self class] forKey:@"ControlType"];
  [inCoder encodeObject:[self objectValue] forKey:@"ControlValue"];
  [inCoder encodeObject:[self selectedCell] forKey:@"ControlSelectedCell"];
  ENCODE_NSINTEGER(inCoder, [self tag], @"ControlTag");
  [inCoder encodeBool:[self isEnabled] forKey:@"ControlIsEnabled"];
}

@end

@implementation NSTextField (GTMUnitTestingAdditions)

- (BOOL)gtm_shouldEncodeStateForSubviews {
  return NO;
}

@end

@implementation NSCell (GTMUnitTestingAdditions) 

//  Encodes the state of an object in a manner suitable for comparing
//  against a master state file so we can determine whether the
//  object is in a suitable state.
//
//  Arguments:
//    inCoder - the coder to encode our state into
- (void)gtm_unitTestEncodeState:(NSCoder*)inCoder {
  [super gtm_unitTestEncodeState:inCoder];
  BOOL isImageCell = NO;
  if ([self hasValidObjectValue]) {
    id val = [self objectValue];
    [inCoder encodeObject:val forKey:@"CellValue"];
    isImageCell = [val isKindOfClass:[NSImage class]];
  }
  if (!isImageCell) {
    // Image cells have a title that includes addresses that aren't going
    // to be constant, so we don't encode them. All the info we need
    // is going to be in the CellValue encoding.
    [inCoder encodeObject:[self title] forKey:@"CellTitle"];
  }
  ENCODE_NSINTEGER(inCoder, [self state], @"CellState");
  ENCODE_NSINTEGER(inCoder, [self tag], @"CellTag");
}

@end

@implementation NSImage (GTMUnitTestingAdditions) 

- (void)gtm_unitTestEncodeState:(NSCoder*)inCoder {
  [super gtm_unitTestEncodeState:inCoder];
  [inCoder encodeObject:NSStringFromSize([self size]) forKey:@"ImageSize"];
  [inCoder encodeObject:[self name] forKey:@"ImageName"];
}

- (CGImageRef)gtm_createUnitTestImage {
  // Create up a context
  NSSize size = [self size];
  NSRect rect = GTMNSRectOfSize(size);
  CGContextRef contextRef = [self gtm_createUnitTestBitmapContextOfSize:GTMNSSizeToCGSize(size)
                                                                   data:NULL];
  NSGraphicsContext *bitmapContext = [NSGraphicsContext graphicsContextWithGraphicsPort:contextRef
                                                                                flipped:NO];
  _GTMDevAssert(bitmapContext, @"Couldn't create ns bitmap context");
  
  [NSGraphicsContext saveGraphicsState];
  [NSGraphicsContext setCurrentContext:bitmapContext];
  [self drawInRect:rect fromRect:rect operation:NSCompositeCopy fraction:1.0];
  
  CGImageRef image = CGBitmapContextCreateImage(contextRef);
  CFRelease(contextRef);
  [NSGraphicsContext restoreGraphicsState];
  return image;
}

@end

@implementation NSMenu (GTMUnitTestingAdditions)

//  Encodes the state of an object in a manner suitable for comparing
//  against a master state file so we can determine whether the
//  object is in a suitable state.
//
//  Arguments:
//    inCoder - the coder to encode our state into
- (void)gtm_unitTestEncodeState:(NSCoder*)inCoder {
  [super gtm_unitTestEncodeState:inCoder];
  // Hack here to work around
  // rdar://5881796 Application menu item title wrong when accessed programatically
  // which causes us to have different results on x86_64 vs x386.
  // Hack is braced intentionally. We don't record the title of the 
  // "application" menu or it's menu title because they are wrong on 32 bit.
  // They appear to work right on 64bit.
  {
    NSMenu *mainMenu = [NSApp mainMenu];
    NSMenu *appleMenu = [[mainMenu itemAtIndex:0] submenu];
    if (![self isEqual:appleMenu]) {
      [inCoder encodeObject:[self title] forKey:@"MenuTitle"];
    }
  }
  // Descend down into the menuitems allowing them to store their state
  NSEnumerator *menuItemEnum = [[self itemArray] objectEnumerator];
  NSMenuItem *menuItem = nil;
  for (int i = 0; (menuItem = [menuItemEnum nextObject]); ++i) {
    [inCoder encodeObject:menuItem forKey:[NSString stringWithFormat:@"MenuItem %d", i]];
  }
}

@end

@implementation NSMenuItem (GTMUnitTestingAdditions)

- (void)gtm_unitTestEncodeState:(NSCoder*)inCoder {
  [super gtm_unitTestEncodeState:inCoder];
  // Hack here to work around
  // rdar://5881796 Application menu item title wrong when accessed programatically
  // which causes us to have different results on x86_64 vs x386.
  // See comment above.
  {
    NSMenu *mainMenu = [NSApp mainMenu];
    NSMenuItem *appleMenuItem = [mainMenu itemAtIndex:0];
    if (![self isEqual:appleMenuItem]) {
      [inCoder encodeObject:[self title] forKey:@"MenuItemTitle"];
    }
  }
  [inCoder encodeObject:[self keyEquivalent] forKey:@"MenuItemKeyEquivalent"];
  [inCoder encodeBool:[self isSeparatorItem] forKey:@"MenuItemIsSeparator"];
  ENCODE_NSINTEGER(inCoder, [self state], @"MenuItemState");
  [inCoder encodeBool:[self isEnabled] forKey:@"MenuItemIsEnabled"];
  [inCoder encodeBool:[self isAlternate] forKey:@"MenuItemIsAlternate"];
  [inCoder encodeObject:[self toolTip] forKey:@"MenuItemTooltip"];
  ENCODE_NSINTEGER(inCoder, [self tag], @"MenuItemTag");
  ENCODE_NSINTEGER(inCoder, [self indentationLevel], @"MenuItemIndentationLevel");
  
  // Do our submenu if neccessary
  if ([self hasSubmenu]) {
    [inCoder encodeObject:[self submenu] forKey:@"MenuItemSubmenu"];
  }
}

@end

//  A view that allows you to delegate out drawing using the formal
//  GTMUnitTestViewDelegate protocol above. This is useful when writing up unit
//  tests for visual elements.
//  Your test will often end up looking like this:
//  - (void)testFoo {
//   GTMAssertDrawingEqualToFile(self, NSMakeSize(200, 200), @"Foo", nil, nil);
//  }
//  and your testSuite will also implement the unitTestViewDrawRect method to do
//  it's actual drawing. The above creates a view of size 200x200 that draws
//  it's content using |self|'s unitTestViewDrawRect method and compares it to
//  the contents of the file Foo.tif to make sure it's valid
@implementation GTMUnitTestView

- (id)initWithFrame:(NSRect)frame 
             drawer:(id<GTMUnitTestViewDrawer>)drawer 
        contextInfo:(void*)contextInfo {
  self = [super initWithFrame:frame];
  if (self != nil) {
    drawer_ = [drawer retain];
    contextInfo_ = contextInfo;
  }
  return self;
}

- (void)dealloc {
  [drawer_ release];
  [super dealloc];
}


- (void)drawRect:(NSRect)rect {
  [drawer_ gtm_unitTestViewDrawRect:rect contextInfo:contextInfo_];
}


@end

@implementation NSView (GTMUnitTestingAdditions) 

//  Returns an image containing a representation of the object
//  suitable for use in comparing against a master image.
//  Does all of it's drawing with smoothfonts and antialiasing off
//  to avoid issues with font smoothing settings and antialias differences
//  between ppc and x86.
//
//  Returns:
//    an image of the object
- (CGImageRef)gtm_createUnitTestImage {
  // Create up a context
  NSRect bounds = [self bounds];
  CGContextRef contextRef = [self gtm_createUnitTestBitmapContextOfSize:GTMNSSizeToCGSize(bounds.size)
                                                                   data:NULL];
  NSGraphicsContext *bitmapContext = [NSGraphicsContext graphicsContextWithGraphicsPort:contextRef
                                                                                flipped:NO];
  _GTMDevAssert(bitmapContext, @"Couldn't create ns bitmap context");
  
  // Save our state and turn off font smoothing and antialias.
  CGContextSaveGState(contextRef);
  CGContextSetShouldSmoothFonts(contextRef, false);
  CGContextSetShouldAntialias(contextRef, false);
  [self displayRectIgnoringOpacity:bounds inContext:bitmapContext];

  CGImageRef image = CGBitmapContextCreateImage(contextRef);
  CFRelease(contextRef);
  return image;
}

//  Returns whether gtm_unitTestEncodeState should recurse into subviews
//  of a particular view.
//  If you have "Full keyboard access" in the
//  Keyboard & Mouse > Keyboard Shortcuts preferences pane set to "Text boxes 
//  and Lists only" that Apple adds a set of subviews to NSTextFields. So in the 
//  case of NSTextFields we don't want to recurse into their subviews. There may 
//  be other cases like this, so instead of specializing gtm_unitTestEncodeState: to
//  look for NSTextFields, NSTextFields will just not allow us to recurse into
//  their subviews.
//
//  Returns:
//    should gtm_unitTestEncodeState pick up subview state.
- (BOOL)gtm_shouldEncodeStateForSubviews {
  return YES;
}

//  Encodes the state of an object in a manner suitable for comparing
//  against a master state file so we can determine whether the
//  object is in a suitable state.
//
//  Arguments:
//    inCoder - the coder to encode our state into
- (void)gtm_unitTestEncodeState:(NSCoder*)inCoder {
  [super gtm_unitTestEncodeState:inCoder];
  [inCoder encodeBool:[self isHidden] forKey:@"ViewIsHidden"];
  if ([self gtm_shouldEncodeStateForSubviews]) {
    NSEnumerator *subviewEnum = [[self subviews] objectEnumerator];
    NSView *subview = nil;
    int i = 0;
    while ((subview = [subviewEnum nextObject])) {
      [inCoder encodeObject:subview forKey:[NSString stringWithFormat:@"ViewSubView %d", i]];
      i = i + 1;
    }
  }
}

@end

