//
//  VLRequestConnection.h
//  VinliSDK
//
//  Created by Cheng Gu on 8/21/14.
//  Copyright (c) 2014 Cheng Gu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VLRule.h"
#import "VLVehicle.h"
#import "VLTelemetryMessage.h"
#import "VLVehiclePager.h"
#import "VLRulePager.h"
#import "VLTelemetryMessagePager.h"
#import "VLTelemetryMessage.h"
#import "VLLocation.h"
#import "VLLocationPager.h"
#import "VLTrip.h"
#import "VLTripPager.h"
#import "VLSession.h"
#import "VLSubscription.h"
#import "VLSubscriptionPager.h"
#import "VLDevicePager.h"
#import "VLEventPager.h"
#import "VLEvent.h"
#import "VLUser.h"
#import "VLNotificationPager.h"
#import "VLNotification.h"
#import "VLSnapshot.h"
#import "VLSnapshotPager.h"
#import "VLRadiusBoundary.h"
#import "VLParametricBoundary.h"
#import "VLLoginButton.h"
#import "VLObjectRef.h"
#import "VLPolygonBoundary.h"
#import "VLTimeSeries.h"


#pragma clang diagnostic ignored "-Wnullability-completeness"

@class VLDevice;

@interface VLService : NSObject

@property (strong, readonly, nullable) VLSession *session;
@property (strong, nonatomic, nonnull) NSString *host;



+ (VLService *)sharedService;

// Create a VLService object
// @params:
// session:     A valid VLSession to use
- (nonnull id) initWithSession: (nullable VLSession *) session;

// Set the session that this service is to use.
// @params:
// session:     A valid VLSession to use
- (void) useSession:(nullable VLSession *) session;


// Allows users of the class ability handle any 401 errors
// @params:
// handler: A block of code to be executed
- (void)setAccessTokenExpirationHandler:(void (^)(VLService* service, NSError* error))handler;


#pragma mark - Factory Methods

// @params:
// host:        'telemetry-test.vin.li'
// path:        '/api/v1/......'
// method:      'GET'
// dictParams:  An NSDictionary where you put your payload
// token:       Authorization token taken from a valid VLSession
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  result:     An NSDictionay decoded from the JSON format response body
//                              This is just the whole response body, so it depends on developer how to use it.
//                              For some specific methods, you can decode specific fields for them.
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
//                  !! Note:    In this callback block, statusCode might be 404, 500. I didn't do any handling here,
//                              which is different from specific API calls below.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void)startWithHost:(nonnull NSString *)host
                 path:(nonnull NSString *)path
              queries:(nullable NSDictionary *)queries
           HTTPMethod:(nonnull NSString *)method
           parameters:(nullable NSDictionary *)dictParams
                token:(nonnull NSString *) token
            onSuccess:(void (^)(NSDictionary *, NSHTTPURLResponse *))onSuccessfulBlock
            onFailure:(void (^)(NSError *, NSHTTPURLResponse *, NSString *))onFailureBlock;



- (void) startWithHost:(nonnull NSString *)token requestUri:(nonnull NSString *)requestUri onSuccess:(void (^)(NSDictionary *result, NSHTTPURLResponse *response))onSuccessBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *msg))onFailureBlock;


//Get the queries for a particular URL

- (NSDictionary *) getDictionaryWithLimit: (nullable NSNumber *) limit
                                   offset:(nullable NSNumber *) offset;





- (void)startConnectionWithRequest:(NSURLRequest *)request method:(NSString *)method onSuccess:(void (^)(NSDictionary *result, NSHTTPURLResponse *response))onSuccessfulBlock onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *msg))onFailureBlock;

#pragma mark - Platform Services

// Get a VLDevicePager object containing a list of devices and pagination data
// Route: GET /api/v1/devices
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  devicePager:    A VLDevicePager object containing the list of devices and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getDevicesOnSuccess:(void (^)(VLDevicePager * devicePager, NSHTTPURLResponse * response))onSuccessBlock
                   onFailure:(void (^)(NSError * error, NSHTTPURLResponse * response, NSString * bodyString))onFailureBlock;

