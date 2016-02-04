//
//  WeChatPayManager.h
//  SYPayment
//
//  Created by Sean Yue on 15/11/13.
//  Copyright © 2015年 SYPayment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SYPCommonTypes.h"
#import "WeChatPayConfiguration.h"

@interface WeChatOrderQueryResponse : NSObject

@property (nonatomic) NSString *return_code;
@property (nonatomic) NSString *result_code;
@property (nonatomic) NSString *trade_state;
@property (nonatomic) NSString *bank_type;
@property (nonatomic) NSUInteger total_fee;
@property (nonatomic) NSString *fee_type;

@property (nonatomic,readonly) BOOL success;
@end

typedef void (^WeChatPayCompletionHandler)(SYPaymentResult payResult);
typedef void (^WeChatQueryOrderCompletionHandler)(WeChatOrderQueryResponse *response);

@interface WeChatPayManager : NSObject

@property (nonatomic,retain) WeChatPayConfiguration *configuration;

+ (instancetype)sharedInstance;

- (void)startWeChatPayWithOrderId:(NSString *)orderId price:(NSUInteger)price completionHandler:(WeChatPayCompletionHandler)handler;
- (void)queryOrder:(NSString *)orderId withCompletionHandler:(WeChatQueryOrderCompletionHandler)handler;
- (void)handleOpenURL:(NSURL *)url;

@end
