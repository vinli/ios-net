//
//  VLTestHelper.h
//  VinliSDK
//
//  Created by Josh Beridon on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLDateFormatter.h"
#import "VLService.h"

#define MACRO_NAME(f) #f
#define MACRO_VALUE(f)  MACRO_NAME(f)

@interface VLTestHelper : NSObject

+ (NSInteger) defaultTimeOut;
+ (VLService *) vlService;
+ (NSString *) accessToken;
+ (NSString *) deviceId;
+ (NSString *) vehicleId;
+ (NSString *) odometerId;
+ (NSString *) tripId;
+ (NSString *) ruleId;
+ (NSString *) odometerTriggerId;
+ (NSString *) eventId;
+ (NSString *) notificationId;
+ (NSString *) subscriptionId;
+ (NSString *) telemetryMessageId;
+ (NSString *) uuid;
+ (NSString *) urlStr;

+ (NSDictionary *) getVehicleJSON:(NSString *) deviceId;
+ (NSDictionary *) getTripJSON: (NSString *) vehicleId;
+ (NSDictionary *) getAllTripsJSON:(NSString *) deviceId;
+ (NSDictionary *) getRuleJSON: (NSString *) ruleId;
+ (NSDictionary *) getAllVehiclesJSON:(NSString *) deviceId;
+ (NSDictionary *) getParametricBoundaryJSON;
+ (NSDictionary *) getRadiusBoundaryJSON;
+ (NSDictionary *) getAllStartupsJSON;
+ (NSDictionary *) getAllShutdownsJSON;
+ (NSDictionary *) getSpecificMessageJSON;
+ (NSDictionary *) getSnapshotsJSON: (NSString *) deviceId;
+ (NSDictionary *) getLocationsJSON;
+ (NSDictionary *) getAllRulesJSON:(NSString *) deviceId;
+ (NSDictionary *) getSpecificSubscriptionJSON: (NSString *) subscriptionId;
+ (NSDictionary *) getAllSubscriptionsJSON:(NSString *) deviceId;
+ (NSDictionary *) getDeviceJSON:(NSString *) deviceId;
+ (NSDictionary *) getAllEventsJSON:(NSString *) deviceId;
+ (NSDictionary *) getEventJSON:(NSString *) eventId;
+ (NSDictionary *) getAllEventsOrSubscriptionsNotificationsJSON:(NSString *) subscriptionId;
+ (NSDictionary *) getNotificationJSON:(NSString *) notificationId;
+ (NSDictionary *) getMessagesJSON;
+ (NSDictionary *) getCreateSubscriptionsJSON;
+ (NSDictionary *) getAllDevicesJSON;
+ (NSDictionary *) getUserJSON;
+ (NSDictionary *) getUserDevicesJSON;
+ (NSDictionary *) getAllDistancesJSON;
+ (NSDictionary *) getAllOdometersJSON;
+ (NSDictionary *) getOdometerJSON;
+ (NSDictionary *) getAllOdometerTriggersJSON;
+ (NSDictionary *) getOdometerTriggerJSON;
+ (NSDictionary *) getBatteryStatusJSON;

+ (NSMutableDictionary *)cleanDictionary:(NSDictionary *)dict;

@end
