//
//  VLTestHelper.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLTestHelper.h"

@implementation VLTestHelper





+ (NSString *)odometerTriggerId {
    return @"2adf089d-06ba-4c18-acef-cc70f848c461";
}


+ (NSString *)odometerId {
    return @"7b98a761-d270-48e9-8720-6e221353769c";
}



+ (NSString *)vehicleId {
    return @"c1e6f9e4-77eb-4989-bc23-a5e1236fd090";
}


+ (NSMutableDictionary *)cleanDictionary:(NSDictionary *)dict {
    NSMutableDictionary *mutDict = [dict mutableCopy];
    
    NSArray *keyForNullValues = [mutDict allKeysForObject:[NSNull null]];
    [mutDict removeObjectsForKeys:keyForNullValues];
    
    return mutDict;
  
    
}

+ (NSInteger)defaultTimeOut {
    return 15.0;
}

+ (NSString *)accessToken {
    
    //Unzip token.zip and use the accesstoken here
    
    return @"";
}


+ (NSString *)deviceId {
    return @"ba89372f-74f4-43c8-a4fd-b8f24699426e";
}

+ (NSDictionary *) getVehicleJSON:(NSString *) deviceId{
    int minYear = 2000;
    int maxYear = 2015;
    int rndValue = minYear + arc4random() % (maxYear - minYear);
    NSString *randStr = [NSString stringWithFormat:@"%d", rndValue];
    
    NSDictionary *vehicleJSON = @{
                                  @"vehicle" : @{
                                          @"id" : deviceId,//TBD this needs to be vehicle Id
                                          @"year" : randStr,
                                          @"make" : @"Toyota",
                                          @"model" : @"Camry",
                                          @"trim" : @"SE V6",
                                          @"vin" : @"2B4GP44R6WR942762"
                                          }
                                  
                                  };
    return vehicleJSON;
}

+ (NSDictionary *) getTripJSON: (NSString *) vehicleId{
    NSDictionary *tripJSON = @{
                               @"trip": @{
                                       @"id" : vehicleId,
                                       @"start" : @"2014-07-23T14:17:18.324Z",
                                       @"stop" : @"2014-07-23T14:19:45.737Z",
                                       @"startLocation" : @{
                                               @"type": @"Feature",
                                               @"geometry": @{
                                                       @"type": @"Point",
                                                       @"coordinates": @[@-100.0, @31.0]
                                                       },
                                               @"properties": @{
                                                       @"name": @"Start Location"
                                                       }
                                               },
                                       @"stopLocation" : @{
                                               @"type": @"Feature",
                                               @"geometry": @{
                                                       @"type": @"Point",
                                                       @"coordinates": @[@-96.0, @32.0]
                                                       },
                                               @"properties": @{
                                                       @"name": @"Stop Location"
                                                       }
                                               },
                                       @"status" : @"complete",
                                       @"deviceId" : @"821374c0-d6d8-11e3-9c1a-0800200c9a66",
                                       @"vehicleId" : vehicleId,
                                       @"distance" : @2304,
                                       @"duration" : @147413,
                                       @"averageSpeed" : @56.3,
                                       @"averageMovingSpeed" : @67.52,
                                       @"stdDevMovingSpeed" : @10.39,
                                       @"maxSpeed" : @112.4,
                                       @"stopCount" : @14,
                                       @"links" : @{
                                               @"self" : @"https://trips.vin.li/api/v1/trips/e960a385-0ced-4654-8404-3238e147ad45",
                                               @"snapshots" : @"https://trips.vin.li/api/v1/trips/e960a385-0ced-4654-8404-3238e147ad45/snapshots",
                                               @"messages" : @"https://trips.vin.li/api/v1/trips/e960a385-0ced-4654-8404-3238e147ad45/messages",
                                               @"locations" : @"https://trips.vin.li/api/v1/trips/e960a385-0ced-4654-8404-3238e147ad45/locations"
                                               }
                                       }
                               };
    return tripJSON;
}

+ (NSDictionary *) getRuleJSON: (NSString *) ruleId{
    NSDictionary *ruleJSON = @{
                               @"rule" : @{
                                       @"id" : ruleId,
                                       @"name" : @"Speed over 35mph near Superdome",
                                       @"boundaries" : @[
                                               [[self class] getParametricBoundaryJSON],
                                               [[self class] getRadiusBoundaryJSON]
                                               ],
                                       @"deviceId" : @"602c6490-d7a3-11e3-9c1a-0800200c9a66",
                                       @"evaluated" : @true,
                                       @"covered" : @true,
                                       @"links" : @{
                                               @"self" : @"https://events.vin.li/api/v1/rules/68d489c0-d7a2-11e3-9c1a-0800200c9a66",
                                               @"events" : @"https://events.vin.li/api/v1/rules/68d489c0-d7a2-11e3-9c1a-0800200c9a66/events"
                                               }
                                       }
                               };
    
    return ruleJSON;
}

