//
//  AlipayManager.m
//  SYPayment
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 SYPayment. All rights reserved.
//

#import "AlipayManager.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import <Aspects.h>
#import <objc/runtime.h>

@interface AlipayManager ()
@property (nonatomic,copy) AlipayResultBlock resultBlock;
@property (nonatomic,retain) AlipayOrder *payOrder;
@end

@implementation AlipayManager

#pragma mark - shareInstance
+ (AlipayManager *)shareInstance
{
    static AlipayManager *alipayManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        alipayManager = [[AlipayManager alloc] init];
    });
    return alipayManager;
}



#pragma mark -  function
/*!
 *	@brief 支付宝支付接口
 *  @param orderId  订单的id ，在调用创建订单之后服务器会返回该订单的id
 *  @param price    商品价格
 *  @result
 */
- (void)startAlipayWithOrderId:(NSString *)orderId price:(NSUInteger)price result:(AlipayResultBlock)resultBlock;
{
    self.resultBlock = resultBlock;
    
    AlipayOrder *order  = [[AlipayOrder alloc] init];
    order.partner       = _configuation.partner;
    order.seller        = _configuation.seller;
    
    order.tradeNO       = orderId;         //订单ID（由商家自行制定）
    order.productName   = _configuation.productInfo; //商品标题
    order.productDescription = _configuation.productDesc; //商品描述
    order.amount        = [NSString stringWithFormat:@"%.2f", price/100.];           //商品价格
    order.notifyURL     =  _configuation.notifyUrl; //回调URL
    
    order.service       = @"mobile.securitypay.pay";
    order.paymentType   = @"1";
    order.inputCharset  = @"utf-8";
    order.itBPay        = @"30m";
    order.showUrl       = @"m.alipay.com";

    NSString *orderInfo = [order description];
    NSString *appScheme = _configuation.urlScheme;
//
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer   = CreateRSADataSigner(_configuation.privateKey);
    NSString *signedString  = [signer signString:orderInfo];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil)
    {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderInfo, signedString, @"RSA"];
        
        self.payOrder = order;
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic)
        {
            [self sendNotificationByResult:resultDic];
        }];
    }
    
}

/*!
 *	@brief 支付宝处理通过URL启动app时传递的数据
 *  @param url 支付宝启动第三方应用传递过来的url
 *  @result
 */
- (void)handleOpenURL:(NSURL *)url {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        [self sendNotificationByResult:resultDic];
    }];
}

- (void)sendNotificationByResult:(NSDictionary *)_resultDic
{
    SYPaymentResult payResult = SYPaymentResultUnknown;
    if([[_resultDic allKeys] containsObject:@"resultStatus"])
    {
        NSString * resultStatues  = _resultDic[@"resultStatus"];
        if([resultStatues isEqualToString:@"6001"]) {
            payResult = SYPaymentResultCancel;
        } else if ([resultStatues isEqualToString:@"9000"]) {
            payResult = SYPaymentResultSuccess;
        } else {
            payResult = SYPaymentResultFail;
        }
    }
    
    if (self.resultBlock) {
        self.resultBlock(payResult, self.payOrder);
    }
}

@end
