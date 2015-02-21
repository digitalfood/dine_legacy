//
//  SectionViewController.m
//  Dine
//
//  Created by Pythis Ting on 2/18/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "SectionViewController.h"
#import "RestaurantView.h"
#import "YelpClient.h"
#import "Parse/Parse.h"

NSString * const K_YELP_CCONSUMER_KEY = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const K_YELP_CONSUMER_SECRET = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const K_YELP_TOKEN = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const K_YELP_TOKEN_SECRET = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";
float const METERS_PER_MILE = 1609.344;

@interface SectionViewController () <UIScrollViewDelegate, CLLocationManagerDelegate, RestaurantViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, assign) CGFloat sectionWidth;
@property (nonatomic, assign) CGFloat sectionHeight;

@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSMutableArray *restaurants;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation SectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [[YelpClient alloc] initWithConsumerKey:K_YELP_CCONSUMER_KEY consumerSecret:K_YELP_CONSUMER_SECRET accessToken:K_YELP_TOKEN accessSecret:K_YELP_TOKEN_SECRET];
        
        if (![CLLocationManager locationServicesEnabled]){
            NSLog(@"location services are disabled");
        }
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            NSLog(@"location services are blocked by the user");
        }
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
            NSLog(@"location services are enabled");
        }
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
            NSLog(@"about to show a dialog requesting permission");
        }
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.distanceFilter = 100.0f;
        self.locationManager.headingFilter = 5;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        if ([CLLocationManager locationServicesEnabled]){
            [self.locationManager startUpdatingLocation];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.sectionWidth = [[UIScreen mainScreen] bounds].size.width;
    self.sectionHeight = self.view.frame.size.height;
    
    [self.view setFrame:CGRectMake(0, 0, self.sectionWidth, self.sectionHeight)];
    
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];

    self.scrollView.delegate = self;
    
    self.pageControl.hidden = YES;
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scroll View Delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = floor((self.scrollView.contentOffset.x - self.sectionWidth / 2 ) / self.sectionWidth) + 1; //this provide you the page number
    
    if (self.pageControl.currentPage != page) {
        [self.delegate swipeToRestaurant:self.restaurants[page]];
    }
    self.pageControl.currentPage = page;// this displays the white dot as current page
}

#pragma mark - Core Location Manager Delegate methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSLog(@"User has denied location services");
    } else {
        NSLog(@"Location manager did fail with error: %@", error.localizedFailureReason);
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    self.location = [locations lastObject];
    [self reloadData];
}

#pragma mark - Restaurant View Delegate methods

- (void)tapOnRestaurant:(Restaurant *)restaurant {
    [self.delegate tapOnRestaurant:restaurant];
}

#pragma mark - private methods

- (void)reloadData {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.location != nil) {
        NSString *currentLocation = [NSString stringWithFormat:@"%+.6f,%+.6f",self.location.coordinate.latitude, self.location.coordinate.longitude];
        [params setObject:currentLocation forKey:@"ll"];
    
        [self.client searchWithTerm:@"Restaurants" params:params success:^(AFHTTPRequestOperation *operation, id response) {
            NSArray *restaurantsDictionary = response[@"businesses"];
            NSArray *restaurants = [Restaurant businessesWithDictionaries:restaurantsDictionary];
            self.restaurants = [NSMutableArray arrayWithArray:restaurants];
            [self updateUI];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }
}

- (void)updateUI {
    // remove existing restua from
    for(UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
    }
    
    NSInteger numberOfViews = self.restaurants.count;
    
    self.pageControl.numberOfPages = numberOfViews;
    self.pageControl.currentPage = 0;
    
    for (int i = 0; i < numberOfViews; i++) {
        CGFloat xOrigin = i * self.sectionWidth;
        RestaurantView *restaurantView = [[RestaurantView alloc] init];
        restaurantView.delegate = self;
        restaurantView.frame = CGRectMake(xOrigin, 0, self.sectionWidth, self.sectionHeight);
        // restaurantView.backgroundColor = [UIColor colorWithRed:0.5/i green:0.5 blue:0.5 alpha:1];
        restaurantView.restaurant = self.restaurants[i];
        [self.scrollView addSubview:restaurantView];
    }
    self.scrollView.contentSize = CGSizeMake(self.sectionWidth * numberOfViews, self.sectionHeight);

}

@end