+ (NSDictionary *) getAllTripsJSON:(NSString *) deviceId{
    NSDictionary *rulesJSON = @{
                                @"trips": @[
                                        @{
                                            @"id" : deviceId,
                                            @"start" : @"2014-07-23T14:17:18.324Z",
                                            @"stop" : @"2014-07-23T14:19:45.737Z",
                                            @"status" : @"complete",
                                            @"vehicleId" : @"27b8db50-1274-11e4-9191-0800200c9a66",
                                            @"links" : @{
                                                    @"self" : @"https://trips.vin.li/api/v1/trips/e960a385-0ced-4654-8404-3238e147ad45",
                                                    @"snapshots" : @"https://trips.vin.li/api/v1/trips/e960a385-0ced-4654-8404-3238e147ad45/snapshots",
                                                    @"locations" : @"https://trips.vin.li/api/v1/trips/e960a385-0ced-4654-8404-3238e147ad45/locations",
                                                    @"vehicle" : @"https://platform.vin.li/api/v1/vehicles/27b8db50-1274-11e4-9191-0800200c9a66"
                                                    }
                                            },
                                        @{
                                            @"id" : @"e960a385-0ced-4654-8404-3238e147ad45asdf",
                                            @"start" : @"2014-07-23T14:17:18.324Z",
                                            @"stop" : @"2014-07-23T14:19:45.737Z",
                                            @"status" : @"complete",
                                            @"vehicleId" : @"27b8db50-1274-11e4-9191-0800200c9a66",
                                            @"links" : @{
                                                    @"self" : @"https://trips.vin.li/api/v1/trips/e960a385-0ced-4654-8404-3238e147ad45",
                                                    @"snapshots" : @"https://trips.vin.li/api/v1/trips/e960a385-0ced-4654-8404-3238e147ad45/snapshots",
                                                    @"locations" : @"https://trips.vin.li/api/v1/trips/e960a385-0ced-4654-8404-3238e147ad45/locations",
                                                    @"vehicle" : @"https://platform.vin.li/api/v1/vehicles/27b8db50-1274-11e4-9191-0800200c9a66"
                                                    }
                                            }
                                        ],
                                @"meta": @{
                                        @"pagination" : @{
                                                @"totalCount" : @14,
                                                @"since" : @"2015-12-15T06:00:00.000Z",
                                                @"until" : @"2016-02-06T06:00:00.000Z",
                                                @"links" : @{
                                                        @"prior" : @"https://trips-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6b58/trips?until=1434129972999",
                                                        @"next" : @"https://trips.vin.li/api/v1/devices/d47ef610-c7b9-44ac-9a41-39f9c6056de5/trips?until=2016-02-06T00%3A00%3A00-06%3A00&limit=5&since=1450912114292&sortDir=asc",
                                                        }
                                                }
                                        }
                                };
    
    return rulesJSON;
}

+ (NSDictionary *) getAllVehiclesJSON:(NSString *) deviceId{
    NSDictionary *vehiclesJSON = @{
                                   @"vehicles" : @[
                                           @{
                                               @"id" : deviceId,
                                               @"year" : @"2007",
                                               @"make" : @"Toyota",
                                               @"model" : @"Camry",
                                               @"trim" : @"SE V6",
                                               @"vin" : @"2B4GP44R6WR942762"
                                               
                                               },
                                           @{
                                               @"id" : @"2a88b0f0-d6db-11e3-9c1a-0800200c9a66",
                                               @"vin" : @"JE3BW50W4NZ676124",
                                               @"make": @"Chevrolet",
                                               @"model": @"Cavalier",
                                               @"year": @"1994",
                                               @"trim": @"RS 4dr Sedan"
                                               }
                                           ],
                                   @"meta": @{
                                           @"pagination" : @{
                                                   @"total" : @24,
                                                   @"limit" : @10,
                                                   @"offset" : @0,
                                                   @"links" : @{
                                                           @"first" : @"https://platform.vin.li/api/v1/devices/821374c0-d6d8-11e3-9c1a-0800200c9a66/vehicles?offset=0&limit=10",
                                                           @"next" : @"https://platform.vin.li/api/v1/devices/821374c0-d6d8-11e3-9c1a-0800200c9a66/vehicles?offset=10&limit=10",
                                                           @"last" : @"https://platform.vin.li/api/v1/devices/821374c0-d6d8-11e3-9c1a-0800200c9a66/vehicles?offset=20&limit=10"
                                                           }
                                                   }
                                           }
                                   };
    
    return vehiclesJSON;
}

+ (NSDictionary *) getAllStartupsJSON{
    NSDictionary *startupsJSON = @{
                                   @"startups": @[
                                           @{
                                               @"id" : @"a367d821-aad1-4c8a-9446-507898d193f5",
                                               @"timestamp" : @"2014-07-23T14:17:18.332Z",
                                               @"vehicleId" : @"27b8db50-1274-11e4-9191-0800200c9a66"
                                               },
                                           @{
                                               @"id" : @"a367d821-aad1-4c8a-9446-507898d193f5",
                                               @"timestamp" : @"2014-07-23T14:17:18.332Z",
                                               @"vehicleId" : @"27b8db50-1274-11e4-9191-0800200c9a66"
                                               }
                                           ],
                                   @"meta": @{
                                           @"pagination" : @{
                                                   @"totalCount" : @14,
                                                   @"limit" : @10,
                                                   @"offset" : @0,
                                                   @"links" : @{
                                                           @"first" : @"https://platform.vin.li/api/v1/devices/821374c0-d6d8-11e3-9c1a-0800200c9a66/startups?offset=0&limit=10",
                                                           @"next" : @"https://platform.vin.li/api/v1/devices/821374c0-d6d8-11e3-9c1a-0800200c9a66/startups?offset=10&limit=10",
                                                           @"last" : @"https://platform.vin.li/api/v1/devices/821374c0-d6d8-11e3-9c1a-0800200c9a66/startups?offset=10&limit=10"
                                                           }
                                                   }
                                           }
                                   };
    return startupsJSON;
}

