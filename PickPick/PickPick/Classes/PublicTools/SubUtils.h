//
//  SubUtils.h
//  SubWork
//
//  Created by Dylan on 14/12/1.
//  Copyright (c) 2014年 Dylan. All rights reserved.
//

#ifndef SubWork_SubUtils_h
#define SubWork_SubUtils_h

#ifdef DEBUG
#define ADLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define ADLog(...)
#endif

#import "UIColor+DylanColor.h"
#import "UIImage+DylanImage.h"
#import "UIView+DylanToast.h"
#import "NSString+SubString.h"
#import "SubHeader.h"
#endif
