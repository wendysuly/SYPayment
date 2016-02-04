//
//  SYPViewController.m
//  SYPayment
//
//  Created by Yu Xulu on 02/02/2016.
//  Copyright (c) 2016 Yu Xulu. All rights reserved.
//

#import "SYPViewController.h"
#import <SYPayment/AlipayManager.h>
#import <SYPayment/WeChatPayManager.h>

@interface SYPViewController ()

@end

@implementation SYPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onAlipay:(id)sender {
    [[AlipayManager shareInstance] startAlipayWithOrderId:[NSUUID UUID].UUIDString
                                                    price:1
                                                   result:^(SYPaymentResult result, AlipayOrder *order)
     {
        
    }];
}

- (IBAction)onWeChatPay:(id)sender {
    [[WeChatPayManager sharedInstance] startWeChatPayWithOrderId:[[NSUUID UUID].UUIDString substringToIndex:32]
                                                           price:1
                                               completionHandler:^(SYPaymentResult payResult)
    {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