// Get a VLDevicePager object containing a list of devices and pagination data
// Route: GET /api/v1/devices
// @params
// limit:           How many devices to return. Max = 50
// offset:          Offset into the list of devices.
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  devicePager:    A VLDevicePager object containing the list of devices and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getDevicesWithLimit:(nullable NSNumber *) limit
                      offset:(nullable NSNumber *) offset
                   onSuccess:(void (^)(VLDevicePager *devicePager, NSHTTPURLResponse *response))onSuccessBlock
                   onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLDevice object corresponding to the deviceId parameter.
// Route: GET /api/v1/devices/{deviceId}
// @params:
// deviceId:        The device id to get.
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  device:     A device corresponding to the provided device id.
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getDeviceWithId:(nonnull NSString *) deviceId
               onSuccess:(void (^)(VLDevice *device, NSHTTPURLResponse *response))onSuccessBlock
               onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;


// Get capbilities of VLDevice object corresponding to the deviceId parameter.
// Route: GET /api/v1/devices/{deviceId}/capabilities
- (void)getDeviceCapabilitiesWithId:(NSString *)deviceId
                        onSuccess:(void (^)(NSDictionary *capabilites, NSHTTPURLResponse *response))onSuccessBlock
                        onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;


// Get a VLVehicle corresponding to the latest vehicle of deviceId
// Route: GET /api/v1/devices/{deviceId}/vehicles/_latest
// @params:
// deviceId:        The device id to get the lastest vehicle of.
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  vehicle:    A VLVehicle corresponding to the latest vehicle of device deviceId
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getLatestVehicleForDeviceWithId:(nonnull NSString *) deviceId
                               onSuccess:(void (^)(VLVehicle *vehicle, NSHTTPURLResponse *response))onSuccessBlock
                               onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLVehiclePager object containing a list of vehicles and pagination data
// Route: GET /api/v1/devices/{deviceId}/vehicles
// @params:
// deviceId:        Device id to get the vehicles from
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  vehiclePager:    A VLVehiclePager object containing the list of vehicles and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getVehiclesForDeviceWithId:(nonnull NSString *) deviceId
                          onSuccess:(void (^)(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response))onSuccessBlock
                          onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLVehiclePager object containing a list of vehicles and pagination data
// Route: GET /api/v1/devices/{deviceId}/vehicles
// @params:
// deviceId:        Device id to get the vehicles from
// limit:           How many devices to return. Max = 50
// offset:          Offset into the list of devices.
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  vehiclePager:    A VLVehiclePager object containing the list of vehicles and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getVehiclesForDeviceWithId:(nonnull NSString *) deviceId
                              limit:(nullable NSNumber *) limit
                             offset:(nullable NSNumber *) offset
                          onSuccess:(void (^)(VLVehiclePager *vehiclePager, NSHTTPURLResponse *response))onSuccessBlock
                          onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

#pragma mark - Rule Services

// Get a VLRulePager object containing a list of rules and pagination data
// Route: GET /api/vi/devices/{deviceId}/rules
// @params:
// deviceId:        Device id to get the rules for
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  rulePager:    A VLRulePager object containing the list of rules and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getRulesForDeviceWithId:(nonnull NSString *) deviceId
                       onSuccess:(void (^)(VLRulePager *rulePager, NSHTTPURLResponse *response))onSuccessBlock
                       onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLRulePager object containing a list of rules and pagination data
// Route: GET /api/vi/devices/{deviceId}/rules
// @params:
// deviceId:        Device id to get the rules for
// limit:           How many rules to return. Max = 50
// offset:          Offset into the list of devices.
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  rulePager:    A VLRulePager object containing the list of rules and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getRulesForDeviceWithId:(nonnull NSString *) deviceId
                           limit:(nullable NSNumber *) limit
                          offset:(nullable NSNumber *) offset
                       onSuccess:(void (^)(VLRulePager *rulePager, NSHTTPURLResponse *response))onSuccessBlock
                       onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLRule object corresponding to the rule id
// Route: GET /api/v1/rules/{ruleId}
// @params:
// ruleId:        rule id to get the rule from
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  rule:    A VLRule object containing the rule with ruleId
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getRuleWithId:(nonnull NSString *) ruleId
             onSuccess:(void (^)(VLRule *rule, NSHTTPURLResponse *response))onSuccessBlock
             onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Create a rule
