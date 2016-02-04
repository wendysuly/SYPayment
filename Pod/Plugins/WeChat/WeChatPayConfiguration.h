//
//  WeChatPayConfiguration.h
//  Pods
//
//  Created by Sean Yue on 16/2/4.
//
//

#import <Foundation/Foundation.h>

@interface WeChatPayConfiguration : NSObject

@property (nonatomic) NSString *appId;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSString *reserveData;

@end
