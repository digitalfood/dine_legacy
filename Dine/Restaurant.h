//
//  Business.h
//  Yelp
//
//  Created by Pythis Ting on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Restaurant : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ratingImageUrl;
@property (nonatomic, assign) NSInteger numReviews;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *categories;
@property (nonatomic, assign) CGFloat distance;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

+ (NSArray *)businessesWithDictionaries:(NSArray *)dictionaries;
- (MKMapItem*)mapItem;

@end
