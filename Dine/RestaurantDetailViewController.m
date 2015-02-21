//
//  RestaurantDetailViewController.m
//  Dine
//
//  Created by Pythis Ting on 2/21/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "RestaurantDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface RestaurantDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *restaurantImageView;

@end

@implementation RestaurantDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restaurantImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.restaurantImageView setClipsToBounds:YES];
    
    // handle tap gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    self.view.userInteractionEnabled = YES;
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.restaurant.imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0f];
    
    __weak RestaurantDetailViewController *this = self;
    [self.restaurantImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        RestaurantDetailViewController *stronlyRetainedView = this;
        [UIView transitionWithView:stronlyRetainedView.restaurantImageView duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ stronlyRetainedView.restaurantImageView.image = image;
        } completion:nil];
    } failure:nil];
    
}

#pragma mark - Gesture methods

- (IBAction)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
