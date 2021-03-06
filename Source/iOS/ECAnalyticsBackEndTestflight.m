// --------------------------------------------------------------------------
//! @author Sam Deane
//! @date 15/11/2011
//
//  Copyright 2012 Sam Deane, Elegant Chaos. All rights reserved.
//  This source code is distributed under the terms of Elegant Chaos's 
//  liberal license: http://www.elegantchaos.com/license/liberal
// --------------------------------------------------------------------------

#import "ECAnalyticsBackEndTestflight.h"
#import <ECAnalytics/ECAnalytics.h>

#import "TestFlight.h"

@implementation ECAnalyticsBackEndTestFlight

#pragma mark - Object Lifecycle

// --------------------------------------------------------------------------
//! Perform one-time initialisation of the engine.
// --------------------------------------------------------------------------

- (void)startupWithEngine:(ECAnalyticsEngine*)engineIn
{
    self.engine = engineIn;

#if EC_DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#if !defined(__MAC_10_9)
	[TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif

#pragma clang diagnostic pop
#endif

    NSString* token = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TestFlightToken"];
    if (token)
    {
        [TestFlight takeOff:token];
    }

}

// --------------------------------------------------------------------------
//! Perform one-time cleanup of the engine.
// --------------------------------------------------------------------------

- (void)shutdown
{
}

// --------------------------------------------------------------------------
//! Log an un-timed event.
// --------------------------------------------------------------------------

- (void)eventUntimed:(NSString*)event forObject:(id)object parameters:(NSDictionary*)parameters
{
    [TestFlight passCheckpoint:event];
}

// --------------------------------------------------------------------------
//! Start logging a timed event. Returns the event, which can be ended by calling logTimedEventEnd:
// --------------------------------------------------------------------------

- (ECAnalyticsEvent*)eventStart:(NSString*)eventName forObject:(id)object parameters:(NSDictionary*)parameters
{
	ECAnalyticsEvent* event = [[[ECAnalyticsEvent alloc] initWithName:eventName parameters:parameters] autorelease];
	
	return event;
}

// --------------------------------------------------------------------------
//! Finish logging a timed event.
// --------------------------------------------------------------------------

- (void)eventEnd:(ECAnalyticsEvent*)event
{
    [TestFlight passCheckpoint:event.name];
}

// --------------------------------------------------------------------------
//! Log an error.
// --------------------------------------------------------------------------

- (void)error:(NSError*)error message:(NSString*)message
{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Error: %@", message]];
}

// --------------------------------------------------------------------------
//! Log an exception.
// --------------------------------------------------------------------------

- (void)exception:(NSException*)exception
{
}

// --------------------------------------------------------------------------
//! Use the TestFlight exception handling.
// --------------------------------------------------------------------------

- (BOOL)hasOwnExceptionHandler
{
    return YES;
}

@end
