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


@implementation UIView (LCategory)

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
