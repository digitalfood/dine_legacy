//
//  MainViewController.m
//  Dine
//
//  Created by Pythis Ting on 2/17/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "MainViewController.h"
#import "RestaurantsViewController.h"
#import "SideMenuCell.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *sectionView;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sideMenuYOffset;

@property (nonatomic, strong) RestaurantsViewController *rvc;

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, assign) CGFloat initialConstant;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) BOOL sideMenuOpened;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.menuItems = @[@{@"name": @"Home"}, @{@"name": @"Settings"}];
    
    [self.menuTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.menuTableView setLayoutMargins:UIEdgeInsetsZero];
    self.menuTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.menuTableView.dataSource = self;
    self.menuTableView.delegate = self;
    [self.menuTableView registerNib:[UINib nibWithNibName:@"SideMenuCell" bundle:nil] forCellReuseIdentifier:@"SideMenuCell"];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    self.rvc = [[RestaurantsViewController alloc] init];
    self.rvc.view.frame = self.sectionView.frame;
    [self.sectionView addSubview:self.rvc.view];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        SideMenuCell *cell = [self.menuTableView dequeueReusableCellWithIdentifier:@"SideMenuCell"];
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
        NSDictionary *menuItem = self.menuItems[indexPath.row];
//        [cell.iconImageView setImage:[UIImage imageNamed:menuItem[@"icon"]]];
        cell.menuLabel.text = menuItem[@"name"];
        
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self closeSideMenuAnimated:YES];
}

#pragma mark - Private methods

- (void)openSideMenu {
    self.sideMenuOpened = YES;
    self.sideMenuYOffset.constant = 0;

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)closeSideMenuAnimated:(bool)animated {
    self.sideMenuOpened = NO;
    self.sideMenuYOffset.constant = -200;

    if (!animated) {
        [self.view layoutIfNeeded];
        return;
    }
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:0 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (IBAction)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.initialConstant = self.sideMenuYOffset.constant;
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat newOffset = self.initialConstant + translation.y;
        if (newOffset <= 0 && newOffset >= -200) {
            self.sideMenuYOffset.constant = newOffset;
        }
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (velocity.y > 0) {
            [self openSideMenu];
        } else if (velocity.y < 0) {
            [self closeSideMenuAnimated:YES];
        }
    }
}

@end
