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

- (int)default_int
{
	return (int)[self default_integer];
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

- (void)default_int:(int)i
{
	[self default_integer:i];
}

- (int)default_int_inc
{
	return [self default_int_inc:1];
}

- (int)default_int_dec
{
	return [self default_int_dec:1];
}

- (int)default_int_inc:(int)integer
{
	int i = [self default_int];
	[self default_int:i + integer];
	return i;
}

- (int)default_int_dec:(int)integer
{
	int i = [self default_int];
	[self default_int:i - integer];
	return i;
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


@implementation NSString (lc_string)

- (BOOL)is:(NSString*)s
{
	return [self isEqualToString:s];
}

- (BOOL)contains:(NSString*)sub
{
	if (sub == nil)
		return NO;
	if (sub.length == 0)
		return YES;

	NSRange range = [self rangeOfString:sub];
	if ((range.location == NSNotFound) && (range.length == 0))
		return NO;

	return YES;
}

- (NSString*)string_without_leading_space
{
	int i;
	for (i = 0; i < self.length; i++)
		if ([self characterAtIndex:i] != ' ')
			break;
	return [self substringFromIndex:i];
}

- (NSString*)string_replace:(NSString*)substring with:(NSString*)replacement
{
	NSRange		range;
	NSString*	s = self;

	range = [s rangeOfString:substring];
	while (range.location != NSNotFound) 
	{
		s = [s stringByReplacingOccurrencesOfString:substring withString:replacement];
		range = [s rangeOfString:substring];
		//	NSLog(@"string without: %@", s);
	}

	return s;
}

- (NSString*)string_without:(NSString*)head to:(NSString*)tail
{
	return [self string_without:head to:tail except:[NSArray arrayWithObjects:nil]];
}

- (NSString*)string_without:(NSString*)head to:(NSString*)tail except:(NSArray*)exceptions
{
	int			i;
	BOOL		finding_head = YES;
	NSRange		range_source, range_dest;
	NSString*	s = [NSString stringWithString:self];
	NSString*	sub = @"";

	while (sub != nil)
	{
		sub = nil; 
		for (i = 0; i < s.length; i++)
		{
			range_source.location = i;
			if (finding_head)
			{
				range_source.length = head.length;
				if (range_source.length + i > s.length)
					break;
				if ([[s substringWithRange:range_source] isEqualToString:head])
				{
					//	NSLog(@"found head at: %i", i);
					range_dest.location = i;
					finding_head = NO;
				}
			}
			else
			{
				range_source.length = tail.length;
				if (range_source.length + i > s.length)
					break;
				if ([[s substringWithRange:range_source] isEqualToString:tail])
				{
					//	NSLog(@"found tail at: %i", i);
					range_dest.length = i - range_dest.location + tail.length;
					sub = [s substringWithRange:range_dest];
					finding_head = YES;
					if ([exceptions containsObject:sub] == NO)
						break;
					//	else
					//	NSLog(@"skipping %@", sub);
				}
			}
		}
		if (sub != nil)
		{
			if ([exceptions containsObject:sub])
				break;
			//	NSLog(@"found sub: %@", sub);
			s = [s stringByReplacingOccurrencesOfString:sub withString:@""];
		}
	}

	return s;
}

- (NSString*)string_between:(NSString*)head and:(NSString*)tail
{
	return [self string_between:head and:tail from:0];
}

- (NSArray*)array_between:(NSString*)head and:(NSString*)tail
{
	NSMutableArray* array = [NSMutableArray array];
	NSRange range_search;
	int index = 0;
	NSString* s = [self string_between:head and:tail from:0];
	while (s != nil)
	{
		[array addObject:s];
		range_search.location = index;
		range_search.length = self.length - range_search.location;
		NSRange range = [self rangeOfString:s options:kNilOptions range:range_search];
		index = (int)(range.location + range.length);
		s = [self string_between:head and:tail from:index];
		//NSLog(@"searching %i: %@/%@, %@, %@", index, head, tail, s, self);
	}
	return array;
}

- (BOOL)is_hashtag
{
	NSArray* array = [self array_hashtag];
	//	NSLog(@"%@ is hashtag: %@", self, array);
	if (array.count == 1)
		if ([self is:[NSString stringWithFormat:@"#%@", array[0]]])
			return YES;
	return NO;
}

- (NSArray*)array_hashtag
{
	NSError *error = nil;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"#(\\w+)" options:0 error:&error];
	NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
	NSMutableArray* array = [NSMutableArray array];
	for (NSTextCheckingResult *match in matches) 
	{
		NSRange wordRange = [match rangeAtIndex:1];
		NSString* word = [self substringWithRange:wordRange];
		[array addObject:word];
		//	NSLog(@"Found tag %@", word);
	}
	return array;
}

- (NSString*)string_between:(NSString*)head and:(NSString*)tail from:(int)index
{
	NSRange range;
	NSRange range_search;

	if (index > self.length)
		return nil;

	range_search.location = index;
	range_search.length = self.length - range_search.location;
	NSRange range_head = [self rangeOfString:head options:kNilOptions range:range_search];
	//	NSLog(@"range: %i/%i", range_head.location, range_head.length);
	if (range_head.location == NSNotFound)
		return nil;

	range_search.location = range_head.location + range_head.length;
	range_search.length = self.length - range_search.location;
	NSRange range_tail = [self rangeOfString:tail options:kNilOptions range:range_search];
	//	NSLog(@"range: %i/%i", range_tail.location, range_tail.length);
	if (range_tail.location == NSNotFound)
		return nil;

	range.location = range_head.location + range_head.length;
	range.length = range_tail.location - range.location;
	//	NSLog(@"range: %i/%i", range.location, range.length);

	return [self substringWithRange:range];
}

+ (NSString*)string_from_int:(int)i
{
	return [NSString stringWithFormat:@"%i", i];
}

//	TODO: this method is not good enough for plural form handling
#if 0
- (NSString*)s_int:(int)i
{
	if (i <= 1)
		return [NSString stringWithFormat:@"%i %@", i, self];
	else
		return [NSString stringWithFormat:@"%i %@s", i, self];
}

- (NSString*)s_int_with_no:(int)i
{
	if (i == 0)
		return [NSString stringWithFormat:@"no %@", self];
	else if (i <= 1)
		return [NSString stringWithFormat:@"%i %@", i, self];
	else
		return [NSString stringWithFormat:@"%i %@s", i, self];
}

- (NSString*)s_int_with_No:(int)i
{
	if (i == 0)
		return [NSString stringWithFormat:@"No %@", self];
	else if (i <= 1)
		return [NSString stringWithFormat:@"%i %@", i, self];
	else
		return [NSString stringWithFormat:@"%i %@s", i, self];
}
#endif

- (NSString*)append_line:(NSString*)str
{
	return [self append:str divider:@"\n"];
}

- (NSString*)append_line2:(NSString*)str
{
	return [self append:str divider:@"\n\n"];
}

- (NSString*)append:(NSString*)str divider:(NSString*)divider
{
	//	NSLog(@"appending: '%@'", str);
	if (str != nil)
		if ([str isKindOfClass:[NSString class]])
			if (str.length > 0)
			{
				if (self.length > 0)
					return [NSString stringWithFormat:@"%@%@%@", self, divider, str];
				else
					return str;
			}
	//	NSLog(@"return self: '%@'", self);
	return self;
}

@end


@implementation NSNotificationCenter (lc_unique_notification)

- (void)add_observer_unique:(id)observer selector:(SEL)selector name:(NSString *)name object:(id)object 
{
	[[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
	[[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
}

@end
