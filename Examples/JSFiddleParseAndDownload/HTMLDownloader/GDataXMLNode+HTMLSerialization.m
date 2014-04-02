//
//  GDataXMLDocument+HTMLSerialization.m
//  JSFiddleParseAndDownload
//
//  Created by softphone on 20/09/13.
//  Copyright (c) 2013 softphone. All rights reserved.
//

#import "GDataXMLNode+HTMLSerialization.h"
#import <libxml/HTMLtree.h>

@implementation GDataXMLDocument (HTMLSerialization)


- (NSData *)HTMLData {
    
    if (xmlDoc_ != NULL) {
        xmlChar *buffer = NULL;
        int bufferSize = 0;
        
        htmlDocDumpMemory(xmlDoc_, &buffer, &bufferSize);
        //xmlDocDumpMemory(xmlDoc_, &buffer, &bufferSize);
        
        if (buffer) {
            NSData *data = [NSData dataWithBytes:buffer
                                          length:bufferSize];
            xmlFree(buffer);
            return data;
        }
    }
    return nil;
}

- (int)saveToFile:(NSString*)filename
{
    
    if (xmlDoc_ != NULL) {
        
        return htmlSaveFile([filename UTF8String], xmlDoc_);

    }
    return -1;
}


@end
