//
//  VLTrip.m
//  VinliSDK
//
//  Created by Tommy Brown on 5/26/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
// 

#import "VLTrip.h"
#import "NSDictionary+NonNullable.h"

static NSDateFormatter* isoDateFormatter;

@interface VLTrip()
@property (strong, nonatomic) NSDate* startDate;
@property (strong, nonatomic) NSDate* stopDate;
@end

@implementation VLTrip

- (id) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self){
        
        if(dictionary){
            
            if(dictionary[@"trip"] != nil){
                dictionary = dictionary[@"trip"];
            }
            
            _tripId = [dictionary objectForKey:@"id"];
            _start = [dictionary jsonObjectForKey:@"start"];
            _stop = [dictionary jsonObjectForKey:@"stop"];
            _status = [dictionary objectForKey:@"status"];
            _vehicleId = [dictionary objectForKey:@"vehicleId"];
            _deviceId = [dictionary objectForKey:@"deviceId"];
            _distance = [dictionary objectForKey:@"distance"];
            _duration = [dictionary objectForKey:@"duration"];
            _locationCount = [dictionary objectForKey:@"locationCount"];
            _messageCount = [dictionary objectForKey:@"messageCount"];
            _mpg = [dictionary objectForKey:@"mpg"];
            if ([dictionary[@"preview"] isKindOfClass:[NSString class]]) {
                _preview = dictionary[@"preview"];
            }
            
            _startPoint = ([dictionary jsonObjectForKey:@"startPoint"]) ? [[VLLocation alloc] initWithDictionary:[dictionary objectForKey:@"startPoint"]] : nil;
            _stopPoint = ([dictionary jsonObjectForKey:@"stopPoint"]) ? [[VLLocation alloc] initWithDictionary:[dictionary objectForKey:@"stopPoint"]] : nil;
            _orphanedAt = [dictionary objectForKey:@"orphanedAt"];
            
            if([dictionary objectForKey:@"links"]){
                _selfURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"self"]];
                _deviceURL = [NSURL URLWithString:[[dictionary objectForKey:@"link"] objectForKey:@"device"]];
                _vehicleURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"vehicle"]];
                _locationsURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"locations"]];
                _messagesURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"messages"]];
                _eventsURL = [NSURL URLWithString:[[dictionary objectForKey:@"links"] objectForKey:@"events"]];
            }
            
            if ([dictionary jsonObjectForKey:@"stats"])
            {
                _stats = [dictionary jsonObjectForKey:@"stats"];
            }
        
        }
    }
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat: @"Trip Id:%@, start:%@, stop:%@, status:%@, Vehicle Id%@", self.tripId, self.start, self.stop, self.status, self.vehicleId];
}


- (void)initializeDateFormatter
{
    if (isoDateFormatter) {
        return;
    }
    
    isoDateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [isoDateFormatter setLocale:enUSPOSIXLocale];
    [isoDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
}


- (NSDate *)startDate
{
    if (!_startDate) {
        [self initializeDateFormatter];
        _startDate = [isoDateFormatter dateFromString:self.start];
    }
    
    return _startDate;
}

- (NSDate *)stopDate
{
    if (!_stopDate) {
        [self initializeDateFormatter];
        _stopDate = [isoDateFormatter dateFromString:self.stop];
    }
    
    return _stopDate;
}




@end
