//
//  TipViewController.m
//  Dine
//
//  Created by Pythis Ting on 2/12/15.
//  Copyright (c) 2015 Yahoo!, inc. All rights reserved.
//

#import "TipViewController.h"

@interface TipViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tipControl;

@property (nonatomic, assign) double billAmount;

- (void)updateUI;

@end

@implementation TipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.billAmount = 0;
    self.billTextField.delegate = self;
    [self updateUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI {
    NSArray *tipValues = @[@"0.15", @"0.18", @"0.2"];
    
    float tipAmount = self.billAmount * [tipValues[self.tipControl.selectedSegmentIndex] floatValue];
    float totalAmount = tipAmount + self.billAmount;
    
    self.tipLabel.text = [NSString stringWithFormat:@"$%0.2f", tipAmount];
    self.totalLabel.text = [NSString stringWithFormat:@"$%0.2f", totalAmount];
}

- (IBAction)onTap:(UISegmentedControl *)sender {
    [self updateUI];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    self.billAmount = [[self.billTextField.text stringByAppendingString:string] floatValue];
    
    [self updateUI];
    
    return YES;
}

@end
