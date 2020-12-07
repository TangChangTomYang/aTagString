//
//  ViewController.m
//  fasfdas
//
//  Created by edz on 2020/12/3.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "ViewController.h"
 #import "YRAttributedString.h"
#import "YRTagInfo.h"




@interface ViewController ()
@property (nonatomic, strong) UILabel *lb;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 300)];
    lb.backgroundColor = [UIColor systemPinkColor];
    [self.view addSubview:lb];
    lb.numberOfLines = 0;
    self.lb = lb;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self test];
    [self testATag];
}

-(void)testATag{
    NSError *err = nil;
    NSRegularExpression *regExp =[NSRegularExpression regularExpressionWithPattern:@"<a[^>]*href=[\"'](?<url>[^\"']*?)[\"'][^>]*>(?<text>[\\w\\W]*?)</a>" options:NSRegularExpressionCaseInsensitive error:&err];
    NSString *str = @"1张三<a 232323target='_blank' href='http://baidu.com' sdgsdga > 点击百度一下 </a> 你大爷的1";
    str = @"1张三<a 232323target='_blank' href='http://www.baidu.com' sdgsdga > 点击百度一下 </a> 你大爷的1";
    str = @"1张三<a 232323targehref='http://www.baidu.com' sdgsdga >  点击百度一下 </a> 你大爷的1";
    str = @"1张三<a 232323targehref='http://www.baidu.com' sdgsdga >   点击 百度一下 </a> 你大爷的1--1张三<a 232323targehref='http://www.BBaidu.com' sdgsdga > 点击百度一下 </a> 你大爷的1";
    str = @"1张三<a 232323targehref='http://' sdgsdga >   点击 百度一下 </a> 你大爷的1--1张三<a 232323targehref='http://www.BBaidu.com' sdgsdga > 点击百度一下 </a> 你大爷的1";
//    str = @",1张三<a target='_blank' href='http://baidu.com'> 点击百度一下 </a> 你大爷的1张三<a target='_blank' href='https://baidu.com'> >>>>>>点击百度一下 </a> 你大爷的";
    NSArray *results = [regExp matchesInString:str options:NSMatchingWithTransparentBounds range:NSMakeRange(0, [str length])];
    
    self.lb.text = str;
    

    NSMutableArray<YRTagInfo *> *aTagInfoArrM = [NSMutableArray array];
    
    for (int i = results.count-1; i >=0; i--) {
        
        YRTagInfo *tagInfo = [YRTagInfo infoOfName:@"<a>"];
        tagInfo.rawString = str;
         
        NSTextCheckingResult *result = results[i];
        NSRange range = result.range;
        tagInfo.range = range;
        
        NSString *aTagStr = [str substringWithRange:range];
        tagInfo.tag = aTagStr;
        NSLog(@"a tag : %@",aTagStr);
        
        // 1. <a 232323target='_blank' href='http://baidu.com' sdgsdga >
        NSRegularExpression *aTagLeftRegExp = [self regExpOf:@"<a[^>]*href=[\"'](?<url>[^\"']*?)[\"'][^>]*>"];
        NSTextCheckingResult *aTagLeftResult = [aTagLeftRegExp matchesInString:aTagStr
                                                                       options:NSMatchingWithTransparentBounds
                                                                         range:NSMakeRange(0, [aTagStr length])].firstObject;
        if (!aTagLeftResult) {
            continue;
        }
        NSString *aTagLeftStr = [aTagStr substringWithRange:aTagLeftResult.range];
        NSLog(@"aTagLeftStr: %@",aTagLeftStr );
        
        // 2. href='http://baidu.com'
        NSRegularExpression *hrefExp = [self regExpOf:@"http[s]{0,1}://([\\w.]+/?)\\S*"];
         NSTextCheckingResult *hrefResult = [hrefExp matchesInString:aTagLeftStr
                                                             options:NSMatchingWithTransparentBounds
                                                               range:NSMakeRange(0, [aTagLeftStr length])].firstObject;
        if (!hrefResult) {
            continue;
        }
        NSString *hrefStr = [aTagLeftStr substringWithRange:hrefResult.range];
        NSLog(@"hrefStr: %@",hrefStr );
        tagInfo.url = hrefStr;
        
        
        
        // 3. 点击百度一下 </a>
        NSString *aTagCenterAndRightStr = [aTagStr substringFromIndex:aTagLeftStr.length];
        NSLog(@"aTagCenterAndRightStr: %@", aTagCenterAndRightStr);
         
        
        // 4.</a>
        NSRegularExpression *aTagRightRegExp = [self regExpOf:@"</a>"];
        NSTextCheckingResult *aTagRightResults = [aTagRightRegExp matchesInString:aTagCenterAndRightStr
                                                                          options:NSMatchingWithTransparentBounds
                                                                            range:NSMakeRange(0, [aTagCenterAndRightStr length])].lastObject;
        if (!aTagRightResults) {
            continue;
        }
          
        NSString *aTagRightStr = [aTagCenterAndRightStr substringWithRange:aTagRightResults.range];
        NSLog(@"aTagRightStr: %@",aTagRightStr );
        
        // 5.  点击百度一下
        NSString *aTagContentStr = [aTagCenterAndRightStr substringToIndex: aTagCenterAndRightStr.length - aTagRightStr.length];
        NSLog(@"aTagContentStr: %@", aTagContentStr);
        tagInfo.rawContent = aTagContentStr;
        
        NSString *contentRegPattern = [aTagContentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (contentRegPattern.length == 0 ) {
            continue;
        }
        
        /// 保证contentRegPattern 唯一性
        contentRegPattern = [NSString stringWithFormat:@"@%@@",contentRegPattern];
        NSString *newContentRegPattern= contentRegPattern;
        for (int a = 0; a < aTagInfoArrM.count; a++) {
            YRTagInfo *info = aTagInfoArrM[a];
            if ([contentRegPattern isEqualToString:info.contentRegPattern]) {
                newContentRegPattern = [NSString stringWithFormat:@"@%@@",newContentRegPattern];
            }
        }
        tagInfo.contentRegPattern = newContentRegPattern;
         
        [aTagInfoArrM addObject:tagInfo];
        
    }
     for (int a = 0; a < aTagInfoArrM.count; a++) {
         YRTagInfo *info = aTagInfoArrM[a];
         str = [str stringByReplacingCharactersInRange:info.range withString:info.contentRegPattern];
     }
    NSLog(@"");
}


-(NSRegularExpression *)regExpOf:(NSString *)pattern{
   return   [NSRegularExpression regularExpressionWithPattern:pattern
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:nil];
}


-(void)test{
    
    NSURL *fileUrl = [NSURL fileURLWithPath:@"/Users/edz/Desktop/baogong 2.m"];
    NSError *err = nil;
    NSFileWrapper *fileWrap = [[NSFileWrapper alloc] initWithURL:fileUrl options:NSFileWrapperReadingImmediate error:&err];
    if(err == nil){
        NSData *data = fileWrap.regularFileContents; 
        NSTextAttachment *attchment = [[NSTextAttachment alloc] initWithData:data ofType:nil];
        NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:attchment];
        self.lb.attributedText = att;
    }
    
}


@end
