//
//  MainViewController.m
//  Dine
//
//  Created by Pythis Ting on 2/16/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "RestaurantsViewController.h"
#import "SVProgressHUD.h"
#import "YelpClient.h"
#import "BusinessCell.h"

NSString * const K_YELP_CCONSUMER_KEY = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const K_YELP_CONSUMER_SECRET = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const K_YELP_TOKEN = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const K_YELP_TOKEN_SECRET = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";
float const METERS_PER_MILE = 1609.344;

@interface RestaurantsViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CLLocation* location;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSMutableArray *businesses;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation RestaurantsViewController

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

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BusinessCell" bundle:nil] forCellReuseIdentifier:@"BusinessCell"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BusinessCell"];
    cell.business = self.businesses[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
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

#pragma mark - private methods

- (void)reloadData {
    [SVProgressHUD showWithStatus:@"Loading"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.location != nil) {
        NSString *currentLocation = [NSString stringWithFormat:@"%+.6f,%+.6f",self.location.coordinate.latitude, self.location.coordinate.longitude];
        NSLog(@"current location: %@", currentLocation);
        [params setObject:currentLocation forKey:@"ll"];
    }
    [self.client searchWithTerm:@"Restaurants" params:params success:^(AFHTTPRequestOperation *operation, id response) {
        NSArray *businessesDictionary = response[@"businesses"];
        NSArray *businesses = [Business businessesWithDictionaries:businessesDictionary];
        self.businesses = [NSMutableArray arrayWithArray:businesses];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"error: %@", [error description]);
    }];
}

@end
