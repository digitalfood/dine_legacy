//
//  MainViewController.m
//  Dine
//
//  Created by Pythis Ting on 2/17/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "MainViewController.h"
#import "SectionViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIView *sectionView;
@property (weak, nonatomic) IBOutlet UIView *listView;

@property (nonatomic, strong) SectionViewController *svc;

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, assign) CGFloat initialConstant;
@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) BOOL sideMenuOpened;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.svc = [[SectionViewController alloc] init];
    self.svc.view.frame = self.sectionView.frame;
    [self.sectionView addSubview:self.svc.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
