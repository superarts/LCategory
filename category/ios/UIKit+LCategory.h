#import <UIKit/UIKit.h>
#import "LCategory.h"

//	TODO: split into multiple files


@interface UIAlertView (LCategory)
+ (void)show_title:(NSString*)title;
+ (void)show_title:(NSString*)title message:(NSString*)message;
@end


@interface UIView (lc_frame)

@property (nonatomic, assign) CGFloat h;
@property (nonatomic, assign) CGFloat w;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat animation_duration;

- (void)animate_x:(CGFloat)x;
- (void)animate_y:(CGFloat)x;
- (void)animate_w:(CGFloat)x;
- (void)animate_h:(CGFloat)x;

@end


@interface UIScrollView (lc_page_control)

//	if you want to enable delegate for your scroll view, set scroll.delegate then call [scroll page_reload] in scrollViewDidScroll: of your own delegate
- (void)page_associate:(UIPageControl*)pagecontrol;
- (void)page_reload;

@end

 
@interface UIScreen (LCategory)

+ (CGFloat)main_width;
+ (CGFloat)main_height;

@end


@interface UIButton (lc_custom_font)
@property (nonatomic, copy) NSString* font_name;
@end
 
@interface UILabel (lc_custom_font)
@property (nonatomic, copy) NSString* font_name;
@end
 
@interface UITextField (lc_custom_font)
@property (nonatomic, copy) NSString* font_name;
@end