+ (NSDictionary *) getAllShutdownsJSON{
    NSDictionary *startupsJSON = @{
                                   @"shutdowns": @[
                                           @{
                                               @"id" : @"a367d821-aad1-4c8a-9446-507898d193f5",
                                               @"timestamp" : @"2014-07-23T14:17:18.332Z",
                                               @"vehicleId" : @"27b8db50-1274-11e4-9191-0800200c9a66"
                                               },
                                           @{
                                               @"id" : @"a367d821-aad1-4c8a-9446-507898d193f5",
                                               @"timestamp" : @"2014-07-23T14:17:18.332Z",
                                               @"vehicleId" : @"27b8db50-1274-11e4-9191-0800200c9a66"
                                               }
                                           ],
                                   @"meta": @{
                                           @"pagination" : @{
                                                   @"totalCount" : @14,
                                                   @"limit" : @10,
                                                   @"offset" : @0,
                                                   @"links" : @{
                                                           @"first" : @"https://platform.vin.li/api/v1/devices/821374c0-d6d8-11e3-9c1a-0800200c9a66/shutdowns?offset=0&limit=10",
                                                           @"next" : @"https://platform.vin.li/api/v1/devices/821374c0-d6d8-11e3-9c1a-0800200c9a66/shutdowns?offset=10&limit=10",
                                                           @"last" : @"https://platform.vin.li/api/v1/devices/821374c0-d6d8-11e3-9c1a-0800200c9a66/shutdowns?offset=10&limit=10"
                                                           }
                                                   }
                                           }
                                   };
    return startupsJSON;
}

+ (NSDictionary *) getParametricBoundaryJSON{
    int minSpeed = 10;
    int maxSpeed = 40;
    int rndValue = minSpeed + arc4random() % (maxSpeed - minSpeed);
    NSNumber *parametricBoundary = [NSNumber numberWithInt:rndValue];
    
    NSDictionary *parametricJSON = @{
                                     @"type" : @"parametric",
                                     @"parameter" : @"vehicleSpeed",
                                     @"min" : parametricBoundary,
                                     @"max" : @88
                                     };
    
    return parametricJSON;
}

+ (NSDictionary *) getRadiusBoundaryJSON{
    int minRadius = 100;
    int maxRadius = 1000;
    int rndValue = minRadius + arc4random() % (maxRadius - minRadius);
    NSNumber *radiusBoundary = [NSNumber numberWithInt:rndValue];
    
    
    
    NSDictionary *radiusJSON = @{
                                 @"type" : @"radius",
                                 @"lon" : @-90.0811,
                                 @"lat" : @29.9508,
                                 @"radius" : radiusBoundary
                                 };
    
    return radiusJSON;
}

