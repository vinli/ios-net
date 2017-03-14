//
//  VLLocationMessage.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/27/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLLocation.h"
#import "NSDictionary+NonNullable.h"
#import "VLDateFormatter.h"

@implementation VLLocation

- (id)initWithDictionary: (NSDictionary *) dictionary{
    
    if (self = [super init])
    {
        if (dictionary)
        {
            dictionary = [dictionary filterAllNSNullValues];
            
            _locationType = dictionary[@"type"];
            
            
            // Note: Apparently the JSON can come in two different schemas here. One schema type has location data in sub object named `geometry`. The other schema has location data at root level. So here we are seeing if the geometry object exists and parsing in one way or tother.
            if (dictionary[@"geometry"])
            {
                _geometryType = dictionary[@"geometry"][@"type"];
                
                if (dictionary[@"geometry"][@"coordinates"])
                {
                    _longitude = [dictionary[@"geometry"][@"coordinates"][0] doubleValue];
                    _latitude = [dictionary[@"geometry"][@"coordinates"][1] doubleValue];
                }
            }
            else {
                // alternate schema
                if (dictionary[@"type"])
                {
                    _geometryType = dictionary[@"type"];
                }
                
                if (dictionary[@"coordinates"])
                {
                    _longitude = [dictionary[@"coordinates"][0] doubleValue];
                    _latitude = [dictionary[@"coordinates"][1] doubleValue];
                }
            }
            
            _properties = [dictionary objectForKey:@"properties"];
        }
    }
    return self;
}

- (NSString *)locationId {
    return [self.properties vl_getStringAttributeForKey:@"id" defaultValue:nil];;
}

- (NSString *)timeStampStr {
    return [self.properties vl_getStringAttributeForKey:@"timestamp" defaultValue:nil];;;
}

- (NSDate *)timeStamp {
    return [VLDateFormatter initializeDateFromString:self.timeStampStr];
}

- (NSString *)description
{
     return [NSString stringWithFormat: @"latitude: %f, longitude: %f", _latitude, _longitude];
}

@end
