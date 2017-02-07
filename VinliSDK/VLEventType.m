//
//  VLEventType.m
//  VinliSDK
//
//  Created by Bryan on 2/7/17.
//  Copyright © 2017 Vinli. All rights reserved.
//

#import "VLEventType.h"

@implementation VLEventType

NSString * const VLEventTypeCollision = @"collision";
NSString * const VLEventTypeCommDisrupted = @"comm-disrupted";
NSString * const VLEventTypeDeviceClaimed = @"device-claimed";
NSString * const VLEventTypeDistanceTrigger = @"distance-trigger";
NSString * const VLEventTypeDTCOff = @"dtc-off";
NSString * const VLEventTypeDTCOn = @"dtc-on";
NSString * const VLEventTypePhoneHome = @"phone-home";
NSString * const VLEventTypePluggedIn = @"plugged-in";
NSString * const VLEventTypeRule = @"rule-*";
NSString * const VLEventTypeRuleEnter = @"rule-enter";
NSString * const VLEventTypeRuleLeave = @"rule-leave";
NSString * const VLEventTypeShutdown = @"shutdown";
NSString * const VLEventTypeStartUp = @"startup";
NSString * const VLEventTypeTrip = @"trip-*";
NSString * const VLEventTypeTripCompleted = @"trip-completed";
NSString * const VLEventTypeTripOrphaned = @"trip-orphaned";
NSString * const VLEventTypeTripStarted = @"trip-started";
NSString * const VLEventTypeTripStopped = @"trip-stopped";
NSString * const VLEventTypeVehicleChanged = @"vehicle-changed";
NSString * const VLEventTypeHardAccel = @"hard-accel";
NSString * const VLEventTypeHardDecel = @"hard-decel";
NSString * const VLEventTypeRuleTurn = @"hard-turn";

@end