+ (NSDictionary *) getSpecificMessageJSON{
    int minRPM = 100;
    int maxRPM = 1000;
    int rndValue = minRPM + arc4random() % (maxRPM - minRPM);
    NSNumber *rpmValue = [NSNumber numberWithInt:rndValue];
    
    
    
    NSDictionary *specificMessageJSON = @{
                                          @"message" :
                                              @{
                                                  @"timestamp": @"2014-07-14T17:46:06.759Z",
                                                  @"vehicleSpeed": @12,
                                                  @"calculatedLoadValue": @34.5,
                                                  @"fuelType": @"Gasoline",
                                                  @"rpm": rpmValue,
                                                  @"location": @{
                                                          @"longitude": @-90.0811,
                                                          @"latitude": @29.9508
                                                          
                                                          }
                                                  
                                                  }
                                          };
    
    return specificMessageJSON;
}
+ (NSDictionary *) getMessagesJSON{
    
    
    NSDictionary *messagesJSON = @{
        @"messages": @[
                     @{
                         @"id": @"76c84f74-0435-4272-aa43-d5d86224919b",
                         @"timestamp": @1423751986000,
                         @"links": @{
                             @"self": @"https://telemetry-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/messages/76c84f74-0435-4272-aa43-d5d86224919b"
                         },
                         @"location": @{
                             @"type": @"point",
                             @"coordinates": @[
                                             @-96.7906906487042,
                                             @32.7806014522268
                                             ]
                         }
                     },
                     @{
                         @"id": @"1f8e7e68-3d0f-4fe6-bc57-50060e0392ec",
                         @"timestamp": @1423751986000,
                         @"links": @{
                             @"self": @"https://telemetry-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/messages/1f8e7e68-3d0f-4fe6-bc57-50060e0392ec"
                         },
                         @"location": @{
                             @"type": @"point",
                             @"coordinates": @[
                                             @-96.7906917304936,
                                             @32.7806007623833
                                             ]
                         }
                     }
                     ],
        @"meta": @{
            @"pagination": @{
                @"remaining": @4754,
                @"limit": @20,
                @"until": @1432924394147,
                @"links": @{
                    @"prior": @"https://telemetry-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/messages?until=1423751966999"
                }
            }
        }
        };
    
    return messagesJSON;
}
+ (NSDictionary *) getSnapshotsJSON: (NSString *) deviceId{
    NSDictionary *dictionary = @{
                                 @"snapshots" : @[
                                         @{ @"timestamp": @1394733260050, @"vehicleSpeed": @12, @"calculatedLoadValue": @34.5, @"fuelType": @"Gasoline"},
                                         @{ @"timestamp": @1394733255337, @"vehicleSpeed": @15},
                                         @{ @"timestamp": @1394733251898, @"rpm": @3827, @"calculatedLoadValue": @56.3}
                                         ],
                                 @"meta" : @{
                                         @"pagination" : @{
                                                 @"remainingCount" : @1324,
                                                 @"limit" : @50,
                                                 @"until" : @1394733261450,
                                                 @"links" : @{
                                                         @"latest" : @"https://telemetry.vin.li/api/v1/devices/27a2ac50-d7bd-11e3-9c1a-0800200c9a66/snapshots?fields=rpm,vehicleSpeed,calculatedLoadValue,fuelType",
                                                         @"prior" : @"https://telemetry.vin.li/api/v1/devices/27a2ac50-d7bd-11e3-9c1a-0800200c9a66/snapshots?fields=rpm,vehicleSpeed,calculatedLoadValue,fuelType&until=1394733251897"
                                                         }
                                                 }
                                         }
                                 };
    return dictionary;
}

+ (NSDictionary *) getLocationsJSON{
    NSDictionary *locationMessageJSON= @{
        @"locations": @{
            @"type": @"FeatureCollection",
            @"features": @[
                         @{
                             @"type": @"Feature",
                             @"geometry": @{
                                 @"type": @"Point",
                                 @"coordinates": @[
                                                 @-96.7906906487042,
                                                 @32.7806014522268
                                                 ]
                             },
                             @"properties": @{
                                 @"id": @"76c84f74-0435-4272-aa43-d5d86224919b",
                                 @"timestamp": @1423751986000,
                                 @"links": @{
                                     @"self": @"https://telemetry-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/messages/76c84f74-0435-4272-aa43-d5d86224919b"
                                 }
                             }
                         },
                         @{
                             @"type": @"Feature",
                             @"geometry": @{
                                 @"type": @"Point",
                                 @"coordinates": @[
                                                 @-96.7906917304936,
                                                 @32.7806007623833
                                                 ]
                             },
                             @"meta": @{
                                 @"pagination": @{
                                     @"remaining": @3224,
                                     @"limit": @20,
                                     @"until": @1432919978211,
                                     @"links": @{
                                         @"prior": @"https://telemetry-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/locations?until=1423751966999"
                                     }
                                 }
                             }
                             }
                         ]
                         }
        };
    
    return locationMessageJSON;
}

+ (NSDictionary *) getAllRulesJSON: (NSString*) deviceId{
    NSDictionary *dictionary = @{
                                 @"rules" : @[
                                         @{
                                             @"id" : @"68d489c0-d7a2-11e3-9c1a-0800200c9a66",
                                             @"name" : @"Speed over 70mph",
                                             @"device" : deviceId,
                                             @"covered" : @false,
                                             @"links" : @{
                                                     @"self" : @"https://events.vin.li/api/v1/rules/68d489c0-d7a2-11e3-9c1a-0800200c9a66",
                                                     @"events" : @"https://events.vin.li/api/v1/rules/68d489c0-d7a2-11e3-9c1a-0800200c9a66/events"
                                                     }
                                             }
                                         ],
                                 @"meta" : @{
                                         @"pagination" : @{
                                                 @"total" : @1431,
                                                 @"offset" : @0,
                                                 @"limit" : @20,
                                                 @"links" : @{
                                                         @"first" : @"https://events.vin.li/api/v1/devices/602c6490-d7a3-11e3-9c1a-0800200c9a66/rules?offset=0&limit=20",
                                                         @"last" : @"https://events.vin.li/api/v1/devices/602c6490-d7a3-11e3-9c1a-0800200c9a66/rules?offset=1420&limit=20",
                                                         @"next" : @"https://events.vin.li/api/v1/devices/602c6490-d7a3-11e3-9c1a-0800200c9a66/rules?offset=20&limit=20"
                                                         }
                                                 }
                                         }
                                 };
    return dictionary;
}

