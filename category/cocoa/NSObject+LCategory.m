#import "NSObject+LCategory.h"

@implementation NSObject (LYObject)

#pragma mark selector

- (void)perform_string:(NSString*)string
{
	return [self perform_selector:NSSelectorFromString(string)];
}

- (void)perform_string:(NSString*)string with:(id)obj
{
	return [self perform_selector:NSSelectorFromString(string) with:obj];
}

- (void)perform_string:(NSString*)string with:(id)obj1 with:(id)obj2
{
	return [self perform_selector:NSSelectorFromString(string) with:obj1 with:obj2];
}

- (void)perform_selector:(SEL)selector
{
	if ([self respondsToSelector:selector] == NO)
		return;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	[self performSelector:selector];
#pragma clang diagnostic push
}

- (void)perform_selector:(SEL)selector with:(id)obj
{
	if ([self respondsToSelector:selector] == NO)
		return;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	[self performSelector:selector withObject:obj];
#pragma clang diagnostic push
}

- (void)perform_selector:(SEL)selector with:(id)obj1 with:(id)obj2
{
	if (self == nil)
		return;
	if ([self respondsToSelector:selector] == NO)
		return;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	[self performSelector:selector withObject:obj1 withObject:obj2];
#pragma clang diagnostic push
}

#pragma mark associate

- (void)associate:(NSString*)key with:(id)obj
{
	objc_setAssociatedObject(self, key.UTF8String, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associated:(NSString*)key
{
	return objc_getAssociatedObject(self, key.UTF8String);
}

@end
