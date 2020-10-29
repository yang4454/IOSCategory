//
//  NSString+OpenAndClose.h
//  IOSCategory
//
//  Created by Jeff on 2020/10/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (OpenAndClose)
//获取每行文字的数组
- (NSArray *)getStringOfAllLinesWithLblWidth:(CGFloat)lblWidth font:(UIFont *)textFont lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode;
 
 
//获取用来展示的富文本（拼接上 “展开” “收起”）
/**
 *
 * lblWidth:文本宽度
 * font: 文本字体大小
 * lineSpacing:行间距
 * paragraphSpacing:段间距
 * lineBreakMode:文本分行模式
 * closeLineNum:收起时文本的行数
 * openState:展开收起状态
 * hasDefaultTail:是否在尾部拼接上展开收起
 *
 */
- (NSMutableAttributedString *)getAttributeStrWithLblWidth:(CGFloat)lblWidth font:(UIFont *)textFont lineSpacing:(CGFloat)lineSpacing paragraphSpacing:(CGFloat)paragraphSpacing lineBreakMode:(NSLineBreakMode)lineBreakMode closeLineNum:(NSInteger)closeLineNum  openState:(BOOL)isOpen;
 

@end

NS_ASSUME_NONNULL_END
