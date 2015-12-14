//
//  VLSnapshotPager.m
//  VinliSDK
//
//  Created by Josh Beridon on 5/29/15.
//  Copyright (c) 2015 Vinli. All rights reserved.
//

#import "VLSnapshotPager.h"
#import "VLSnapshot.h"

@implementation VLSnapshotPager

- (id) initWithDictionary:(NSDictionary *)dictionary fields:(NSString *)fields{
    
    self = [super initWithDictionary:dictionary];
    if(self){
        if(dictionary){
            if(dictionary[@"snapshots"]){
                NSArray *jsonArray = dictionary[@"snapshots"];
                NSMutableArray *snapshotsArray = [[NSMutableArray alloc] init];
                for(NSDictionary *snapshot in jsonArray){
                    [snapshotsArray addObject:[[VLSnapshot alloc] initWithDictionary:snapshot fields:fields]];
                }
                
                _snapshots = snapshotsArray;
            }   
        }
    }
    return self;
}


@end
