//
//  SYPCommonTypes.h
//  Pods
//
//  Created by Sean Yue on 16/2/3.
//
//

#ifndef SYPCommonTypes_h
#define SYPCommonTypes_h

typedef NS_ENUM(NSUInteger, SYPaymentType) {
    SYPaymentTypeNone,
    SYPaymentTypeAlipay = 1001,
    SYPaymentTypeWeChatPay = 1008,
    SYPaymentTypeUPPay = 1009
};

typedef NS_ENUM(NSUInteger, SYPaymentResult)
{
    SYPaymentResultSuccess  = 0,
    SYPaymentResultFail     = 1,
    SYPaymentResultCancel   = 2,
    SYPaymentResultUnknown  = 3
};

#endif /* SYPCommonTypes_h */
