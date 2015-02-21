//
//  MainViewController.m
//  Dine
//
//  Created by Pythis Ting on 2/17/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "MainViewController.h"
#import "SectionViewController.h"
#import "RestaurantDetailViewController.h"
#import "Parse/Parse.h"

float const ANIMATION_DURATION = 0.5;

@interface MainViewController () <SectionViewControllerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>
@property (weak, nonatomic) IBOutlet UIView *sectionView;
@property (weak, nonatomic) IBOutlet UIView *listView;

@property (nonatomic, strong) SectionViewController *svc;
@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, assign) int animationType;

@end

@implementation MainViewController

typedef enum {
    ANIMATION_TYPE_BUBBLE,
    ANIMATION_TYPE_EXPAND
} ANIMATION_TYPE;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.svc = [[SectionViewController alloc] init];
    self.svc.delegate = self;
    self.svc.view.frame = self.sectionView.frame;
    [self.sectionView addSubview:self.svc.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SectionViewControllerDelegate methods

- (void)swipeToRestaurant:(Restaurant *)restaurant {
    NSLog(@"swiped to : %@", restaurant.name);
    
    // Joanna please update food menu view controller accordingly
    PFQuery *query = [PFQuery queryWithClassName:@"Food"];
    [query whereKey:@"parent" equalTo:[PFObject objectWithoutDataWithClassName:@"Restaurant" objectId:@"eS2FBIaZ4s"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *food in objects) {
            NSLog(@"%@", food);
        }
    }];
    
}

- (void)tapOnRestaurant:(Restaurant *)restaurant {
    // TODO: display restaurant detail page
    RestaurantDetailViewController *rdvc = [[RestaurantDetailViewController alloc] init];
    rdvc.restaurant = restaurant;
    rdvc.modalPresentationStyle = UIModalPresentationCustom;
    rdvc.transitioningDelegate = self;
    [self presentViewController:rdvc animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate methods

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    if ([presented isKindOfClass:[RestaurantDetailViewController class]]) {
        self.animationType = ANIMATION_TYPE_EXPAND;
    } else {
        self.animationType = ANIMATION_TYPE_BUBBLE;
    }
    self.isPresenting = YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresenting = NO;
    return self;
}

//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
//    
//}
//
//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
//    
//}
//
//- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0) {
//    
//}

#pragma mark - UIViewControllerAnimatedTransitioning methods

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return ANIMATION_DURATION;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    switch (self.animationType) {
        case ANIMATION_TYPE_EXPAND:
            [self tansitionInExpandForContext:transitionContext];
            break;
        case ANIMATION_TYPE_BUBBLE:
            [self tansitionInBubbleForContext:transitionContext];
            break;
        default:
            break;
    }
}

#pragma mark - private methods

- (void)tansitionInBubbleForContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Fabio you can use this function for rendering tip calculator
    
    UIView *containerView = [transitionContext containerView];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    if (self.isPresenting) {
        [containerView addSubview:toViewController.view];
        toViewController.view.alpha = 0;
        toViewController.view.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            toViewController.view.alpha = 1;
            toViewController.view.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        fromViewController.view.alpha = 1;
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            fromViewController.view.alpha = 0;
            fromViewController.view.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [fromViewController.view removeFromSuperview];
        }];
    }
}

- (void)tansitionInExpandForContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    CGFloat yRatio = self.sectionView.frame.size.height / [[UIScreen mainScreen] bounds].size.height;
    
    if (self.isPresenting) {
        [containerView addSubview:toViewController.view];
        toViewController.view.alpha = 0;
        toViewController.view.center = CGPointMake(toViewController.view.center.x, self.sectionView.frame.size.height / 2);
        toViewController.view.transform = CGAffineTransformMakeScale(1, yRatio);
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            toViewController.view.center = CGPointMake(toViewController.view.center.x, [[UIScreen mainScreen] bounds].size.height / 2);
            toViewController.view.alpha = 1;
            toViewController.view.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        fromViewController.view.alpha = 1;
        fromViewController.view.center = CGPointMake(toViewController.view.center.x, [[UIScreen mainScreen] bounds].size.height / 2);
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            fromViewController.view.center = CGPointMake(toViewController.view.center.x, self.sectionView.frame.size.height / 2);
            fromViewController.view.alpha = 0;
            fromViewController.view.transform = CGAffineTransformMakeScale(1, yRatio);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [fromViewController.view removeFromSuperview];
        }];
    }
}

@end
