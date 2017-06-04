//
//  DDPageDefine.h
//  Pods
//
//  Created by 周文松 on 2017/4/24.
//
//

#ifndef DDPageDefine_h
#define DDPageDefine_h

#define DDPageColorHex(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:((c)&0xFF)/255.0 alpha:1.0]

#define DDPageFont(size)        [UIFont systemFontOfSize:size]
#define DDPageWhiteColor(alpha) [[UIColor whiteColor] colorWithAlphaComponent:alpha]
#define DDPageLineColor         DDPageColorHex(0xdedfe0)              //!<默认线条颜色
#define DDPageScreenScale          (1 / [[UIScreen mainScreen] scale])                       //  划 0.5 宽度的线条使用


#endif /* DDPageDefine_h */
