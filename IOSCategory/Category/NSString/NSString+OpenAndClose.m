//
//  NSString+OpenAndClose.m
//  IOSCategory
//
//  Created by Jeff on 2020/10/29.
//

#import "NSString+OpenAndClose.h"
#import <CoreText/CoreText.h>

#define kTailStr    @"…"
#define kOpenStr    @"展开"
#define kCloseStr   @"收起"

@implementation NSString (OpenAndClose)


//获取用来展示的富文本（拼接上 “展开” “收起”）
- (NSMutableAttributedString *)getAttributeStrWithLblWidth:(CGFloat)lblWidth font:(UIFont *)textFont lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode closeLineNum:(NSInteger)closeLineNum openState:(BOOL)isOpen
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setParagraphSpacing:paragraphSpacing];
    [paragraphStyle setLineBreakMode:lineBreakMode];
    [paragraphStyle setAlignment:NSTextAlignmentJustified]; //左右对齐方式
    
    NSArray *textArr = [self getStringOfAllLinesWithLblWidth:lblWidth font:textFont lineSpacing:lineSpacing paragraphSpacing:paragraphSpacing lineBreakMode:lineBreakMode];
    
    NSMutableAttributedString *attributeStr = nil;
    if (textArr.count <= closeLineNum) {  //小于或者等于指定收起时的行数,原文本显示
        
        NSString *str = [textArr componentsJoinedByString:@""];
        attributeStr = [[NSMutableAttributedString alloc]initWithString:str];
        
        [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributeStr.length)];
        [attributeStr addAttribute:NSFontAttributeName value:textFont range:NSMakeRange(0, attributeStr.length)];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attributeStr.length)];
    }
    else{
        if (isOpen) {
            NSString *str = [textArr componentsJoinedByString:@""];
            attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@",str,kCloseStr]];
            
            [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributeStr.length)];
            [attributeStr addAttribute:NSFontAttributeName value:textFont range:NSMakeRange(0, attributeStr.length)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, str.length)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(str.length, kCloseStr.length + 1)];
        }
        else{
            NSMutableString *strM = [[NSMutableString alloc]init];
            
            for (int i = 0; i < closeLineNum; i ++) {
                if (i == closeLineNum - 1) {  //最后一行删除最后的几个字符，拼接上 @"..." 和 @"展开"
                    NSString *str = textArr[i];
                    
                    for (int j = (int)str.length; j >= 0; j --) {
                        NSString *subStr = [str substringToIndex:j];
                        NSMutableString *lastLineStrM = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@",subStr,kTailStr,kOpenStr]];
                        CGFloat lastLineStrWidth = [lastLineStrM sizeWithAttributes:@{NSFontAttributeName:textFont}].width;
                        if (lastLineStrWidth <= lblWidth) {
                            
                            //NSLineBreakByWordWrapping模式下需要补全空格撑满一行,尽量让拼接的“展开”显示在行末
                            while (lastLineStrWidth <= lblWidth) {
                                [lastLineStrM insertString:@" " atIndex:lastLineStrM.length - kOpenStr.length];
                                lastLineStrWidth = [lastLineStrM sizeWithAttributes:@{NSFontAttributeName:textFont}].width;
                            }
                            [lastLineStrM deleteCharactersInRange:NSMakeRange(lastLineStrM.length - kOpenStr.length - 1, 1)];
                            
                            [strM appendString:lastLineStrM];
                            break;
                        }
                    }
                }
                else{
                    [strM appendString:textArr[i]];
                }
            }
            
            attributeStr = [[NSMutableAttributedString alloc]initWithString:strM];
            
            [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributeStr.length)];
            [attributeStr addAttribute:NSFontAttributeName value:textFont range:NSMakeRange(0, attributeStr.length)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attributeStr.length - kOpenStr.length)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(attributeStr.length - kOpenStr.length, kOpenStr.length)];
        }
    }
    return attributeStr;
}
 
//获取所有行文字数组
- (NSArray *)getStringOfAllLinesWithLblWidth:(CGFloat)lblWidth font:(UIFont *)textFont lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    //设定行间距，段间距，对齐方式等
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setParagraphSpacing:paragraphSpacing];
    [paragraphStyle setLineBreakMode:lineBreakMode];
    [paragraphStyle setAlignment:NSTextAlignmentJustified]; //左右对齐方式
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:self];
    [attributeStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeStr addAttribute:NSFontAttributeName value:textFont range:NSMakeRange(0, self.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributeStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, lblWidth, CGFLOAT_MAX));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines) {
        CTLineRef lineRef = (__bridge CTLineRef)line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [self substringWithRange:range];
        [linesArray addObject:lineString];
    }
    
    return (NSArray *)linesArray;
}
@end