+ (NSDictionary *) getSpecificSubscriptionJSON: (NSString *)subscriptionId{
    NSDictionary *specificSubscription = @{
                                           
                                           @"subscription": @{
                                                   @"id": subscriptionId,
                                                   @"deviceId": @"fe4bbc20-cc90-11e3-8e05-f3abac5b60ff",
                                                   @"eventType": @"rule-enter",
                                                   @"url": @"https://beagle-dev.vin.li/api/v1/notifications",
                                                   @"object": @{
                                                           @"id": @"030cdc30-e01f-4dad-9c6b-18b508fc07c6",
                                                           @"type": @"rule"
                                                           },
                                                   @"appData": @"{\"phoneNumber\":\"+15042207366\",\"body\":\"From Beagle: Test Device has exceeded the 35mph speed limit.\"}",
                                                   @"createdAt": @"2015-05-27T00:06:16.911Z",
                                                   @"updatedAt": @"2015-05-27T00:06:16.911Z",
                                                   @"links": @{
                                                           @"self": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/subscriptions/8b8f43b6-e851-439e-a9d4-8ec6afeab78f",
                                                           @"notifications": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/subscriptions/8b8f43b6-e851-439e-a9d4-8ec6afeab78f/notifications"
                                                           }
                                                   }
                                           };
    return specificSubscription;
}
+ (NSDictionary *) getAllSubscriptionsJSON:(NSString *) deviceId{
    NSDictionary *subscriptions = @{
                                    
                                    @"subscriptions": @[
                                            
                                            @{
                                                
                                                @"id": deviceId,
                                                
                                                @"deviceId": @"fe4bbc20-cc90-11e3-8e05-f3abac5b60ff",
                                                
                                                @"eventType": @"rule-enter",
                                                
                                                @"url": @"https://beagle-dev.vin.li/api/v1/notifications",
                                                
                                                @"object": @{
                                                        
                                                        @"id": @"646761fe-aade-41e2-b198-97b9c2259250",
                                                        
                                                        @"type": @"rule"
                                                        
                                                        },
                                                
                                                @"appData": @"{\"phoneNumber\":\"+15042207366\",\"body\":\"From Beagle: Test Device has exceeded the 37.282364198988404mph speed limit.\"}",
                                                
                                                @"createdAt": @"2015-05-22T18:51:20.718Z",
                                                
                                                @"updatedAt": @"2015-05-22T18:51:20.718Z",
                                                
                                                @"links": @{
                                                        
                                                        @"self": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/subscriptions/b8450a8b-dd41-4c7f-abda-aaf43043d64f",
                                                        
                                                        @"notifications": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/subscriptions/b8450a8b-dd41-4c7f-abda-aaf43043d64f/notifications"
                                                        
                                                        }
                                                
                                                }
                                            
                                            ],
                                    
                                    @"meta": @{
                                            
                                            @"pagination": @{
                                                    
                                                    @"total": @14,
                                                    
                                                    @"limit": @10,
                                                    
                                                    @"offset": @0,
                                                    
                                                    @"links": @{
                                                            
                                                            @"first": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/subscriptions?offset=0&limit=20",
                                                            
                                                            @"last": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/subscriptions?offset=40&limit=20",
                                                            
                                                            @"next": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/subscriptions?offset=20&limit=20"
                                                            }
                                                    }
                                            }
                                    };
    return subscriptions;
}

+ (NSDictionary *) getCreateSubscriptionsJSON {
    NSDictionary *subscriptions = @{
                                    @"subscription":@{
                                            @"eventType" : @"shutdown",
                                            @"url": @"https://myapp.vin.li/messages",
                                            @"appData" : @"{\"phoneNumber\" : \"1231231234\"}"
                                            }
                                    };
    return subscriptions;
}

