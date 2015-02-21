//
//  DishView.m
//  Dine
//
//  Created by Joanna Chan on 2/21/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "DishView.h"

@interface DishView ()
@property (strong, nonatomic) IBOutlet DishView *contentView;
@end


@implementation DishView

- (id) initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]){
        [self setup];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setup {
    UINib *nib = [UINib nibWithNibName:@"DishView" bundle:nil];
    NSArray *objects = [nib instantiateWithOwner:self options:nil];
    
    self.contentView.frame = self.bounds;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.contentView];
    
}

@end