// Route: POST /api/v1/devices/{deviceId}/rules
// @params:
// rule:            VLRule to use to make the rule
// deviceId:        Device id to create the rule for
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  rule:    A VLRule containing the rule that was created on the server
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) createRule:(nonnull VLRule *) rule
          forDevice:(nonnull NSString *) deviceId
          onSuccess:(void (^)(VLRule *rule, NSHTTPURLResponse *response))onSuccessBlock
          onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Delete a rule
// Route: DELETE /api/v1/rules/{ruleId}
// @params:
// ruleId:        Rule id to delete
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) deleteRuleWithId:(nonnull NSString *) ruleId
                onSuccess:(void (^)(NSHTTPURLResponse *response))onSuccessBlock
                onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

#pragma mark - Telemetry Services

// Get a VLTelemetryMessage object containing telemetry information
// Route: GET /api/v1/messages/{messageId}
// @params:
// messageId:        Message id of the message to get
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  telemetryMessage:    A VLTelemetryMessage object containing telemetry message info
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getTelemetryMessageWithId:(nonnull NSString *) messageId
                         onSuccess:(void (^)(VLTelemetryMessage *telemetryMessage, NSHTTPURLResponse *response))onSuccessBlock
                         onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLSnapshotPager object containing a list of snapshots and pagination data