+ (NSDictionary *) getDeviceJSON:(NSString *) deviceId{
    
    
    NSDictionary *deviceJSON = @{
                                 @"device" : @{
                                         @"id" : deviceId,
                                         @"links" : @{
                                                 @"self" : @"https://platform.vin.li/api/v1/devices/821374c0-d6d8-11e3-9c1a-0800200c9a66",
                                                 @"vehicles" : @"https://platform.vin.li/api/v1/devices/821374c0-d6d8-11e3-9c1a-0800200c9a66/vehicles",
                                                 @"latestVehicle" : @"https://platform.vin.li/api/v1/devices/821374c0-d6d8-11e3-9c1a-0800200c9a66/vehicles/_latest",
                                                 @"rules": @"https://rules-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/rules",
                                                 @"events": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/events",
                                                 @"subscriptions": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/subscriptions"
                                                 
                                                 }
                                         }
                                 };
    return deviceJSON;
}
//yolo
+ (NSDictionary *) getAllEventsOrSubscriptionsNotificationsJSON:(NSString *) subscriptionId;{
    //assuming this is using correct json, cant find a event id that gives any susbcriptions.
    NSDictionary *dictionary =  @{
                                  @"notifications": @[
                                          @{
                                              @"snapshot": @{
                                                      @"messageId" : @"2f11d630-141e-11e4-b717-5977b6c38d23",
                                                      @"timestamp": @1401307900001,
                                                      @"parameters": @{
                                                              @"vehicleSpeed": @145
                                                              },
                                                      @"links" : @{
                                                              @"self" : @"https://telemetry.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6400/messages/2f11d630-141e-11e4-b717-5977b6c38d23"
                                                              }
                                                      },
                                              @"rule": @{
                                                      @"id": @"68d489c0-d7a2-11e3-9c1a-0800200c9a66",
                                                      @"name": @"Speed over 70mph",
                                                      @"links": @{
                                                              @"self": @"https://events.vin.li/api/v1/rules/9244d870-141d-11e4-a15c-a5694c3ebd21"
                                                              },
                                                      @"notificationUrl": @"https://api.myapp.com/vinli_notifications",
                                                      @"notificationMetadata": @{
                                                              @"userFirstName": @"John",
                                                              @"userLastName": @"Sample",
                                                              @"smsPhoneNumber": @"2145551212"
                                                              }
                                                      },
                                              @"deviceId": @"fe4bbc20-cc90-11e3-8e05-f3abac5b6400",
                                              @"direction": @"leave"
                                              },
                                          @{
                                              @"snapshot": @{
                                                      @"messageId" : @"2f11d630-141e-11e4-b717-5977b6c38d23",
                                                      @"timestamp": @1401307900001,
                                                      @"parameters": @{
                                                              @"vehicleSpeed": @145
                                                              },
                                                      @"links" : @{
                                                              @"self" : @"https://telemetry.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6400/messages/2f11d630-141e-11e4-b717-5977b6c38d23"
                                                              }
                                                      },
                                              @"rule": @{
                                                      @"id": @"68d489c0-d7a2-11e3-9c1a-0800200c9a66",
                                                      @"name": @"Speed over 70mph",
                                                      @"links": @{
                                                              @"self": @"https://events.vin.li/api/v1/rules/9244d870-141d-11e4-a15c-a5694c3ebd21"
                                                              },
                                                      @"notificationUrl": @"https://api.myapp.com/vinli_notifications",
                                                      @"notificationMetadata": @{
                                                              @"userFirstName": @"John",
                                                              @"userLastName": @"Sample",
                                                              @"smsPhoneNumber": @"2145551212"
                                                              }
                                                      },
                                              @"deviceId": @"fe4bbc20-cc90-11e3-8e05-f3abac5b6400",
                                              @"direction": @"leave"
                                              }
                                          ],
                                  @"meta": @{
                                          @"pagination": @{
                                                  @"links": @{
                                                          @"prior": @"https://events.vin.li/api/v1/subscriptions/532a8946-ec5c-4f53-803a-e336e02a8c0f/notifications?since=2016-02-11T13%3A21%3A18-06%3A00&limit=1&until=1455817232505",
                                                          @"next": @"https://events.vin.li/api/v1/subscriptions/532a8946-ec5c-4f53-803a-e336e02a8c0f/notifications?since=1455737282236&sortDir=asc&limit=1"
                                                          }
                                                  }
                                          }
                                  };
    return dictionary;
}

