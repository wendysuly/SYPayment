//
//  WeChatPayManager.m
//  SYPayment
//
//  Created by Sean Yue on 15/11/13.
//  Copyright © 2015年 SYPayment. All rights reserved.
//

#import "WeChatPayManager.h"
#import "WXApi.h"
#import "payRequsestHandler.h"
#import <Aspects.h>

static NSString *const kWeChatPayQueryOrderUrlString = @"https://api.mch.weixin.qq.com/pay/orderquery";
static NSString *const kSuccessString = @"SUCCESS";

@implementation WeChatOrderQueryResponse

- (instancetype)initFromDictionary:(NSDictionary *)dic {
    self = [self init];
    if (self) {
        self.return_code = dic[@"return_code"];
        self.result_code = dic[@"result_code"];
        self.trade_state = dic[@"trade_state"];
        self.total_fee = ((NSString *)dic[@"total_fee"]).integerValue;
        self.bank_type = dic[@"bank_type"];
        self.fee_type = dic[@"fee_type"];
    }
    return self;
}

- (BOOL)success {
    return [self.return_code isEqualToString:kSuccessString] && [self.result_code isEqualToString:kSuccessString];
}
@end

@interface WeChatPayManager () <WXApiDelegate>
@property (nonatomic,copy) WeChatPayCompletionHandler handler;
@end

@implementation WeChatPayManager

+ (instancetype)sharedInstance {
    static WeChatPayManager *_theInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _theInstance = [[WeChatPayManager alloc] init];
    });
    return _theInstance;
}

- (void)setConfiguration:(WeChatPayConfiguration *)configuration {
    _configuration = configuration;
    
    [WXApi registerApp:configuration.appId];
}

- (void)startWeChatPayWithOrderId:(NSString *)orderId price:(NSUInteger)price completionHandler:(WeChatPayCompletionHandler)handler {
    _handler = handler;
    
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] initWithConfiguration:_configuration];
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPayWithOrderNo:orderId price:price];
    
#ifdef DEBUG
    NSLog(@"%@\n\n",[req getDebugifo]);
#endif
    
    if (dict != nil) {
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}

- (void)handleOpenURL:(NSURL *)url {
    [WXApi handleOpenURL:url delegate:self];
}

- (void)queryOrder:(NSString *)orderId withCompletionHandler:(WeChatQueryOrderCompletionHandler)handler {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        srand( (unsigned)time(0) );
        NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
        
        NSMutableDictionary *params = @{@"appid":_configuration.appId,
                                        @"mch_id":_configuration.mchId,
                                        @"out_trade_no":orderId,
                                        @"nonce_str":noncestr}.mutableCopy;
        //创建支付签名对象
        payRequsestHandler *req = [[payRequsestHandler alloc] initWithConfiguration:_configuration];
        
        NSString *package = [req genPackage:params];
        NSData *data =[WXUtil httpSend:kWeChatPayQueryOrderUrlString method:@"POST" data:package];
        
        XMLHelper *xml  = [[XMLHelper alloc] init];
        
        //开始解析
        [xml startParse:data];
        
        NSDictionary *resParams = [xml getDict];
        WeChatOrderQueryResponse *resp = [[WeChatOrderQueryResponse alloc] initFromDictionary:resParams];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(resp);
        });
    });
}

#pragma mark - WeChat delegate

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        SYPaymentResult payResult = SYPaymentResultUnknown;
        if (resp.errCode == WXErrCodeUserCancel) {
            payResult = SYPaymentResultCancel;
        } else if (resp.errCode == WXSuccess) {
            payResult = SYPaymentResultSuccess;
        } else {
            payResult = SYPaymentResultFail;
        }
        
        if (_handler) {
            _handler(payResult);
        }
    }
}
@end