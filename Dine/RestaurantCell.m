//
//  BusinessCell.m
//  Yelp
//
//  Created by Pythis Ting on 1/28/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "RestaurantCell.h"
#import "UIImageView+AFNetworking.h"

@interface RestaurantCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@end

@implementation RestaurantCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRestautant:(Restaurant *)business {
    _restautant = business;
    
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:business.imageUrl]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:business.imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0f];
    [self.thumbImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [UIView transitionWithView:self.thumbImageView duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ self.thumbImageView.image = image;
        } completion:nil];
    } failure:nil];
    
    self.nameLabel.text = self.restautant.name;
    
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:business.ratingImageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0f];
    [self.ratingImageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [UIView transitionWithView:self.ratingImageView duration:1.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{ self.ratingImageView.image = image;
        } completion:nil];
    } failure:nil];
    
    self.ratingLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.restautant.numReviews];
//    self.addressLabel.text = self.restautant.address;
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.restautant.distance];
    self.categoryLabel.text = self.restautant.categories;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

@end
