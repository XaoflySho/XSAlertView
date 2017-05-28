//
//  XSViewController.m
//  XSAlertView
//
//  Created by 邵晓飞 on 05/06/2017.
//  Copyright (c) 2017 邵晓飞. All rights reserved.
//

#import "XSViewController.h"
#import <XSAlertView/XSAlertView.h>

@interface XSViewController () <XSAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UISegmentedControl *segmented;

@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

@implementation XSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)buttonClick:(id)sender {
    
    XSAlertView *alertView = [[XSAlertView alloc]initWithXSAlertViewStyle:(int)self.segmented.selectedSegmentIndex Message:_textField.text CancelButtonTitle:nil OtherButtonTitles:nil];
    alertView.delegate = self;
    [alertView viewShow];
    
}

- (IBAction)button2:(id)sender {
    XSAlertView *alertView = [[XSAlertView alloc]initWithXSAlertViewStyle:(int)self.segmented.selectedSegmentIndex Message:_textField.text CancelButtonTitle:@"OK" OtherButtonTitles:nil];
    alertView.delegate = self;
    [alertView viewShow];
}

- (IBAction)button3:(id)sender {
    XSAlertView *alertView = [[XSAlertView alloc]initWithXSAlertViewStyle:(int)self.segmented.selectedSegmentIndex Message:_textField.text CancelButtonTitle:@"OK" OtherButtonTitles:@[@"Action One",@"Action Two",@"Action Three"]];
    alertView.delegate = self;
    [alertView viewShow];
    
}

- (void)XSAlertView:(XSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"ClickedButtonIndex:%ld",(long)buttonIndex);
}

- (void)XSAlertViewCancel:(XSAlertView *)alertView {
    
    NSLog(@"XSAlertViewCancel");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
