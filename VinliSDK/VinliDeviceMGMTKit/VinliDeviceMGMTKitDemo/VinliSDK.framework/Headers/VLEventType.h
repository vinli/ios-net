//
//  VLEventType.h
//  VinliSDK
//
//  Created by Bryan on 2/7/17.
//  Copyright © 2017 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLEventType : NSObject

extern NSString * const VLEventTypeCollision;
extern NSString * const VLEventTypeCommDisrupted;
extern NSString * const VLEventTypeDeviceClaimed;
extern NSString * const VLEventTypeDistanceTrigger;
extern NSString * const VLEventTypeDTCOff;
extern NSString * const VLEventTypeDTCOn;
extern NSString * const VLEventTypePhoneHome;
extern NSString * const VLEventTypePluggedIn;
extern NSString * const VLEventTypeRule;
extern NSString * const VLEventTypeRuleEnter;
extern NSString * const VLEventTypeRuleLeave;
extern NSString * const VLEventTypeShutdown;
extern NSString * const VLEventTypeStartUp;
extern NSString * const VLEventTypeTrip;
extern NSString * const VLEventTypeTripCompleted;
extern NSString * const VLEventTypeTripOrphaned;
extern NSString * const VLEventTypeTripStarted;
extern NSString * const VLEventTypeTripStopped;
extern NSString * const VLEventTypeVehicleChanged;
extern NSString * const VLEventTypeHardAccel;
extern NSString * const VLEventTypeHardDecel;
extern NSString * const VLEventTypeRuleTurn;

@end
