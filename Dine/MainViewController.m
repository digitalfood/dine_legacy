//
//  MainViewController.m
//  Dine
//
//  Created by Pythis Ting on 2/17/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "MainViewController.h"
#import "SectionViewController.h"
#import "DishView.h"
#import "RestaurantDetailViewController.h"
#import "Parse/Parse.h"

float const ANIMATION_DURATION = 0.5;

@interface MainViewController () <UIScrollViewDelegate, SectionViewControllerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) IBOutlet UIView *sectionView;
@property (weak, nonatomic) IBOutlet UIView *listView;

@property (nonatomic, strong) SectionViewController *svc;
@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, assign) int animationType;

//dish
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSLayoutConstraint *constraintHeight;
@property (nonatomic, strong) NSMutableArray *contrainstArray;
@property (nonatomic, assign) BOOL pageOpened;
@property (nonatomic, assign) CGRect originalScrollViewFrame;

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
    
    [self configureScrollView];
    [self adjustDishes];

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

//dishes

- (void)configureScrollView
{
    _contrainstArray = [[NSMutableArray alloc] init];
    
    _scrollView = [UIScrollView new];
    [_scrollView setDelegate:self];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_scrollView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    
    _constraintHeight = [NSLayoutConstraint constraintWithItem:_scrollView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:253];
    
    [self.view addConstraint:_constraintHeight];
    self.originalScrollViewFrame = _scrollView.frame;
    
}


- (void)adjustDishes
{
    DishView *previousDish = nil;
    
    for (NSInteger i = 0; i < 10; i++) {
        CGRect dishFrame = self.view.frame;
        dishFrame.size.width = 143;
        dishFrame.size.height = 253;
        
        DishView *dish = [[DishView alloc] initWithFrame:dishFrame];
        [dish setTag:i];
        
        dish.dishName.text = [NSString stringWithFormat:@"%d", i];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        [dish addGestureRecognizer:tapGestureRecognizer];
        
        dish.translatesAutoresizingMaskIntoConstraints = NO;
        [_scrollView addSubview:dish];
        
        // Default constraints
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:dish
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.0
                                                                 constant:0]];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:dish
                                                                attribute:NSLayoutAttributeBottom
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.0
                                                                 constant:0]];
        
        NSLayoutConstraint *storyWidthConstraint = [NSLayoutConstraint constraintWithItem:dish
                                                                                attribute:NSLayoutAttributeWidth
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nil
                                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                                               multiplier:1.0
                                                                                 constant:143];
        
        [_scrollView addConstraint:storyWidthConstraint];
        [_contrainstArray addObject:storyWidthConstraint];
        
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:dish
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeHeight
                                                               multiplier:1.0
                                                                 constant:0]];
        
        if (!previousDish) {
            
            [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:dish
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_scrollView
                                                                    attribute:NSLayoutAttributeLeft
                                                                   multiplier:1.0
                                                                     constant:0]];
            
        } else {
            
            [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:dish
                                                                    attribute:NSLayoutAttributeLeft
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:previousDish
                                                                    attribute:NSLayoutAttributeRight
                                                                   multiplier:1.0
                                                                     constant:0]];
            
        }
        previousDish = dish;
    }
    
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:previousDish
                                                            attribute:NSLayoutAttributeRight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeRight
                                                           multiplier:1.0
                                                             constant:0]];
}


- (void)handleTapFrom:(UITapGestureRecognizer *)sender
{
    NSInteger element = sender.view.tag;
    NSLog(@"selected element: %ld", (long)element);
    CGRect frame = _originalScrollViewFrame;
    frame.origin.x = _pageOpened ? 143 * element : self.view.frame.size.width * element;
    //[_scrollView scrollRectToVisible:frame animated:YES];
    [_scrollView setContentOffset:CGPointMake(frame.origin.x, 0) animated:YES];
    
    if (!_pageOpened) {
        
        [self.view removeConstraint:_constraintHeight];
        _constraintHeight = [NSLayoutConstraint constraintWithItem:_scrollView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant:0];
        [self.view addConstraint:_constraintHeight];
        [self increaseStoriesSize];
        
    
    } else {
        
        [self.view removeConstraint:_constraintHeight];
        _constraintHeight = [NSLayoutConstraint constraintWithItem:_scrollView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:253];
        [self.view addConstraint:_constraintHeight];
        [self decreaseStoriesSize];
        
    }
    
    
    [_scrollView setPagingEnabled:!_pageOpened];
    
    [self.view setNeedsUpdateConstraints];
    [_scrollView setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.6 animations:^{
        
        [self.view layoutIfNeeded];
        [_scrollView layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        _pageOpened = !_pageOpened;
    }];
    
     
}


- (void)increaseStoriesSize
{
    for (NSLayoutConstraint *constraint in _contrainstArray) {
        [constraint setConstant:self.view.frame.size.width];
    }
}


- (void)decreaseStoriesSize
{
    for (NSLayoutConstraint *constraint in _contrainstArray) {
        [constraint setConstant:143];
    }
}


@end