+ (NSDictionary *) getNotificationJSON:(NSString *)notificationId{
    NSDictionary *dictionary =  @{
                                  @"id": notificationId,
                                  @"snapshot": @{
                                          @"messageId" : @"2f11d630-141e-11e4-b717-5977b6c38d23",
                                          @"timestamp": @1401307900001,
                                          @"parameters": @{
                                                  @"vehicleSpeed": @145
                                                  },
                                          @"links" : @{
                                                  @"self" : @"https://telemetry.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6400/messages/2f11d630-141e-11e4-b717-5977b6c38d23"
                                                  }
                                          },
                                  @"rule": @{
                                          @"id": @"68d489c0-d7a2-11e3-9c1a-0800200c9a66",
                                          @"name": @"Speed over 70mph",
                                          @"links": @{
                                                  @"self": @"https://events.vin.li/api/v1/rules/9244d870-141d-11e4-a15c-a5694c3ebd21"
                                                  },
                                          @"notificationUrl": @"https://api.myapp.com/vinli_notifications",
                                          @"notificationMetadata": @{
                                                  @"userFirstName": @"John",
                                                  @"userLastName": @"Sample",
                                                  @"smsPhoneNumber": @"2145551212"
                                                  }
                                          },
                                  @"deviceId": @"fe4bbc20-cc90-11e3-8e05-f3abac5b6400",
                                  @"direction": @"leave"
                                  };
    return dictionary;
}
//YOLO
+ (NSDictionary *) getAllEventsJSON:(NSString *) deviceId{
    NSDictionary *eventsJSON = @{
                                 @"events": @[
                                         @{
                                             @"id": @"538f1195-a733-4ee7-a4e8-1fbbe7131f6a",
                                             @"timestamp": @"2015-05-22T23:33:57.000Z",
                                             @"deviceId": deviceId,
                                             @"stored": @"2015-05-22T23:33:58.741Z",
                                             @"storageLatency": @1741,
                                             @"eventType": @"rule-leave",
                                             @"meta": @{
                                                     @"direction": @"leave",
                                                     @"firstEval": @false,
                                                     @"rule": @{
                                                             @"id": @"429f9aa7-4c97-42c1-a459-ee1df6bc625b",
                                                             @"name": @"[speed]",
                                                             @"deviceId": deviceId,
                                                             @"boundaries": @[
                                                                     @{
                                                                         @"id": @"0cadb0c8-a1c3-4176-86f2-20280ea72ad9",
                                                                         @"type": @"parametric",
                                                                         @"parameter": @"vehicleSpeed",
                                                                         @"min": @48
                                                                         }
                                                                     ],
                                                             @"evaluated": @true,
                                                             @"covered": @false,
                                                             @"createdAt": @"",//TBD probably cant be null...
                                                             @"links": @{
                                                                     @"self": @"https://rules-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/rules/429f9aa7-4c97-42c1-a459-ee1df6bc625b"
                                                                     }
                                                             },
                                                     @"message": @{
                                                             @"id": @"60afa670-d15b-4d2f-81bf-a068f4a9a7fb",
                                                             @"timestamp": @"2015-05-22T23:33:57.000Z",
                                                             @"snapshot": @{
                                                                     @"location": @{
                                                                             @"lat": @33.0246240995378,
                                                                             @"lon": @-97.0560955928522
                                                                             },
                                                                     @"vehicleSpeed": @32
                                                                     }
                                                             }
                                                     },
                                             @"object": @{
                                                     @"id": @"429f9aa7-4c97-42c1-a459-ee1df6bc625b",
                                                     @"type": @"rule",
                                                     @"appId": @"b75afd8f-7247-46e6-a0f9-04f187c9d9bd"
                                                     },
                                             @"links": @{
                                                     @"self": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/events/538f1195-a733-4ee7-a4e8-1fbbe7131f6a",
                                                     @"notifications": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/events/538f1195-a733-4ee7-a4e8-1fbbe7131f6a/notifications"
                                                     }
                                             },
                                         @{
                                             @"id": @"c7d39034-d7ee-4c0c-b115-55eadf592cee",
                                             @"timestamp": @"2015-05-22T20:13:50.000Z",
                                             @"deviceId": deviceId,
                                             @"stored": @"2015-05-22T20:13:51.317Z",
                                             @"storageLatency": @1317,
                                             @"eventType": @"rule-leave",
                                             @"meta": @{
                                                     @"direction": @"leave",
                                                     @"firstEval": @true,
                                                     @"rule": @{
                                                             @"id": @"519b43f0-074d-49ed-b7f5-59e3bde445ca",
                                                             @"name": @"[speed]",
                                                             @"deviceId": deviceId,
                                                             @"boundaries": @[
                                                                     @{
                                                                         @"id": @"15c56dca-95c8-49f8-b079-34b134094598",
                                                                         @"type": @"parametric",
                                                                         @"parameter": @"vehicleSpeed",
                                                                         @"min": @97
                                                                         }
                                                                     ],
                                                             @"evaluated": @true,
                                                             @"covered": @false,
                                                             @"createdAt": @"",
                                                             @"links": @{
                                                                     @"self": @"https://rules-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/rules/519b43f0-074d-49ed-b7f5-59e3bde445ca"
                                                                     }
                                                             },
                                                     @"message": @{
                                                             @"id": @"6d898185-4634-4ec9-8796-16a75b1634da",
                                                             @"timestamp": @"2015-05-22T20:13:50.000Z",
                                                             @"snapshot": @{
                                                                     @"location": @{
                                                                             @"lat": @32.7834842959724,
                                                                             @"lon": @-96.7700372078426
                                                                             },
                                                                     @"vehicleSpeed": @0
                                                                     }
                                                             }
                                                     },
                                             @"object": @{
                                                     @"id": @"519b43f0-074d-49ed-b7f5-59e3bde445ca",
                                                     @"type": @"rule",
                                                     @"appId": @"b75afd8f-7247-46e6-a0f9-04f187c9d9bd"
                                                     },
                                             @"links": @{
                                                     @"self": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/events/c7d39034-d7ee-4c0c-b115-55eadf592cee",
                                                     @"notifications": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/events/c7d39034-d7ee-4c0c-b115-55eadf592cee/notifications"
                                                     }
                                             }
                                         ],
                                 @"meta": @{
                                         @"pagination": @{
                                                 @"remaining": @109,
                                                 @"limit": @10,
                                                 @"until": @"2015-05-27T21:32:19.186Z",
                                                 @"links": @{
                                                         @"prior": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/events?until=2015-05-22T20%3A13%3A49.999Z"
                                                         }
                                                 }
                                         }
                                 };
    return eventsJSON;
}

