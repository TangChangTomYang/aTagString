//
//  YRTagInfo.m
//  fasfdas
//
//  Created by edz on 2020/12/4.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "YRTagInfo.h"

@implementation YRTagInfo
+(instancetype)infoOfName:(NSString *)name{
    YRTagInfo *info =  [[self alloc] init];
    info.name = name;
    return info;
}
@end
