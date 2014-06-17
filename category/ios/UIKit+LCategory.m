#import "UIKit+LCategory.h"

//	TODO: split into multiple files


@implementation UIAlertView (LCategory)
+ (void)show_title:(NSString*)title
{
	[UIAlertView show_title:title message:nil];
}
+ (void)show_title:(NSString*)title message:(NSString*)message
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
		delegate:nil cancelButtonTitle:_s_uikit(@"OK") otherButtonTitles:nil];
	[alert show];
}
@end


@implementation UIView (lc_frame)

- (CGFloat)h
{
    return self.frame.size.height;
}

- (CGFloat)w
{
    return self.frame.size.width;
}

- (CGFloat)x 
{
    return self.frame.origin.x;
}

- (CGFloat)y 
{
    return self.frame.origin.y;
}

- (CGFloat)center_y 
{
    return self.center.y;
}

- (CGFloat)center_x 
{
    return self.center.x;
}

- (void)setH:(CGFloat)newHeight 
{
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}

- (void)setW:(CGFloat)newWidth 
{
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}

- (void)setX:(CGFloat)newX 
{
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}

- (void)setY:(CGFloat)newY 
{
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}

- (CGFloat)animation_duration
{
	NSNumber* number = [self associated:@"lf-animation-duration-uiview"];
	if (number)
		return [number floatValue];
	else
		return k_lf_animation_duration_short;
}

- (void)setAnimation_duration:(CGFloat)duration
{
	[self associate:@"lf-animation-duration-uiview" with:[NSNumber numberWithFloat:duration]];
}

- (void)animate_x:(CGFloat)x
{
	[UIView animateWithDuration:self.animation_duration animations:^() {
		self.x = x;
	}];
}

- (void)animate_y:(CGFloat)y
{
	[UIView animateWithDuration:self.animation_duration animations:^() {
		self.y = y;
	}];
}

- (void)animate_w:(CGFloat)w
{
	[UIView animateWithDuration:self.animation_duration animations:^() {
		self.w = w;
	}];
}

- (void)animate_h:(CGFloat)h
{
	[UIView animateWithDuration:self.animation_duration animations:^() {
		self.h = h;
	}];
}

@end


@implementation UIView (lc_mask)

- (void)enable_mask_circle
{
	CGFloat f = self.w < self.h ? self.w : self.h;
	self.layer.cornerRadius = f / 2;
	self.layer.masksToBounds = YES;
}

- (void)enable_mask_circle_width:(CGFloat)width color:(UIColor*)color
{
	CGFloat f = self.w < self.h ? self.w : self.h;
	[self enable_border_width:width color:color radius:f / 2];
}

- (void)enable_border_width:(CGFloat)width color:(UIColor*)color radius:(CGFloat)radius
{
	self.layer.borderWidth = width;
	self.layer.borderColor = [color CGColor];
	self.layer.cornerRadius = radius;
	self.layer.masksToBounds = YES;
}

@end


@implementation UIView (lc_keyboard_accessory)

- (void)set_keyboard_accessory:(UIView*)view_accessory responder:(UIResponder*)responder enable_mask:(BOOL)enable_mask;
{
	[self associate:@"lf-keyboard-accessory-view" with:view_accessory];
	[self associate:@"lf-keyboard-accessory-responder" with:responder];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(_lf_keyboard_will_show:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	//[self removeConstraints:view_accessory.constraints];
	if (enable_mask)
	{
		UIButton* button_mask = [[UIButton alloc] initWithFrame:UIScreen.mainScreen.bounds];
		[button_mask addTarget:self action:@selector(lf_action_keyboard_accessory_dismiss) forControlEvents:UIControlEventTouchUpInside];
		[self associate:@"lf-keyboard-accessory-mask" with:button_mask];
	}
}

- (void)_lf_keyboard_will_show:(NSNotification*)notification
{
	//	log(@"keyboard: %@", notification.userInfo);
	UIButton* button_mask	= [self associated:@"lf-keyboard-accessory-mask"];
	UIView* view_accessory	= [self associated:@"lf-keyboard-accessory-view"];
	UIViewAnimationCurve	curve;
	CGSize size = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	[[notification.userInfo valueForKey:UIKeyboardAnimationCurveUserInfoKey]
							   getValue:&curve];
	[self associate:@"lf-keyboard-accessory-curve" with:@(curve)];

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:curve];
	view_accessory.y = UIScreen.main_height - size.height - view_accessory.h;
	[UIView commitAnimations];
	
	[self addSubview:button_mask];
	[self bringSubviewToFront:view_accessory];
}