+ (NSDictionary *) getEventJSON:(NSString *) eventId{
    NSDictionary *eventJSON = @{
                                @"event": @{
                                        @"id": eventId,
                                        @"timestamp": @"2015-05-22T23:33:57.000Z",
                                        @"deviceId": @"fe4bbc20-cc90-11e3-8e05-f3abac5b60ff",
                                        @"stored": @"2015-05-22T23:33:58.741Z",
                                        @"storageLatency": @1741,
                                        @"eventType": @"rule-leave",
                                        @"meta": @{
                                                @"direction": @"leave",
                                                @"firstEval": @false,
                                                @"rule": @{
                                                        @"id": @"429f9aa7-4c97-42c1-a459-ee1df6bc625b",
                                                        @"name": @"[speed]",
                                                        @"deviceId": @"fe4bbc20-cc90-11e3-8e05-f3abac5b60ff",
                                                        @"boundaries": @[
                                                                @{
                                                                    @"id": @"0cadb0c8-a1c3-4176-86f2-20280ea72ad9",
                                                                    @"type": @"parametric",
                                                                    @"parameter": @"vehicleSpeed",
                                                                    @"min": @48
                                                                    }
                                                                ],
                                                        @"evaluated": @true,
                                                        @"covered": @false,
                                                        @"createdAt": @"",
                                                        @"links": @{
                                                                @"self": @"https://rules-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/rules/429f9aa7-4c97-42c1-a459-ee1df6bc625b"
                                                                }
                                                        },
                                                @"message": @{
                                                        @"id": @"60afa670-d15b-4d2f-81bf-a068f4a9a7fb",
                                                        @"timestamp": @"2015-05-22T23:33:57.000Z",
                                                        @"snapshot": @{
                                                                @"location": @{
                                                                        @"lat": @33.0246240995378,
                                                                        @"lon": @-97.0560955928522
                                                                        },
                                                                @"vehicleSpeed": @32
                                                                }
                                                        }
                                                },
                                        @"object": @{
                                                @"id": @"429f9aa7-4c97-42c1-a459-ee1df6bc625b",
                                                @"type": @"rule",
                                                @"appId": @"b75afd8f-7247-46e6-a0f9-04f187c9d9bd"
                                                },
                                        @"links": @{
                                                @"self": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/events/538f1195-a733-4ee7-a4e8-1fbbe7131f6a",
                                                @"notifications": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/events/538f1195-a733-4ee7-a4e8-1fbbe7131f6a/notifications"
                                                }
                                        }
                                };
    return eventJSON;
}

+ (NSDictionary *) getAllDevicesJSON{
    NSDictionary *dictionary = @{
                                 @"devices": @[
                                         @{
                                             @"id": @"fe4bbc20-cc90-11e3-8e05-f3abac5b6411",
                                             @"links": @{
                                                     @"self": @"https://platform-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411",
                                                     @"vehicles": @"https://platform-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/vehicles",
                                                     @"latestVehicle": @"https://platform-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/vehicles/_latest",
                                                     @"rules": @"https://rules-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/rules",
                                                     @"events": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/events",
                                                     @"subscriptions": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/subscriptions"
                                                     }
                                             },
                                         @{
                                             @"id": @"fe4bbc20-cc90-11e3-8e05-f3abac5b60ff",
                                             @"links": @{
                                                     @"self": @"https://platform-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff",
                                                     @"vehicles": @"https://platform-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/vehicles",
                                                     @"latestVehicle": @"https://platform-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/vehicles/_latest",
                                                     @"rules": @"https://rules-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/rules",
                                                     @"events": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/events",
                                                     @"subscriptions": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/subscriptions"
                                                     }
                                             }
                                         ],
                                 @"meta": @{
                                         @"pagination": @{
                                                 @"total": @2,
                                                 @"limit": @20,
                                                 @"offset": @0,
                                                 @"links": @{
                                                         @"first": @"https://platform-dev.vin.li/api/v1/devices?offset=0&limit=20",
                                                         @"last": @"https://platform-dev.vin.li/api/v1/devices?offset=0&limit=20"
                                                         }
                                                 }
                                         }
                                 };
    return dictionary;
}

+ (NSDictionary *) getUserJSON{
    NSDictionary *dictionary = @{
                                 @"user": @{
                                         @"id": @"6b24cb2a-1b17-4fc3-9c6a-df0a2c0062f5",
                                         @"firstName": [NSNull null],
                                         @"lastName": [NSNull null],
                                         @"email": @"example@gmail.com",
                                         @"phone": @"+12312312345",
                                         @"image": [NSNull null],
                                         @"createdAt": [NSNull null]
                                         }
                                 };
    return dictionary;
}

+ (NSDictionary *) getUserDevicesJSON{
    NSDictionary *dictionary = @{
                                 @"devices": @[
                                         @{
                                             @"id": @"fe4bbc20-cc90-11e3-8e05-f3abac5b6411",
                                             @"links": @{
                                                     @"self": @"https://platform-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411",
                                                     @"vehicles": @"https://platform-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/vehicles",
                                                     @"latestVehicle": @"https://platform-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/vehicles/_latest",
                                                     @"rules": @"https://rules-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/rules",
                                                     @"events": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/events",
                                                     @"subscriptions": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b6411/subscriptions"
                                                     }
                                             },
                                         @{
                                             @"id": @"fe4bbc20-cc90-11e3-8e05-f3abac5b60ff",
                                             @"links": @{
                                                     @"self": @"https://platform-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff",
                                                     @"vehicles": @"https://platform-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/vehicles",
                                                     @"latestVehicle": @"https://platform-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/vehicles/_latest",
                                                     @"rules": @"https://rules-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/rules",
                                                     @"events": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/events",
                                                     @"subscriptions": @"https://events-dev.vin.li/api/v1/devices/fe4bbc20-cc90-11e3-8e05-f3abac5b60ff/subscriptions"
                                                     }
                                             }
                                         ]
                                 };
    return dictionary;
}

@end
