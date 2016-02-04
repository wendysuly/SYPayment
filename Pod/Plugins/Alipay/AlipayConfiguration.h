//
//  AlipayConfiguration.h
//  Pods
//
//  Created by Sean Yue on 16/2/3.
//
//

#import <Foundation/Foundation.h>

@interface AlipayConfiguration : NSObject

@property (nonatomic) NSString *partner;
@property (nonatomic) NSString *seller;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *productInfo;
@property (nonatomic) NSString *productDesc;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSString *urlScheme;

@end
