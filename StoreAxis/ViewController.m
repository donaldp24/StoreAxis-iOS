//
//  ViewController.m
//  StoreAxis
//
//  Created by Donald Pae on 4/9/14.
//  Copyright (c) 2014 damy. All rights reserved.
//

#import "ViewController.h"
#import "View+MASAdditions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        CGRect rtBtn = self.btnLogin.frame;
        make.left.equalTo(@0);
        make.right.equalTo(@(self.view.frame.size.width / 2));
        make.top.equalTo(@(self.view.frame.size.height - rtBtn.size.height));
    }];
    
    [self.btnRegister mas_makeConstraints:^(MASConstraintMaker *make) {
        CGRect rtBtn = self.btnRegister.frame;
        make.left.equalTo(@(self.view.frame.size.width / 2));
        make.right.equalTo(self.view);
        make.top.equalTo(@(self.view.frame.size.height - rtBtn.size.height));
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLoginClicked:(id)sender
{
    [self performSegueWithIdentifier:@"toMain" sender:self];
}

- (IBAction)onRegisterClicked:(id)sender
{
    //
}

@end
