//
//  RestaurantView.m
//  Dine
//
//  Created by Pythis Ting on 2/18/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "RestaurantView.h"
#import "UIImageView+AFNetworking.h"

@interface RestaurantView()

@property (strong, nonatomic) IBOutlet UIImageView *restaurantImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation RestaurantView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)setRestaurant:(Restaurant *)restaurant {
    _restaurant = restaurant;

    self.restaurantImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.restaurantImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.restaurantImageView setClipsToBounds:YES];
    [self addSubview:self.restaurantImageView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.restaurant.imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0f];
    
    NSLog(@"image url:%@", self.restaurant.imageUrl);
    
    __weak RestaurantView *rv = self;
    [self.restaurantImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        RestaurantView *stronlyRetainedView = rv;
        [UIView transitionWithView:stronlyRetainedView duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ stronlyRetainedView.restaurantImageView.image = image;
        } completion:nil];
    } failure:nil];

    UIFont *font = [UIFont systemFontOfSize:25];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect nameLabelRect = [self.restaurant.name boundingRectWithSize:CGSizeMake(self.frame.size.width - 40, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:attributes
                                                        context:nil];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, nameLabelRect.size.width, nameLabelRect.size.height)];
    self.nameLabel.font = [UIFont systemFontOfSize:25];
    self.nameLabel.text = self.restaurant.name;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.numberOfLines = 2;

    [self addSubview:self.nameLabel];
}

@end