//
//  GDataXMLDocument+HTMLSerialization.h
//  JSFiddleParseAndDownload
//
//  Created by softphone on 20/09/13.
//  Copyright (c) 2013 softphone. All rights reserved.
//

#import "GDataXMLNode.h"

@interface GDataXMLDocument (HTMLSerialization)

- (NSData *)HTMLData;
- (int)saveToFile:(NSString*)filename;

@end
