//
//  DishView.h
//  Dine
//
//  Created by Joanna Chan on 2/21/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DishView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *dishImage;
@property (weak, nonatomic) IBOutlet UILabel *dishName;
@property (assign, nonatomic) NSInteger dishRating;

@end