- (void)lf_action_keyboard_accessory_dismiss
{
	UIView* view_accessory	= [self associated:@"lf-keyboard-accessory-view"];
	UIButton* button_mask	= [self associated:@"lf-keyboard-accessory-mask"];
	UIResponder* responder	= [self associated:@"lf-keyboard-accessory-responder"];
	UIViewAnimationCurve curve = [[self associated:@"lf-keyboard-accessory-curve"] intValue];
	[button_mask removeFromSuperview];
	[responder resignFirstResponder];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:curve];
	view_accessory.y = UIScreen.main_height - view_accessory.h;
	[UIView commitAnimations];
}

@end


@implementation UIScrollView (lc_page_control)

- (void)page_reload
{
	UIPageControl* page = [self associated:@"lf-page-control"];
	if (page != nil)
	{
		page.numberOfPages = self.contentSize.width / self.frame.size.width;
		page.currentPage = self.contentOffset.x / self.frame.size.width;
		page.hidesForSinglePage = NO;
		[page addTarget:self action:@selector(page_changed:) forControlEvents:UIControlEventValueChanged];
#if 0
		NSLog(@"width %f", self.contentInset.right);
		NSLog(@"size %f", self.frame.size.width);
		NSLog(@"count %i", page.numberOfPages);
		NSLog(@"index %i", page.currentPage);
#endif
	}
}

- (void)page_associate:(UIPageControl*)pagecontrol
{
	[self associate:@"lf-page-control" with:pagecontrol];
	[self page_reload];
	self.delegate = (id<UIScrollViewDelegate>)self;
}

- (void)page_changed:(UIPageControl*)page
{
	[UIView animateWithDuration:self.animation_duration animations:^() {
		self.contentOffset = CGPointMake(self.frame.size.width * page.currentPage, 0);
	}];
}

- (void)scrollViewDidScroll:(UIScrollView*)scroll
{
	[self page_reload];
}

@end


@implementation UIScreen (LCategory)

+ (CGFloat)main_width
{
	return UIScreen.mainScreen.bounds.size.width;
}

+ (CGFloat)main_height
{
	return UIScreen.mainScreen.bounds.size.height;
}

@end


@implementation UIButton (lc_custom_font)
 
- (NSString *)font_name {
    return self.titleLabel.font.fontName;
}
 
- (void)setFont_name:(NSString *)font_name {
    self.titleLabel.font = [UIFont fontWithName:font_name size:self.titleLabel.font.pointSize];
}
 
@end


@implementation UILabel (lc_custom_font)
 
- (NSString *)font_name {
    return self.font.fontName;
}
 
- (void)setFont_name:(NSString *)font_name {
    self.font = [UIFont fontWithName:font_name size:self.font.pointSize];
}
 
@end
 
 
@implementation UITextView (lc_custom_font)
 
- (NSString *)font_name {
    return self.font.fontName;
}
 
- (void)setFont_name:(NSString *)font_name {
    self.font = [UIFont fontWithName:font_name size:self.font.pointSize];
}
 
@end
 
 
@implementation UITextField (lc_custom_font)
 
- (NSString *)font_name {
    return self.font.fontName;
}
 
- (void)setFont_name:(NSString *)font_name {
    self.font = [UIFont fontWithName:font_name size:self.font.pointSize];
}
 
@end


@implementation UIImageView (lc_content_image)

- (CGSize)content_scales
{
    CGFloat sx = self.frame.size.width / self.image.size.width;
    CGFloat sy = self.frame.size.height / self.image.size.height;
    CGFloat s = 1.0;
    switch (self.contentMode) {
        case UIViewContentModeScaleAspectFit:
            s = fminf(sx, sy);
            return CGSizeMake(s, s);
            break;

        case UIViewContentModeScaleAspectFill:
            s = fmaxf(sx, sy);
            return CGSizeMake(s, s);
            break;

        case UIViewContentModeScaleToFill:
            return CGSizeMake(sx, sy);

        default:
            return CGSizeMake(s, s);
    }
}

- (CGRect)content_bounds 
{
    UIImage *image = [self image];
    if(self.contentMode != UIViewContentModeScaleAspectFit || !image)
        return CGRectInfinite;

    CGFloat boundsWidth  = [self bounds].size.width,
            boundsHeight = [self bounds].size.height;

    CGSize  imageSize  = [image size];
    CGFloat imageRatio = imageSize.width / imageSize.height;
    CGFloat viewRatio  = boundsWidth / boundsHeight;

    if(imageRatio < viewRatio) {
        CGFloat scale = boundsHeight / imageSize.height;
        CGFloat width = scale * imageSize.width;
        CGFloat topLeftX = (boundsWidth - width) * 0.5;
        return CGRectMake(topLeftX, 0, width, boundsHeight);
    }

    CGFloat scale = boundsWidth / imageSize.width;
    CGFloat height = scale * imageSize.height;
    CGFloat topLeftY = (boundsHeight - height) * 0.5;

    return CGRectMake(0, topLeftY, boundsWidth, height);
}

@end
