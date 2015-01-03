//
//  NSString+SubString.h
//  SubWork
//
//  Created by Dylan on 14/12/1.
//  Copyright (c) 2014年 Dylan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SubString)

- (NSString *)URLEncoding;

//url编码成utf-8 str
- (NSString *)UTF8Encoding;

//url解码成unicode str
- (NSString *)URLDecoding;

//计算md5
- (NSString *)MD5;

//是否是空字符串
- (BOOL)empty;

//转换成data
- (NSData *)UTF8Data;

//是否是个有效的http/https/ftp url，可以判断端口，或者不要协议名称
- (BOOL)isValidateHTTPURL;

//去除字符串前后的空格字符串。
- (NSString *)trimWhitespace;

//判断长度，两个英文字符为一个长度，一个中文字符为一个长度
- (NSUInteger)unicodeLengthOfString;

//截取字符串，两个英文字符为一个长度，一个中文字符为一个长度
- (NSString *)unicodeMaxLength:(NSUInteger)length;

//字符串版本号大小比较
- (BOOL)isVersionEqualAndGreaterThan:(NSString *)version;
- (BOOL)isVersionEqualAndLessThan:(NSString *)version;

//通过区分字符串
+(BOOL)validateEmail:(NSString*)email;

//利用正则表达式验证
+(BOOL)isValidateEmail:(NSString *)email;

//获取前多少个字符串
+ (NSString *)getSubStringWithLimit:(NSInteger)limit string:(NSString *)startString;


@end
