//
//  HtmlDowloaderViewController.m
//  JSFiddleParseAndDownload
//
//  Created by Bartolomeo Sorrentino on 8/15/13.
//  Copyright (c) 2013 softphone. All rights reserved.
//

#import "HTMLDownloaderViewController.h"
#import "ErrorKit.h"
#import "GDataXMLNode+HTMLSerialization.h"

@interface HTMLDownloaderViewController ()

@property (nonatomic) GDataXMLDocument *parsedDocument;
@property (nonatomic) NSURL *rootURL;
@property (nonatomic,copy) void (^completionBlock)();

- (NSUInteger)parseAndDownload;
- (void)replaceNodeURL:(GDataXMLNode *)sourceNode url:(NSURL *)sourceUrl;
- (void)updateIndexHtml;


@end


@implementation HTMLDownloaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self =  [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
        self.delegate = self;
    }
    return self;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Utility

- (void)replaceNodeURL:(GDataXMLNode *)sourceNode url:(NSURL *)sourceUrl;
{
    NSString *resourceName = [sourceUrl lastPathComponent];
    
    [sourceNode setStringValue:resourceName];
    
}

- (void)updateIndexHtml
{
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
    //                                                    NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths lastObject];
    
    
    NSString *documentsPath = [self.downloadDirectory
                               stringByAppendingPathComponent:@"index.html"];
    [self.parsedDocument saveToFile:documentsPath];
    
    //NSData *xmlData = self.parsedDocument.HTMLData;
    //[xmlData writeToFile:documentsPath atomically:YES];
    
}

#pragma HTMLParser

- (void)parseAndDownload:(NSURL *)value
{
    
    [self parseAndDownloadWithBlock:value completion:nil];
    
}

- (void)parseAndDownloadWithBlock:(NSURL *)value completion:(void (^)())block
{
    NSLog(@"download directory\n'%@'", self.downloadDirectory);

    self.completionBlock = block;
    
    _rootURL = value;
    
    NSURL *showURL = [NSURL URLWithString:@"show" relativeToURL:value];
    
    [super downloadURL:showURL userInfo:@{@"root":[NSNumber numberWithBool:YES] }];
    
}


- (NSUInteger)parseAndDownload
{
    NSUInteger result = 0;
    
    if( !self.parsedDocument ) {
        return result;
    }
    
    NSError *error;
    
    ///
    /// DOWNLOAD SCRIPT
    ///
    {
    NSArray/*<GDataXMLNode>*/ *nodes = [self.parsedDocument nodesForXPath:@"//script[@src]" error:&error];
    
    if( error ) {
        MRLogError(error);
        
        [[UIAlertView alertWithTitle:nil error:error] show];
        
        self.parsedDocument = nil;
    }
    
    for (GDataXMLElement *e in nodes) {
    
        GDataXMLNode *urlNode = [e attributeForName:@"src"];
        
        NSString * urlString = [urlNode stringValue];
        
        NSURL *url = [NSURL URLWithString:urlString  relativeToURL:self.rootURL];

        NSLog( @"downloading url [%@]", url.absoluteString );
        [self replaceNodeURL:urlNode url:url];
        [self downloadURL:url userInfo:@{ @"ordinal" : [NSNumber numberWithUnsignedInteger:++result]}];
        
    }
    }
    ///
    /// DOWNLOAD CSS
    ///
    {
        NSArray/*<GDataXMLNode>*/ *nodes = [self.parsedDocument nodesForXPath:@"//link[@href]" error:&error];
        
        if( error ) {
            MRLogError(error);
            
            [[UIAlertView alertWithTitle:nil error:error] show];
            
            self.parsedDocument = nil;
        }
        
        for (GDataXMLElement *e in nodes) {
            
            GDataXMLNode *urlNode = [e attributeForName:@"href"];
            
            NSString * urlString = [urlNode stringValue];
            
            NSURL *url = [NSURL URLWithString:urlString  relativeToURL:self.rootURL];
            
            NSLog( @"downloading url [%@]", url.absoluteString );

            [self replaceNodeURL:urlNode url:url];
            [self downloadURL:url userInfo:@{ @"ordinal" : [NSNumber numberWithUnsignedInteger:++result]}];
        }
    }
    ///
    /// DOWNLOAD IMAGES
    ///
    {
        NSArray/*<GDataXMLNode>*/ *nodes = [self.parsedDocument nodesForXPath:@"//img[@src]" error:&error];
        
        if( error ) {
            MRLogError(error);
            
            [[UIAlertView alertWithTitle:nil error:error] show];
            
            self.parsedDocument = nil;
        }
        
        for (GDataXMLElement *e in nodes) {
            
            GDataXMLNode *urlNode = [e attributeForName:@"src"];
            
            NSString * urlString = [urlNode stringValue];
            
            NSURL *url = [NSURL URLWithString:urlString  relativeToURL:self.rootURL];
            
            NSLog( @"downloading url [%@]", url.absoluteString );
            
            if ( [url.scheme compare:@"http" options:NSCaseInsensitiveSearch]==NSOrderedSame ) {
                [self replaceNodeURL:urlNode url:url];
                [self downloadURL:url userInfo:@{ @"ordinal" : [NSNumber numberWithUnsignedInteger:++result]}];
            }
            else {
                NSLog(@"url is not valid [%@]", urlString);
            }
        }
    }
    
    [self updateIndexHtml];

    return result;
    
}

#pragma HCDownloadViewControllerDelegate

- (void)downloadController:(HCDownloadViewController *)vc startedDownloadingURL:(NSURL *)url userInfo:(NSDictionary *)userInfo
{
    
    NSLog(@"startedDownloadingURL");
}
- (void)downloadController:(HCDownloadViewController *)vc dowloadedFromURL:(NSURL *)url progress:(float)progress userInfo:(NSDictionary *)userInfo
{
    NSLog(@"dowloadedFromURL %f", progress);
    
}
- (void)downloadController:(HCDownloadViewController *)vc finishedDownloadingURL:(NSURL *)url toFile:(NSString *)fileName userInfo:(NSDictionary *)userInfo
{
    NSLog(@"finishedDownloadingURL");
    if (userInfo !=nil && [userInfo objectForKey:@"root"]!=nil) {
        
        NSString *filePath = [self.downloadDirectory stringByAppendingPathComponent:fileName];
        NSData *htmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
        NSError *error;
        
        self.parsedDocument = [[GDataXMLDocument alloc] initWithHTMLData:htmlData error:&error];
        if( error ) {
            MRLogError(error);
        
            [[UIAlertView alertWithTitle:nil error:error] show];
        
            self.parsedDocument = nil;
        }
        else {
            NSUInteger numberOfDownloads = [self parseAndDownload];
            NSLog(@"Number of download [%d]",numberOfDownloads);
            if( numberOfDownloads == 0 && self.completionBlock !=nil ) {
                
                //dispatch_async( dispatch_get_main_queue(), self.onCompleteBlock);
                self.completionBlock();

            }
        }
        
    }
    else {
        NSInteger numberOfDownloads = super.numberOfDownloads;

        NSLog(@"Number of download [%d] to go",numberOfDownloads );
        
        if( numberOfDownloads == 0 && self.completionBlock !=nil ) {
            
            //dispatch_async( dispatch_get_main_queue(), self.onCompleteBlock);
            self.completionBlock();
        }

    }
    
}
- (void)downloadController:(HCDownloadViewController *)vc failedDownloadingURL:(NSURL *)url withError:(NSError *)error userInfo:(NSDictionary *)userInfo
{
    MRLogError(error);
    
    [[UIAlertView alertWithTitle:nil error:error] show];
}

@end