// Route: GET /api/vi/devices/{deviceId}/snapshots
// @params:
// deviceId:        Device id to get the snapshots for
// fields:          Comma separated list of fields to retrieve
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  snapshotPager:    A VLSnapshotPager object containing the list of snapshots and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getSnapshotsForDeviceWithId:(nonnull NSString *) deviceId
                              fields:(nonnull NSString *)fields
                           onSuccess:(nullable void (^)(VLSnapshotPager *snapshotPager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(nullable void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLSnapshotPager object containing a list of snapshots and pagination data
// Route: GET /api/vi/devices/{deviceId}/snapshots
// @params:
// deviceId:        Device id to get the snapshots for
// fields:          Comma separated list of fields to retrieve
// limit:           Maximum number of snapshots to retrieve. Max = 50
// until:           Upper end of the timestamp of snapshots to retrieve
// since:           Lower end of the timestamp of snapshots to retrieve
// sortDirection:   Direction in which to sort the timestamps
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  snapshotPager:    A VLSnapshotPager object containing the list of snapshots and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.




- (void) getSnapshotsForDeviceWithId:(nonnull NSString *) deviceId
                              fields:(nonnull NSString *)fields
                              timeSeries:(VLTimeSeries *)timeSeries
                           onSuccess:(void (^)(VLSnapshotPager *snapshotPager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;






- (void) getSnapshotsForDeviceWithId:(nonnull NSString *) deviceId
                              fields:(nonnull NSString *)fields
                               limit:(nullable NSNumber *)limit
                               until:(nullable NSDate *)until
                               since:(nullable NSDate *)since
                       sortDirection:(nullable NSString *)sortDirection
                           onSuccess:(void (^)(VLSnapshotPager *snapshotPager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLLocationPager object containing a list of locations and pagination data
// Route: GET /api/v1/devices/{deviceId}/locations
// @params:
// deviceId:        Device id to get the locations from
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  locationPager:    A VLLocationPager object containing the list of locations and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getLocationsForDeviceWithId:(nonnull NSString *) deviceId
                           onSuccess:(void (^)(VLLocationPager *locationPager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLLocationPager object containing a list of locations and pagination data
// Route: GET /api/v1/devices/{deviceId}/locations
// @params:
// deviceId:        Device id to get the locations from
// limit:           Maximum number of locations to retrieve. Max = 50
// until:           Upper end of the timestamp of locations to retrieve
// since:           Lower end of the timestamp of locations to retrieve
// sortDirection:   Direction in which to sort the locations
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  locationPager:    A VLLocationPager object containing the list of locations and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.

- (void) getLocationsForDeviceWithId:(nonnull NSString *) deviceId
                          timeSeries:(VLTimeSeries *)timeSeries
                           onSuccess:(void (^)(VLLocationPager *locationPager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;





- (void) getLocationsForDeviceWithId:(nonnull NSString *) deviceId
                               limit:(nullable NSNumber *)limit
                               until:(nullable NSDate *)until
                               since:(nullable NSDate *)since
                       sortDirection:(nullable NSString *)sortDirection
                           onSuccess:(void (^)(VLLocationPager *locationPager, NSHTTPURLResponse *response))onSuccessBlock
                           onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLTelemetryMessagePager object containing a list of messages and pagination data
// Route: GET /api/v1/device/{deviceId}/messages
// @params:
// deviceId:        Device id to get the telemetry messages from
// options:         A NSDictionary containing url parameters. See {link here} for a list of valid options
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  telemetryPager:    A VLTelemetryMessagePager object containing the list of trips and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getTelemetryMessagesForDeviceWithId:(nonnull NSString *) deviceId
                                   onSuccess:(void (^)(VLTelemetryMessagePager *telemetryPager, NSHTTPURLResponse *response))onSuccessBlock
                                   onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLTelemetryMessagePager object containing a list of messages and pagination data
// Route: GET /api/v1/device/{deviceId}/messages
// @params:
// deviceId:        Device id to get the telemetry messages from
// limit:           Maximum number of telemetry messages to retrieve. Max = 50
// until:           Upper end of the timestamp of telemtry messages to retrieve
// since:           Lower end of the timestamp of telemetry messages to retrieve
// sortDirection:   Direction in which to sort the telemetry messages
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  telemetryPager:    A VLTelemetryMessagePager object containing the list of trips and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.



- (void) getTelemetryMessagesForDeviceWithId:(nonnull NSString *) deviceId
                                  timeSeries:(VLTimeSeries *)timeSeries
                                   onSuccess:(void (^)(VLTelemetryMessagePager *telemetryPager, NSHTTPURLResponse *response))onSuccessBlock
                                   onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;


- (void) getTelemetryMessagesForDeviceWithId:(nonnull NSString *) deviceId
                                       limit:(nullable NSNumber *)limit
                                       until:(nullable NSDate *)until
                                       since:(nullable NSDate *)since
                               sortDirection:(nullable NSString *)sortDirection
                                   onSuccess:(void (^)(VLTelemetryMessagePager *telemetryPager, NSHTTPURLResponse *response))onSuccessBlock
                                   onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;


#pragma mark - Trip Services

// Get a VLTripPager object containing a list of trips and pagination data
// Route: GET /api/v1/device/{deviceId}/trips
// @params:
// deviceId:        Device id to get the trips from
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  tripPager:    A VLTripPager object containing the list of trips and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getTripsForDeviceWithId:(nonnull NSString *) deviceId
                       onSuccess:(void (^)(VLTripPager *tripPager, NSHTTPURLResponse *response))onSuccessBlock
                       onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLTripPager object containing a list of trips and pagination data
// Route: GET /api/v1/device/{deviceId}/trips
// @params:
// deviceId:        Device id to get the trips from
// limit:           Maximum limit of trips to return. Max = 50
// offset:          Offset into the trips.
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  tripPager:    A VLTripPager object containing the list of trips and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.



//- (void) getTripsForDeviceWithId:(nonnull NSString *) deviceId
//                           limit:(nullable NSNumber *)limit
//                          offset:(nullable NSNumber *)offset
//                       onSuccess:(void (^)(VLTripPager *tripPager, NSHTTPURLResponse *response))onSuccessBlock
//                       onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;


- (void)getTripsForDeviceWithId:(nonnull NSString *)deviceId
                            timeSeries: (VLTimeSeries *)timeSeries
                      onSuccess:(void (^)(VLTripPager *tripPager, NSHTTPURLResponse *response))onSuccessBlock
                      onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;



// Get a VLTripPager object containing a list of trips and pagination data
// Route: GET /api/v1/vehicles/{vehicleId}/trips
// @params:
// vehicle:        vehicle id to get the trips from
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  tripPager:    A VLTripPager object containing the list of trips and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getTripsForVehicleWithId:(nonnull NSString *) vehicleId
                        onSuccess:(void (^)(VLTripPager *tripPager, NSHTTPURLResponse *response))onSuccessBlock
                        onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLTripPager object containing a list of trips and pagination data
// Route: GET /api/v1/vehicles/{vehicleId}/trips
// @params:
// vehicle:         vehicle id to get the trips from
// limit:           Maximum number of trips to retrieve per page. Max = 50
// offset:          Offset into the number of trips
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  tripPager:    A VLTripPager object containing the list of trips and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getTripsForVehicleWithId:(nonnull NSString *) vehicleId
                       timeSeries: (VLTimeSeries *)timeSeries
                        onSuccess:(void (^)(VLTripPager *tripPager, NSHTTPURLResponse *response))onSuccessBlock
                        onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLtrip object containing trip info for a specific trip id
// Route: GET /api/v1/trips/{tripId}
// @params:
// tripId:        trip id to get
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  trip:    A VLTrip object containing the trip info
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getTripWithId:(nonnull NSString *) deviceId
             onSuccess:(void (^)(VLTrip *trip, NSHTTPURLResponse *response))onSuccessBlock
             onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

#pragma mark - Event Services

// Get a VLEventPager object containing a list of events and pagination data
// Route: GET /api/v1/devices/{deviceId}/events
// @params:
// deviceId:        Device id to get the events from
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  eventsPager:    A VLEventPager object containing the list of events and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getEventsForDeviceWithId:(nonnull NSString *) deviceId
                        onSuccess:(void (^)(VLEventPager *eventPager, NSHTTPURLResponse *response))onSuccessBlock
                        onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLEventPager object containing a list of events and pagination data
// Route: GET /api/v1/devices/{deviceId}/events
// @params:
// deviceId:        Device id to get the events from
// limit:           Maximum number of events to retrieve. Max = 50
// until:           Upper end of the events of snapshots to retrieve
// since:           Lower end of the events of snapshots to retrieve
// sortDirection:   Direction in which to sort the events
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  eventsPager:    A VLEventPager object containing the list of events and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getEventsForDeviceWithId:(nonnull NSString *) deviceId
                            limit:(nullable NSNumber *)limit
                            until:(nullable NSDate *)until
                            since:(nullable NSDate *)since
                    sortDirection:(nullable NSString *)sortDirection
                        onSuccess:(void (^)(VLEventPager *eventPager, NSHTTPURLResponse *response))onSuccessBlock
                        onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Create a subscription
// Route: POST /api/v1/devices/{deviceId}/subscriptions
// @params:
// subscription:    VLSubscription to use to make the subscription
// deviceId:        Device id to create the subscription with
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  subscription:    A VLSubscription containing the rule that was created on the server
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) createSubscription:(nonnull VLSubscription *) subscription
                  forDevice:(nonnull NSString *) deviceId
                  onSuccess:(void (^)(VLSubscription *subscription, NSHTTPURLResponse *response))onSuccessBlock
                  onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Edit a subscription
// Route: PUT /api/v1/devices/{deviceId}/subscription/{subscriptionId}
// @params:
// subscription:    VLSubscription to put onto the server
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  subscription:    A VLSubscription containing the modified subscription from the server
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) editSubscription:(nonnull VLSubscription *) subscription
                  onSuccess:(void (^)(VLSubscription *subscription, NSHTTPURLResponse *response))onSuccessBlock
                  onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLEvent object containing a event information
// Route: GET /api/v1/events/{eventId}
// @params:
// eventId:         Event id to retrieve
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  event:    A VLEvent object containing event information
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getEventWithId:(nonnull NSString *) eventId
              onSuccess:(void (^)(VLEvent *event, NSHTTPURLResponse *response))onSuccessBlock
              onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLNotificationPager object containing a list of notifications and pagination data
// Route: GET /api/v1/events/{eventId}/notifications
// @params:
// eventId:        Event id to get the notifications from
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  notificationPager:    A VLNotificationPager object containing the list of notifications and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getNotificationsForEventWithId:(nonnull NSString *) eventId
                              onSuccess:(void (^)(VLNotificationPager *notificationPager, NSHTTPURLResponse *response))onSuccessBlock
                              onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLNotificationPager object containing a list of notifications and pagination data
// Route: GET /api/v1/events/{eventId}/notifications
// @params:
// eventId:         Event id to get the notifications from
// limit:           Maximum number of notifications to return per page. Max = 50
// offset:          Offset into the notifications
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  notificationPager:    A VLNotificationPager object containing the list of notifications and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getNotificationsForEventWithId:(nonnull NSString *) eventId
                             timeSeries:(VLTimeSeries *)timeSeries
                              onSuccess:(void (^)(VLNotificationPager *notificationPager, NSHTTPURLResponse *response))onSuccessBlock
                              onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLNotificationPager object containing a list of notifications and pagination data
// Route: GET /api/v1/subscriptions/{subscriptionId}/notifications
// @params:
// subscriptionId:        subscription id to get the notifications from
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  notificationPager:    A VLNotificationPager object containing the list of notifications and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getNotificationsForSubscriptionWithId:(nonnull NSString *) subscriptionId
                                     onSuccess:(void (^)(VLNotificationPager *notificationPager, NSHTTPURLResponse *response))onSuccessBlock
                                     onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLNotificationPager object containing a list of notifications and pagination data
// Route: GET /api/v1/subscriptions/{subscriptionId}/notifications
// @params:
// subscriptionId:      subscription id to get the notifications from
// limit:               Maximum number of subscriptions to return per page. Max = 50
// offset:              Offset into the subscriptions
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  notificationPager:    A VLNotificationPager object containing the list of notifications and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getNotificationsForSubscriptionWithId:(nonnull NSString *) subscriptionId
                                    timeSeries:(VLTimeSeries *)timeSeries
                                     onSuccess:(void (^)(VLNotificationPager *notificationPager, NSHTTPURLResponse *response))onSuccessBlock
                                     onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLNotification object containing information about a notification
// Route: GET /api/v1/notifications/{notificationId}
// @params:
// notificationId:  Id of the notification to get
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  notification:    A VLNotification object containing information about the notification
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getNotificationWithId:(nonnull NSString *) notificationId
                     onSuccess:(void (^)(VLNotification *event, NSHTTPURLResponse *response))onSuccessBlock
                     onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLSubscription object containing information about a subscription
// Route: GET /api/v1/subscriptions/{subscriptionId}
// @params:
// subscriptionId:        Subscription id to get the information from
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  subscription:    A VLSubscription object containing information about the subscription
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getSubscriptionWithId:(nonnull NSString *) subscriptionId
                     onSuccess:(void (^)(VLSubscription *subscription, NSHTTPURLResponse *response))onSuccessBlock
                     onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLSubscriptionPager object containing a list of subscriptions and pagination data
// Route: GET /api/v1/devices/{deviceId}/subscriptions
// @params:
// deviceId:        device id to get the subscriptions from
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  subscriptionPager:    A VLSubscription object containing the list of subscriptions and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getSubscriptionsForDeviceWithId:(nonnull NSString *) deviceId
                               onSuccess:(void (^)(VLSubscriptionPager *subscriptionPager, NSHTTPURLResponse *response))onSuccessBlock
                               onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Get a VLSubscriptionPager object containing a list of subscriptions and pagination data
// Route: GET /api/v1/devices/{deviceId}/subscriptions
// @params:
// deviceId:        device id to get the subscriptions from
// limit:           Maximum number of subscriptions to be returned per page. Max = 50
// offset:          Offset into the subscriptions
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  subscriptionPager:    A VLSubscription object containing the list of subscriptions and pagination data
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getSubscriptionsForDeviceWithId:(nonnull NSString *) deviceId
                                   limit:(nullable NSNumber *)limit
                                  offset:(nullable NSNumber *)offset
                               onSuccess:(void (^)(VLSubscriptionPager *subscriptionPager, NSHTTPURLResponse *response))onSuccessBlock
                               onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;

// Delete a subscription
// Route: DELETE /api/v1/subscription/{subscriptionId}
// @params:
// subscriptionId:        subscription id to get the information about
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) deleteSubscriptionWithId:(nonnull NSString *) subscriptionID
                                onSuccess:(void (^)(NSHTTPURLResponse *response))onSuccessBlock
                                onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;



#pragma mark - Auth Services

// Get a VLUser object from the Vinli Web API
// Route: GET /user
// @callbacks:
// onSuccessBlock:  This is a block that will be called if (onSuccessBlock != nil)
//                  User will be passed parameters through this callback block
//                  @params:
//                  user:     A VLUser object.
//                  response:   An NSHTTPURLResponse instance, from which user will know the URL, statusCode, etc.
// onFailureBlock:  Called when connection failed. Usually occurred when the website does not exist, or no internet connection.
- (void) getUserOnSuccess:(void (^)(VLUser *user, NSHTTPURLResponse *response))onSuccessBlock
                onFailure:(void (^)(NSError *error, NSHTTPURLResponse *response, NSString *bodyString))onFailureBlock;



@end
