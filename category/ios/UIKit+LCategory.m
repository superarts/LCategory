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


@implementation UIViewController (LCategory)
- (id)child_controller_named:(NSString*)class_name
{
	for (UIViewController* controller in self.childViewControllers)
		if ([controller isKindOfClass:NSClassFromString(class_name)])
			return controller;
	return nil;
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

- (void)set_keyboard_accessory:(UIView*)view_accessory item:(UIBarItem*)item responder:(UIResponder*)responder enable_mask:(BOOL)enable_mask
{
	[self associate:@"lf-keyboard-accessory-item" with:item];
	if (item) item.enabled = NO;
	[self set_keyboard_accessory:view_accessory responder:responder enable_mask:enable_mask];
}

- (void)set_keyboard_accessory:(UIView*)view_accessory button:(UIButton*)button responder:(UIResponder*)responder enable_mask:(BOOL)enable_mask;
{
	[self associate:@"lf-keyboard-accessory-button" with:button];
	if (button) button.enabled = NO;
	[self set_keyboard_accessory:view_accessory responder:responder enable_mask:enable_mask];
}

- (void)set_keyboard_accessory:(UIView*)view_accessory responder:(UIResponder*)responder enable_mask:(BOOL)enable_mask
{
	[self associate:@"lf-keyboard-accessory-view" with:view_accessory];
	[self associate:@"lf-keyboard-accessory-responder" with:responder];
	[[NSNotificationCenter defaultCenter] add_observer_unique:self
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
	UIResponder* responder	= [self associated:@"lf-keyboard-accessory-responder"];
	if (![responder isFirstResponder])
		return;
	//	log(@"keyboard: %@", notification.userInfo);
	UIButton* button_mask	= [self associated:@"lf-keyboard-accessory-mask"];
	UIView* view_accessory	= [self associated:@"lf-keyboard-accessory-view"];
	UIButton* button		= [self associated:@"lf-keyboard-accessory-button"];
	UIBarItem* item			= [self associated:@"lf-keyboard-accessory-item"];
	if (button) button.enabled = YES;
	if (item) item.enabled = YES;

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
	UIButton* button		= [self associated:@"lf-keyboard-accessory-button"];
	UIBarItem* item			= [self associated:@"lf-keyboard-accessory-item"];
	if (button) button.enabled = NO;
	if (item) item.enabled = NO;

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


@implementation UIView (lc_subview)

- (void)remove_all_subviews
{
	[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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


@implementation UITableView (lc_block)

lc_synthesize(NSMutableArray*,counts);
lc_synthesize(LFBlockCellPath,block_cell);
lc_synthesize(LFBlockVoidPath,block_select);
lc_synthesize(LFBlockFloatPath,block_height);

- (void)enable_block
{
	self.dataSource = self;
	self.delegate = self;
	//self.counts = [NSMutableArray new];
	//self.block_cell = nil;
}

- (void)reload_block
{
	[self enable_block];
	[self reloadData];
}

- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)path
{
	CGFloat height = -1;
	if (table == self)
		if (self.block_height)
			height = self.block_height(path);
	if (height < 0)
		height = table.rowHeight;
	return height;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
	if (table == self)
		if ([self.counts isKindOfClass:[NSArray class]])
			if (self.counts.count > section)
				if ([self.counts[section] isKindOfClass:[NSNumber class]])
					return [self.counts[section] intValue];
	return 0;
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath*)path
{
	UITableViewCell* cell = nil;//[tableView dequeueReusableCellWithIdentifier:@"HLCSCellNotification"];
	if (table == self)
		if (self.block_cell)
			cell = self.block_cell(path);
	return cell;
}

- (void)tableView:(UITableView*)table didSelectRowAtIndexPath:(NSIndexPath*)path
{
	if (table == self)
		if (self.block_select)
			self.block_select(path);
}

@end


@implementation UIScrollView (lc_content)
- (CGFloat)content_x
{
    return self.contentOffset.x;
}
- (CGFloat)content_y
{
    return self.contentOffset.y;
}
- (CGFloat)content_w
{
    return self.contentSize.width;
}
- (CGFloat)content_h
{
    return self.contentSize.height;
}
- (void)setContent_x:(CGFloat)x 
{
	CGPoint point = self.contentOffset;
	self.contentOffset = CGPointMake(x, point.y);
}
- (void)setContent_y:(CGFloat)y 
{
	CGPoint point = self.contentOffset;
	self.contentOffset = CGPointMake(point.x, y);
}
- (void)setContent_w:(CGFloat)w
{
	CGSize size = self.contentSize;
	self.contentSize = CGSizeMake(w, size.height);
}
- (void)setContent_h:(CGFloat)h
{
	CGSize size = self.contentSize;
	self.contentSize = CGSizeMake(size.width, h);
}
- (void)animate_content_x:(CGFloat)x 
{
	CGPoint point = self.contentOffset;
	[self setContentOffset:CGPointMake(x, point.y) animated:YES];
}
- (void)animate_content_y:(CGFloat)y 
{
	CGPoint point = self.contentOffset;
	[self setContentOffset:CGPointMake(point.x, y) animated:YES];
}
@end


@implementation UIView (lc_ib)
- (void)setMaskCircleEnabled:(BOOL)b
{
	if (b) [self enable_mask_circle];
}
- (BOOL)maskCircleEnabled
{
	NSLog(@"WARNING: no getter for maskCircleEnabled");
	return NO;
}
- (void)setShadow:(CGFloat)f
{
	UIBezierPath* path = [UIBezierPath bezierPathWithRect:self.bounds];
	self.layer.masksToBounds = NO;
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOffset = CGSizeMake(-3, 3);
	self.layer.shadowOpacity = f;
	self.layer.shadowPath = path.CGPath;
}
- (CGFloat)shadow
{
	NSLog(@"WARNING: no getter for shadow");
	return 0;
}
- (void)setRadius:(CGFloat)f
{
	[self enable_border_width:0 color:[UIColor clearColor] radius:f];
}
- (CGFloat)radius
{
	NSLog(@"WARNING: no getter for radius");
	return 0;
}
//	TODO: not working
- (void)setSolidCircleShadowEnabled:(BOOL)b
{
	if (b) 
	{
		UIView* shadow = [[UIView alloc] initWithFrame:self.frame];
		shadow.backgroundColor = [UIColor blackColor];
		[self.superview insertSubview:shadow belowSubview:self];
	}
}
- (BOOL)solidCircleShadowEnabled
{
	NSLog(@"WARNING: no getter for solidCircleShadowEnabled");
	return NO;
}
@end