//
//  Business.m
//  Yelp
//
//  Created by Pythis Ting on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "Restaurant.h"
#import <AddressBook/AddressBook.h>

@implementation Restaurant

float const MILES_PER_METER = 0.000621371;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSArray *categories = dictionary[@"categories"];
        NSMutableArray *categoryNames = [NSMutableArray array];
        [categories enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [categoryNames addObject:obj[0]];
        }];
        self.categories = [categoryNames componentsJoinedByString:@", "];

        self.id = dictionary[@"id"];
        self.name = dictionary[@"name"];
        self.imageUrl = [dictionary[@"image_url"] stringByReplacingOccurrencesOfString:@"ms.jpg" withString:@"l.jpg"];
        NSArray *address = [dictionary valueForKeyPath:@"location.address"];
        NSArray *neighborhoods = [dictionary valueForKeyPath:@"location.neighborhoods"];
        if (address.count == 0 && neighborhoods.count == 0) {
            self.address = @"";
        } else {
            NSString *street = @"", *neighborhood = @"";
            if (address.count > 0) {
                street = [dictionary valueForKeyPath:@"location.address"][0];
            }
            if (neighborhoods.count > 0) {
                neighborhood = [dictionary valueForKeyPath:@"location.neighborhoods"][0];
            }
            if (address.count > 0 && neighborhoods.count > 0) {
                self.address = [NSString stringWithFormat:@"%@, %@", street, neighborhood];
            } else {
                self.address = [NSString stringWithFormat:@"%@", address.count > 0 ? street : neighborhood];
            }
        }
        self.numReviews = [dictionary[@"review_count"] integerValue];
        self.ratingImageUrl = dictionary[@"rating_img_url"];
        self.distance = [dictionary[@"distance"] integerValue] * MILES_PER_METER;
        
        NSDictionary *coordinate = [dictionary valueForKeyPath:@"location.coordinate"];
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = [coordinate[@"latitude"] doubleValue];
        theCoordinate.longitude = [coordinate[@"longitude"] doubleValue];
        
        self.theCoordinate = theCoordinate;
    }
    
    return self;
}

+ (NSArray *)businessesWithDictionaries:(NSArray *)dictionaries {
    NSMutableArray *businesses = [NSMutableArray array];
    
    for (NSDictionary *dictionary in dictionaries) {
        Restaurant *business = [[Restaurant alloc] initWithDictionary:dictionary];
        [businesses addObject:business];
    }
    
    return businesses;
}

- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    return self.address;
}

- (CLLocationCoordinate2D)coordinate {
    return self.theCoordinate;
}

- (MKMapItem *)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : self.address};
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.name;
    
    return mapItem;
}

@end
