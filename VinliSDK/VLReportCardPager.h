//
//  VLReportCardPager.h
//  VinliSDK
//
//  Created by Andrew Wells on 11/21/16.
//  Copyright © 2016 Vinli. All rights reserved.
//

#import "VLChronoPager.h"
#import "VLParsable.h"

@interface VLReportCardPager : VLChronoPager <VLParsable>

@property (readonly, nonatomic) NSArray* reportCards;

@end
