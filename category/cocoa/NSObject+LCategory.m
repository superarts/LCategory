#import "NSObject+LCategory.h"

//	TODO: split into different files


@implementation NSObject (LCategory)

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


@implementation NSString (lc_defaults)

- (BOOL)default_bool
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:self];
}

- (NSInteger)default_integer
{
	return [[NSUserDefaults standardUserDefaults] integerForKey:self];
}

- (NSString*)default_string
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:self];
}

- (id)default_obj
{
	return [NSKeyedUnarchiver unarchiveObjectWithData:[self default_object]];
}

- (id)default_object
{
	return [[NSUserDefaults standardUserDefaults] objectForKey:self];
}

- (void)default_bool:(BOOL)b
{
	[[NSUserDefaults standardUserDefaults] setBool:b forKey:self];
	[self _default_synchronize];
}

- (void)default_integer:(NSInteger)i
{
	[[NSUserDefaults standardUserDefaults] setInteger:i forKey:self];
	[self _default_synchronize];
}

- (void)default_string:(NSString*)s
{
	[[NSUserDefaults standardUserDefaults] setObject:s forKey:self];
	[self _default_synchronize];
}

- (void)default_obj:(NSObject*)obj
{
	[self default_object:[NSKeyedArchiver archivedDataWithRootObject:obj]];
	[self _default_synchronize];
}

- (void)default_object:(id)obj
{
	[[NSUserDefaults standardUserDefaults] setObject:obj forKey:self];
	[self _default_synchronize];
}

- (void)_default_synchronize
{
	if ([[NSUserDefaults standardUserDefaults] synchronize] == NO)
		log(@"WARNING: LCategory - default synchronization failed");
}

@end
