//
//  AlipayManager.h
//  SYPayment
//
//  Created by Sean Yue on 15/9/8.
//  Copyright (c) 2015年 SYPayment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYPCommonTypes.h"
#import "AlipayConfiguration.h"
#import "AlipayOrder.h"

typedef void (^AlipayResultBlock)(SYPaymentResult result, AlipayOrder *order);

@interface AlipayManager : NSObject

@property (nonatomic,retain) AlipayConfiguration *configuation;

+ (AlipayManager *)shareInstance;
/*!
 *	@brief 支付宝支付接口
 *  @param orderId  订单的id ，在调用创建订单之后服务器会返回该订单的id
 *  @param price    商品价格 (单位：分)
 *  @result
 */
- (void)startAlipayWithOrderId:(NSString *)orderId price:(NSUInteger)price result:(AlipayResultBlock)resultBlock;

/*!
 *	@brief 支付宝处理通过URL启动app时传递的数据
 *  @param url 支付宝启动第三方应用传递过来的url
 *  @result
 */
- (void)handleOpenURL:(NSURL *)url;

@end
