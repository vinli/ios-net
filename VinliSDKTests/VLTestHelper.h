//
//  VLTestHelper.h
//  VinliSDK
//
//  Created by Josh Beridon on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VLTestHelper : NSObject



+ (NSInteger) defaultTimeOut;
+ (NSDictionary *)getVehicleJSON:(NSString *) deviceId;
+ (NSDictionary *)getTripJSON: (NSString *) vehicleId;
+ (NSDictionary *)getAllTripsJSON:(NSString *) deviceId;
+ (NSDictionary *)getRuleJSON: (NSString *) ruleId;
+ (NSDictionary *)getAllVehiclesJSON:(NSString *) deviceId;
+ (NSDictionary *)getParametricBoundaryJSON;
+ (NSDictionary *)getRadiusBoundaryJSON;
+ (NSDictionary *)getAllStartupsJSON;
+ (NSDictionary *)getAllShutdownsJSON;
+ (NSDictionary *)getSpecificMessageJSON;
+ (NSDictionary *)getSnapshotsJSON: (NSString *) deviceId;
+ (NSDictionary *)getLocationsJSON;
+ (NSDictionary *)getAllRulesJSON:(NSString *) deviceId;
+ (NSDictionary *)getSpecificSubscriptionJSON: (NSString *) subscriptionId;
+ (NSDictionary *)getAllSubscriptionsJSON:(NSString *) deviceId;
+ (NSDictionary *)getDeviceJSON:(NSString *) deviceId;
+ (NSDictionary *)getAllEventsJSON:(NSString *) deviceId;
+ (NSDictionary *)getEventJSON:(NSString *) eventId;
+ (NSDictionary *)getAllEventsOrSubscriptionsNotificationsJSON:(NSString *) subscriptionId;
+ (NSDictionary *)getNotificationJSON:(NSString *) notificationId;
+ (NSDictionary *)getMessagesJSON;
+ (NSDictionary *)getCreateSubscriptionsJSON;
+ (NSDictionary *)getAllDevicesJSON;
+ (NSDictionary *)getUserJSON;
+ (NSDictionary *)getUserDevicesJSON;
+ (NSMutableDictionary *)cleanDictionary:(NSDictionary *)dict;


//+ (NSDictionary *)getVehicleJsonAsync:(NSString *) deviceId;
//+ (NSDictionary *)getTripJsonAsync: (NSString *) vehicleId;
//+ (NSDictionary *)getAllTripsJsonAsync:(NSString *) deviceId;
//+ (NSDictionary *)getRuleJSON: (NSString *) ruleId;
//+ (NSDictionary *)getAllVehiclesJSON:(NSString *) deviceId;
//+ (NSDictionary *)getParametricBoundaryJSON;
//+ (NSDictionary *)getRadiusBoundaryJSON;
//+ (NSDictionary *)getAllStartupsJSON;
//+ (NSDictionary *)getAllShutdownsJSON;
//+ (NSDictionary *)getSpecificMessageJSON;
//+ (NSDictionary *)getSnapshotsJSON: (NSString *) deviceId;
//+ (NSDictionary *)getLocationsJSON;
//+ (NSDictionary *)getAllRulesJSON:(NSString *) deviceId;
//+ (NSDictionary *)getSpecificSubscriptionJSON: (NSString *) subscriptionId;
//+ (NSDictionary *)getAllSubscriptionsJSON:(NSString *) deviceId;
//+ (NSDictionary *)getDeviceJSON:(NSString *) deviceId;
//+ (NSDictionary *)getAllEventsJSON:(NSString *) deviceId;
//+ (NSDictionary *)getEventJSON:(NSString *) eventId;
//+ (NSDictionary *)getAllEventsOrSubscriptionsNotificationsJSON:(NSString *) subscriptionId;
//+ (NSDictionary *)getNotificationJSON:(NSString *) notificationId;
//+ (NSDictionary *)getMessagesJSON;
//+ (NSDictionary *)getCreateSubscriptionsJSON;
//+ (NSDictionary *)getAllDevicesJSON;
//+ (NSDictionary *)getUserJSON;
//+ (NSDictionary *)getUserDevicesJSON;









@end