#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "LCategory.h"

//	TODO: split into multiple files


@interface UIAlertView (LCategory)
+ (void)show_title:(NSString*)title;
+ (void)show_title:(NSString*)title message:(NSString*)message;
@end


@interface UIViewController (LCategory)
- (id)child_controller_named:(NSString*)class_name;
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


@interface UIView (lc_mask)

- (void)enable_mask_circle;
- (void)enable_mask_circle_width:(CGFloat)width color:(UIColor*)color;
- (void)enable_border_width:(CGFloat)width color:(UIColor*)color radius:(CGFloat)radius;

@end


@interface UIView (lc_keyboard_accessory)

//	TODO: currently auto layout needs to be turned of for view_accessory in IB in order to get it work.
- (void)set_keyboard_accessory:(UIView*)view_accessory responder:(UIResponder*)responder enable_mask:(BOOL)enable_mask;
- (void)set_keyboard_accessory:(UIView*)view_accessory button:(UIButton*)button responder:(UIResponder*)responder enable_mask:(BOOL)enable_mask;
- (void)set_keyboard_accessory:(UIView*)view_accessory item:(UIBarItem*)item responder:(UIResponder*)responder enable_mask:(BOOL)enable_mask;
- (void)lf_action_keyboard_accessory_dismiss;

@end


@interface UIView (lc_subview)

- (void)remove_all_subviews;

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
@property (nonatomic, copy) IBInspectable NSString* font_name;
@end
 
@interface UILabel (lc_custom_font)
@property (nonatomic, copy) IBInspectable NSString* font_name;
@end
 
@interface UITextView (lc_custom_font)
@property (nonatomic, copy) IBInspectable NSString* font_name;
@end
 
@interface UITextField (lc_custom_font)
@property (nonatomic, copy) IBInspectable NSString* font_name;
@end


@interface UIImageView (lc_content_image)

- (CGSize)content_scales;
- (CGRect)content_bounds;

@end


/*
   Use "lc_property/synthesize" to generate properties for categories:

	.h: lc_property(NSMutableArray*,counts);
	.m: lc_synthesize(NSMutableArray*,counts);
 */

#define lf_str(x)	#x
#define lf_cat(a,b)	a##b

#define lc_property(TYPE, NAME) \
    @property (setter=set_##NAME:, getter=get_##NAME) TYPE NAME; \

#define lc_synthesize(TYPE, NAME) \
    - (void)set_##NAME:(TYPE)NAME \
	{ \
		NSString* key = @lf_str(lf_cat(lc-table-,NAME)); \
		[self associate:key with:NAME]; \
	} \
    - (TYPE)get_##NAME \
	{ \
		NSString* key = @lf_str(lf_cat(lc-table-,NAME)); \
		return [self associated:key]; \
	} \

typedef void(^LFBlockVoidPath)					(NSIndexPath* path);
typedef CGFloat(^LFBlockFloatPath)				(NSIndexPath* path);
typedef UITableViewCell*(^LFBlockCellPath)		(NSIndexPath* path);
typedef UITableViewCell*(^LFBlockCellTablePath)	(UITableView* table, NSIndexPath* path);

@interface UITableView (lc_block) <UITableViewDelegate, UITableViewDataSource>

lc_property(NSMutableArray*,counts);
lc_property(LFBlockCellPath,block_cell);
lc_property(LFBlockVoidPath,block_select);
lc_property(LFBlockFloatPath,block_height);

- (void)enable_block;
- (void)reload_block;

@end


@interface UIScrollView (lc_content)
@property (nonatomic, assign) CGFloat content_x;
@property (nonatomic, assign) CGFloat content_y;
@property (nonatomic, assign) CGFloat content_w;
@property (nonatomic, assign) CGFloat content_h;
- (void)animate_content_x:(CGFloat)x;
- (void)animate_content_y:(CGFloat)y;
@end


@interface UIView (lc_ib)
@property (nonatomic) IBInspectable BOOL maskCircleEnabled;
@property (nonatomic) IBInspectable CGFloat shadow;
@property (nonatomic) IBInspectable CGFloat radius;
@property (nonatomic) IBInspectable BOOL solidCircleShadowEnabled;
@end