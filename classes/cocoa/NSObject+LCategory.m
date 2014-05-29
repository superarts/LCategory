#import "NSObject+LCategory.h"

@implementation NSObject (LYObject)

- (id)release_nil
{
	//[self release];
	return nil;
}

#pragma mark selector

- (id)perform_string:(NSString*)string
{
	return [self perform_selector:NSSelectorFromString(string)];
}

- (id)perform_string:(NSString*)string with:(id)obj
{
	return [self perform_selector:NSSelectorFromString(string) with:obj];
}

- (id)perform_string:(NSString*)string with:(id)obj1 with:(id)obj2
{
	return [self perform_selector:NSSelectorFromString(string) with:obj1 with:obj2];
}

- (id)perform_selector:(SEL)selector
{
	if ([self respondsToSelector:selector] == NO)
		return nil;

	return [self performSelector:selector];
}

- (id)perform_selector:(SEL)selector with:(id)obj
{
	if ([self respondsToSelector:selector] == NO)
		return nil;

	return [self performSelector:selector withObject:obj];
}

- (id)perform_selector:(SEL)selector with:(id)obj1 with:(id)obj2
{
	if (self == nil)
		return nil;
	if ([self respondsToSelector:selector] == NO)
		return nil;

	return [self performSelector:selector withObject:obj1 withObject:obj2];
}

#pragma mark associate

- (void)associate:(NSString*)key with:(id)obj
{
	objc_setAssociatedObject(self, key, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)associated:(NSString*)key
{
	return objc_getAssociatedObject(self, key);
}

@end
