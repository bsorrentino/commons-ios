//
//  JSFiddleParseAndDownloadTests.m
//  JSFiddleParseAndDownloadTests
//
//  Created by softphone on 02/08/13.
//  Copyright (c) 2013 softphone. All rights reserved.
//

#import "JSFiddleParseAndDownloadTests.h"
#import "GDataXMLNode.h"
#import "BBUHTMLParser.h"

@implementation JSFiddleParseAndDownloadTests

NSString *filePath;

- (void)setUp
{
    [super setUp];
    
    //NSBundle *bundle = [NSBundle mainBundle];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    filePath = [bundle pathForResource:@"test" ofType:@"html"];
    NSAssert(filePath!=nil, @"test.html not found!");

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testReplaceURL
{
    NSURL *url = [NSURL URLWithString:@"http://www.kula.org.uk/publicscripts/fullcalendar/fullcalendar.min.js"];
    
    NSArray *pathComponents = [url pathComponents];
    NSLog(@"NSURL\n\tpath:[%@]\n\tlastPathComponent:[%@]",
          [url path],
          [pathComponents lastObject],
          nil
          );
    
    NSAssert(pathComponents!=nil, @"pathComponents is nil]");
    NSAssert( [pathComponents count] > 0, @"pathComponents is less than zero");
    
    NSString *name = [pathComponents lastObject];
    NSAssert( [name compare:@"fullcalendar.min.js"]==NSOrderedSame, @"last pathComponent doesn't math with file name");
    
    
    
}

- (void)testGDataXML {
    NSData *htmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithHTMLData:htmlData error:&error];
    
    NSAssert(error==nil, @"error occurred parsing HTML file [%@]", [error description]);
    NSAssert(doc!=nil, @"error occurred parsing HTML file ... document is  nil!");
    
    NSArray/*<GDataXMLNode>*/ *nodes = [doc nodesForXPath:@"//script" error:&error];
    
    NSAssert(error==nil, @"error occurred readings nodes [%@]", [error description]);
    NSAssert( nodes!=nil, @"no script tag found!");
    NSAssert( [nodes count]==3 , @"not all scripts founded! expect 3 found %d", [nodes count]);
    
    nodes = [doc nodesForXPath:@"//script[@src]" error:&error];
    
    NSAssert(error==nil, @"error occurred readings nodes [%@]", [error description]);
    NSAssert( nodes!=nil, @"no script tag found!");
    NSAssert( [nodes count]==2 , @"not all scripts founded! expect 3 found %d", [nodes count]);
    
    
    GDataXMLNode *node = [nodes objectAtIndex:0];
    
    NSAssert([node isKindOfClass:[GDataXMLElement class]], @"node is not of right type!");
    
    
    GDataXMLNode *srcNode = [(GDataXMLElement *)node attributeForName:@"src"];
    
    NSString *src = [srcNode stringValue];
    
    NSAssert( [src compare:@"http://code.jquery.com/jquery-1.6.js"]==NSOrderedSame, @"src doesn't match url" );
    
    [srcNode setStringValue:@"test/jquery-1.6.js"];
    
    NSData *xmlData = doc.XMLData;

    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    NSString *documentsPath = [documentsDirectory
                               stringByAppendingPathComponent:@"test1.html"];
    
    [xmlData writeToFile:documentsPath atomically:YES];

    
    
}

- (void)testDTHTMLParser
{
    
    NSAssert(filePath!=nil, @"test.html not found!");
    
    BBUHTMLParser* parser = [BBUHTMLParser parserWithItemAtPath:filePath];
    [parser enumerateTagsWithName:@"link"
               matchingAttributes:@{@"rel": @"stylesheet"}
                            block:^(BBUHTMLElement* element, NSError* error) {
                                NSString * src = element.attributes[@"href"];                                
                                NSLog(@"%@", src);
                           }];
    [parser enumerateTagsWithName:@"script"
               matchingAttributes:@{@"type": @"text/javascript"}
                            block:^(BBUHTMLElement* element, NSError* error) {
                                NSString * src = element.attributes[@"src"];
                                NSLog(@"%@", src);
                            }];
    [parser enumerateTagsWithName:@"img"
               matchingAttributes:@{}
                            block:^(BBUHTMLElement* element, NSError* error) {
                                NSString * src = element.attributes[@"src"];
                                
                                //BBUHTMLElement* a = [[element childrenWithTagName:@"a"] lastObject];
                                //NSString* user = [a[@"href"] substringFromIndex:1];
                                NSLog(@"%@", src);
                            }];
    [parser enumerateTagsWithName:@"a"
               matchingAttributes:@{}
                            block:^(BBUHTMLElement* element, NSError* error) {
                                NSString * src = element.attributes[@"href"];
                                
                                //BBUHTMLElement* a = [[element childrenWithTagName:@"a"] lastObject];
                                //NSString* user = [a[@"href"] substringFromIndex:1];
                                NSLog(@"%@", src);
                            }];
}

@end
