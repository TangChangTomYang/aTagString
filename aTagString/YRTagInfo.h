//
//  YRTagInfo.h
//  fasfdas
//
//  Created by edz on 2020/12/4.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>

///  YRTagInfo 是用来描述 一个字符串中出现的 某个标签的信息的
/// eg: 标签在原始字符串中的位置 Range
///  标签的内容

@interface YRTagInfo : NSObject

// 原始字符串, eg:  @"1张三<a 232323target='_blank' href='http://baidu.com' sdgsdga > 点击百度一下 </a> 你大爷的1"
@property (nonatomic, strong) NSString *rawString;
// a
@property (nonatomic, strong) NSString *name;
// 标签在RawString 中的范围
@property (nonatomic, assign) NSRange  range;
// 标签, eg: <a 232323target='_blank' href='http://baidu.com' sdgsdga > 点击百度一下 </a>
@property (nonatomic, strong) NSString *tag;
// 标签之间的 内容, eg: ' 点击百度一下 `
@property (nonatomic, strong) NSString *rawContent;
// 显示的字符串 与 匹配的正则描述, eg:点击百度一下
@property (nonatomic, strong) NSString *contentRegPattern;
// eg: http://baidu.com
@property (nonatomic, strong) NSString *url;

+(instancetype)infoOfName:(NSString *)name;
@end
 
