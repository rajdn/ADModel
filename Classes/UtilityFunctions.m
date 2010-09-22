//
//  UtilityFunctions.m
//  PartyCamera
//
//  Created by Doug Russell on 6/18/10.
//  Copyright 2010 Doug Russell. All rights reserved.
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//  http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  

#import "UtilityFunctions.h"

const double	kRadPerDeg	= 0.0174532925199433;	// pi / 180

double	ToRadians(double degrees)
{
	return (degrees * kRadPerDeg);
}

NSString * AppDirectoryCachePath()
{
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
														  NSUserDomainMask, 
														  YES) lastObject];
	return path;
}
NSString * AppDirectoryCachePathAppended(NSString * pathToAppend)
{
	return [AppDirectoryCachePath() stringByAppendingPathComponent:pathToAppend];
}
NSString * TempFileName()
{
	return [NSString stringWithFormat:@"%f.bin", CFAbsoluteTimeGetCurrent()];
}
NSString * TempFolderName()
{
	return [NSString stringWithFormat:@"%f", CFAbsoluteTimeGetCurrent()];
}
NSString * AppDirectoryDocumentsPath()
{
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
														  NSUserDomainMask, 
														  YES) lastObject];
	return path;
}
NSString * AppDirectoryDocumentsPathAppended(NSString * pathToAppend)
{
	return [AppDirectoryDocumentsPath() stringByAppendingPathComponent:pathToAppend];
}
NSString * AppDirectoryLibraryPath()
{
	NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, 
														  NSUserDomainMask, 
														  YES) lastObject];
	return path;
}
NSString * AppDirectoryLibraryPathAppended(NSString * pathToAppend)
{
	return [AppDirectoryDocumentsPath() stringByAppendingPathComponent:pathToAppend];
}
NSString * EncodeHTMLEntities(NSString * source)
{
	NSMutableString	*	escaped	=	[NSMutableString stringWithString:source];
	NSArray			*	codes	=	
	[NSArray arrayWithObjects:
	 @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", 
	 @"&brvbar;", @"&sect;", @"&uml;", @"&copy;", @"&ordf;",@"&laquo;", 
	 @"&not;", @"&shy;", @"&reg;", @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", 
	 @"&sup3;", @"&acute;", @"&micro;", @"&para;", @"&middot;", @"&cedil;", 
	 @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;", @"&frac12;", @"&frac34;", 
	 @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;", @"&Atilde;", @"&Auml;", 
	 @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;", @"&Eacute;", @"&Ecirc;", 
	 @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;", @"&ETH;", 
	 @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;", 
	 @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", 
	 @"&Yacute;", @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", 
	 @"&atilde;", @"&auml;", @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", 
	 @"&eacute;", @"&ecirc;", @"&euml;", @"&igrave;", @"&iacute;", @"&icirc;", 
	 @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;", @"&oacute;", @"&ocirc;", 
	 @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;", @"&uacute;",
	 @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;", nil];
	int	count = [codes count];
	NSString	*	character	=	[NSString stringWithFormat: @"%C", 34];
	[escaped replaceOccurrencesOfString:character 
							 withString:@"&quot;" 
								options:NSLiteralSearch 
								  range:NSMakeRange(0, [escaped length])];
	character	=	[NSString stringWithFormat: @"%C", 38];
	[escaped replaceOccurrencesOfString:character 
							 withString:@"[[REPLACETHISATTHEEND]]" 
								options:NSLiteralSearch 
								  range:NSMakeRange(0, [escaped length])];
	character	=	[NSString stringWithFormat: @"%C", 39];
	[escaped replaceOccurrencesOfString:character 
							 withString:@"&apos;" 
								options:NSLiteralSearch 
								  range:NSMakeRange(0, [escaped length])];
	character	=	[NSString stringWithFormat: @"%C", 60];
	[escaped replaceOccurrencesOfString:character 
							 withString:@"&lt;" 
								options:NSLiteralSearch 
								  range:NSMakeRange(0, [escaped length])];
	character	=	[NSString stringWithFormat: @"%C", 62];
	[escaped replaceOccurrencesOfString:character 
							 withString:@"&gt;" 
								options:NSLiteralSearch 
								  range:NSMakeRange(0, [escaped length])];
	// Html
	for(int	i = 0; i < count; i++)
	{
		NSString	*	character	=	[NSString stringWithFormat: @"%C", 160 + i];
		NSRange			range		=	[source rangeOfString:character];
		if(range.location != NSNotFound)
		{
			[escaped replaceOccurrencesOfString:character 
									 withString:[codes objectAtIndex: i]
										options:NSLiteralSearch 
										  range:NSMakeRange(0, [escaped length])];
		}
	}
	[escaped replaceOccurrencesOfString:@"[[REPLACETHISATTHEEND]]" 
							 withString:@"&amp;" 
								options:NSLiteralSearch 
								  range:NSMakeRange(0, [escaped length])];
	return (NSString *)escaped;
}
NSString * DecodeHTMLEntities(NSString * source)
{
	NSMutableString	*	escaped	=	[NSMutableString stringWithString:source];
	NSArray			*	codes	=	
	[NSArray arrayWithObjects:
	 @"&nbsp;", @"&iexcl;", @"&cent;", @"&pound;", @"&curren;", @"&yen;", 
	 @"&brvbar;", @"&sect;", @"&uml;", @"&copy;", @"&ordf;",@"&laquo;", 
	 @"&not;", @"&shy;", @"&reg;", @"&macr;", @"&deg;", @"&plusmn;", @"&sup2;", 
	 @"&sup3;", @"&acute;", @"&micro;", @"&para;", @"&middot;", @"&cedil;", 
	 @"&sup1;", @"&ordm;", @"&raquo;", @"&frac14;", @"&frac12;", @"&frac34;", 
	 @"&iquest;", @"&Agrave;", @"&Aacute;", @"&Acirc;", @"&Atilde;", @"&Auml;", 
	 @"&Aring;", @"&AElig;", @"&Ccedil;", @"&Egrave;", @"&Eacute;", @"&Ecirc;", 
	 @"&Euml;", @"&Igrave;", @"&Iacute;", @"&Icirc;", @"&Iuml;", @"&ETH;", 
	 @"&Ntilde;", @"&Ograve;", @"&Oacute;", @"&Ocirc;", @"&Otilde;", @"&Ouml;", 
	 @"&times;", @"&Oslash;", @"&Ugrave;", @"&Uacute;", @"&Ucirc;", @"&Uuml;", 
	 @"&Yacute;", @"&THORN;", @"&szlig;", @"&agrave;", @"&aacute;", @"&acirc;", 
	 @"&atilde;", @"&auml;", @"&aring;", @"&aelig;", @"&ccedil;", @"&egrave;", 
	 @"&eacute;", @"&ecirc;", @"&euml;", @"&igrave;", @"&iacute;", @"&icirc;", 
	 @"&iuml;", @"&eth;", @"&ntilde;", @"&ograve;", @"&oacute;", @"&ocirc;", 
	 @"&otilde;", @"&ouml;", @"&divide;", @"&oslash;", @"&ugrave;", @"&uacute;",
	 @"&ucirc;", @"&uuml;", @"&yacute;", @"&thorn;", @"&yuml;", nil];
	int	count = [codes count];
	NSString	*	character	=	[NSString stringWithFormat: @"%C", 34];
	[escaped replaceOccurrencesOfString:@"&quot;" 
							 withString:character
								options:NSLiteralSearch 
								  range:NSMakeRange(0, [escaped length])];
	character	=	[NSString stringWithFormat: @"%C", 39];
	[escaped replaceOccurrencesOfString:@"&apos;"
							 withString:character
								options:NSLiteralSearch 
								  range:NSMakeRange(0, [escaped length])];
	character	=	[NSString stringWithFormat: @"%C", 60];
	[escaped replaceOccurrencesOfString:@"&lt;"
							 withString:character
								options:NSLiteralSearch 
								  range:NSMakeRange(0, [escaped length])];
	character	=	[NSString stringWithFormat: @"%C", 62];
	[escaped replaceOccurrencesOfString:@"&gt;"
							 withString:character
								options:NSLiteralSearch 
								  range:NSMakeRange(0, [escaped length])];
	// Html
	int	i;
	for(i = 0; i < count; i++)
	{
		NSRange			range		=	[source rangeOfString:[codes objectAtIndex: i]];
		if(range.location != NSNotFound)
		{
			NSString	*	character	=	[NSString stringWithFormat: @"%C", 160 + i];
			[escaped replaceOccurrencesOfString:[codes objectAtIndex: i]
									 withString:character
										options:NSLiteralSearch 
										  range:NSMakeRange(0, [escaped length])];
		}
	}
	character	=	[NSString stringWithFormat: @"%C", 38];
	[escaped replaceOccurrencesOfString:@"&amp;"
							 withString:character
								options:NSLiteralSearch 
								  range:NSMakeRange(0, [escaped length])];
	
//	// Decimal & Hex
//	NSRange	start, finish, searchRange	=	NSMakeRange(0, [escaped length]);
//	i = 0;
//	
//	while(i < [escaped length])
//	{
//		start = [escaped rangeOfString:@"&#" 
//							   options:NSCaseInsensitiveSearch 
//								 range:searchRange];
//		
//		finish = [escaped rangeOfString: @";" 
//								options: NSCaseInsensitiveSearch 
//								  range: searchRange];
//		
//		if(start.location != NSNotFound && finish.location != NSNotFound &&
//		   finish.location > start.location)
//		{
//			NSRange entityRange = NSMakeRange(start.location, (finish.location - start.location) + 1);
//			NSString *entity = [escaped substringWithRange: entityRange];     
//			NSString *value = [entity substringWithRange: NSMakeRange(2, [entity length] - 2)];
//			
//			[escaped deleteCharactersInRange: entityRange];
//			
//			if([value hasPrefix: @"x"])
//			{
//				int tempInt = 0;
//				NSScanner *scanner = [NSScanner scannerWithString: [value substringFromIndex: 1]];
//				[scanner scanHexInt: &tempInt];
//				[escaped insertString: [NSString stringWithFormat: @"%C", tempInt] atIndex: entityRange.location];
//			}
//			else
//			{
//				[escaped insertString: [NSString stringWithFormat: @"%C", [value intValue]] atIndex: entityRange.location];
//			}
//			i = start.location;
//		}
//		else i++;
//		searchRange = NSMakeRange(i, [escaped length] - i);
//	}
	
	return (NSString *)escaped;
}