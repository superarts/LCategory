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


@implementation NSString (lc_expression)

- (NSString*)url_to_filename
{
	NSString*	s = self;

	s = [s stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
	s = [s stringByReplacingOccurrencesOfString:@":" withString:@"_"];
	s = [s stringByReplacingOccurrencesOfString:@"&" withString:@"_"];
	s = [s stringByReplacingOccurrencesOfString:@"?" withString:@"_"];
	s = [s stringByReplacingOccurrencesOfString:@"\\" withString:@"_"];

	return s;
}

- (NSString*)to_url
{
	return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)escape
{
	NSMutableString *escaped = [NSMutableString stringWithString:[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];   
	[escaped replaceOccurrencesOfString:@"$" withString:@"%24" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	[escaped replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, escaped.length)];
	return escaped;
}

- (BOOL)is_email
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 

	return [emailTest evaluateWithObject:self];
}

- (BOOL)is_english_name
{
	NSString *emailRegex = @"[A-Za-z '&-]+";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 

	return [emailTest evaluateWithObject:self];
}

@end
