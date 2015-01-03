//
//  NSString+SubString.m
//  SubWork
//
//  Created by Dylan on 14/12/1.
//  Copyright (c) 2014年 Dylan. All rights reserved.
//

#import "NSString+SubString.h"

@implementation NSString (SubString)

- (NSString *)URLEncoding
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                                              (CFStringRef)self,
                                                                                              NULL,
                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                              kCFStringEncodingUTF8 ));
    return result;
}

- (NSString *)UTF8Encoding
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault,
                                                                                              (CFStringRef)self,
                                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                              NULL,
                                                                                              kCFStringEncodingUTF8 ));
    return result;
}

- (NSString *)URLDecoding
{
    NSString * result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""), kCFStringEncodingUTF8));
    return result;
    //	NSMutableString * string = [NSMutableString stringWithString:self];
    //    [string replaceOccurrencesOfString:@"+"
    //							withString:@" "
    //							   options:NSLiteralSearch
    //								 range:NSMakeRange(0, [string length])];
    //    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)MD5
{
    unsigned char *CC_MD5();
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (BOOL)isVersionEqualAndGreaterThan:(NSString *)version
{
    NSArray *currentSepArr = [self componentsSeparatedByString:@"."];
    NSArray *targetSepArr = [version componentsSeparatedByString:@"."];
    NSInteger maxIdx = [targetSepArr count] >= [currentSepArr count] ? [currentSepArr count] + 1: [currentSepArr count] + 1;
    
    BOOL flag = NO;
    for (NSInteger idx = 0 ;idx < maxIdx; idx++) {
        
        NSString *targetBit = nil;
        if (idx < [targetSepArr count]) {
            targetBit = [targetSepArr objectAtIndex:idx];
        }
        
        NSString *currentBit = nil;
        if (idx < [currentSepArr count]) {
            currentBit = [currentSepArr objectAtIndex:idx];
        }
        
        if (targetBit && currentBit) {
            if (targetBit.integerValue > currentBit.integerValue) {
                flag = NO;
                break;
            }
            else if (targetBit.integerValue < currentBit.integerValue)
            {
                flag = YES;
                break;
            }
            else
            {
                continue;
            }
        }
        else if (targetBit && !currentBit)
        {
            flag = NO;
            break;
        }
        else if (!targetBit && currentBit)
        {
            flag = YES;
            break;
        }
        else
        {
            //都没有的时候，是相等的
            flag = YES;
            break;
        }
    }
    return flag;
}

- (BOOL)isVersionEqualAndLessThan:(NSString *)version
{
    NSArray *targetSepArr = [version componentsSeparatedByString:@"."];
    NSArray *currentSepArr = [self componentsSeparatedByString:@"."];
    NSInteger maxIdx = [targetSepArr count] >= [currentSepArr count] ? [targetSepArr count] + 1: [currentSepArr count] + 1;
    
    BOOL flag = NO;
    for (NSInteger idx = 0 ;idx < maxIdx; idx++) {
        
        NSString *targetBit = nil;
        if (idx < [targetSepArr count]) {
            targetBit = [targetSepArr objectAtIndex:idx];
        }
        
        NSString *currentBit = nil;
        if (idx < [currentSepArr count]) {
            currentBit = [currentSepArr objectAtIndex:idx];
        }
        
        if (targetBit && currentBit) {
            if (targetBit.integerValue > currentBit.integerValue) {
                flag = YES;
                break;
            }
            else if (targetBit.integerValue < currentBit.integerValue)
            {
                flag = NO;
                break;
            }
            else
            {
                continue;
            }
        }
        else if (targetBit && !currentBit)
        {
            flag = YES;
            break;
        }
        else if (!targetBit && currentBit)
        {
            flag = NO;
            break;
        }
        else
        {
            flag = YES;
            break;
        }
    }
    return flag;
}

- (BOOL)empty
{
    return [self length] > 0 ? NO : YES;
}


+ (NSString *)escapeHTML:(NSString*)string
{
    NSMutableString *newString = [[NSMutableString alloc] initWithString:string];
    
    [newString replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:NSMakeRange(0, [newString length])];
    [newString replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [newString length])];
    [newString replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:NSMakeRange(0, [newString length])];
    [newString replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:NSMakeRange(0, [newString length])];
    
    return newString;
}

+ (NSString *)unescapeHTML:(NSString*)string
{
    //强制检查 以防crash
    if (string == nil || [string isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    
    NSMutableString *newString = [[NSMutableString alloc] initWithString:string];
    
    [newString replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [newString length])];
    [newString replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [newString length])];
    [newString replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, [newString length])];
    [newString replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, [newString length])];
    
    return newString;
}

- (NSData *)UTF8Data
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)isValidateHTTPURL
{
    NSString *urlRegEx =
    @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:self];
}

- (NSString *)trimWhitespace
{
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((CFMutableStringRef)str);
    return str;
}

- (NSUInteger)unicodeLengthOfString
{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < self.length; i++)
    {
        unichar uc = [self characterAtIndex:i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength % 2) {
        unicodeLength++;
    }
    return unicodeLength;
}

- (NSString *)unicodeMaxLength:(NSUInteger)length
{
    NSUInteger maxLength = 0;
    NSInteger asciiRemainLength = length * 2;
    
    for (maxLength = 0; maxLength < self.length; maxLength++)
    {
        unichar uc = [self characterAtIndex:maxLength];
        NSUInteger assciiCharLength = isascii(uc) ? 1 : 2;
        asciiRemainLength -= assciiCharLength;
        if (asciiRemainLength < 0) {
            break;
        }
    }
    return [self substringToIndex:maxLength];
}


+(BOOL)validateEmail:(NSString*)email
{
    if((0 != [email rangeOfString:@"@"].length) &&
       (0 != [email rangeOfString:@"."].length))
    {
        NSCharacterSet* tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet* tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        
        /*
         *使用compare option 来设定比较规则，如
         *NSCaseInsensitiveSearch是不区分大小写
         *NSLiteralSearch 进行完全比较,区分大小写
         *NSNumericSearch 只比较定符串的个数，而不比较字符串的字面值
         */
        NSRange range1 = [email rangeOfString:@"@"
                                      options:NSCaseInsensitiveSearch];
        
        //取得用户名部分
        NSString* userNameString = [email substringToIndex:range1.location];
        NSArray* userNameArray   = [userNameString componentsSeparatedByString:@"."];
        
        for(NSString* string in userNameArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet: tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length != 0 || [string isEqualToString:@""])
                return NO;
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray   = [domainString componentsSeparatedByString:@"."];
        
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars=[string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if(rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
                return NO;
        }
        
        return YES;
    }
    else {
        return NO;
    }
}

//利用正则表达式验证
+(BOOL)isValidateEmail:(NSString *)email {
    
    NSArray *array = [email componentsSeparatedByString:@"."];
    if ([array count] >= 4) {
        return FALSE;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (NSString *)getSubStringWithLimit:(NSInteger)limit string:(NSString *)startString
{
    if (!startString || startString.length == 0)
    {
        return nil;
    }
    __block int length = 0;
    NSMutableString *subNewText = [[NSMutableString alloc] init];
    [startString enumerateSubstringsInRange:NSMakeRange(0, startString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        length += substringRange.length;
        if (length <= limit) {
            [subNewText appendString:substring];
        }
    }];
    return subNewText;
}


@end
