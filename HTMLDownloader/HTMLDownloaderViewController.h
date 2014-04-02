//
//  HtmlDowloaderViewController.h
//  JSFiddleParseAndDownload
//
//  Created by Bartolomeo Sorrentino on 8/15/13.
//  Copyright (c) 2013 softphone. All rights reserved.
//

#import "HCDownloadViewController.h"

@interface HTMLDownloaderViewController : HCDownloadViewController <HCDownloadViewControllerDelegate>

- (void)parseAndDownload:(NSURL *)rootURL;

- (void)parseAndDownloadWithBlock:(NSURL *)rootURL completion:(void (^)())block;
@end
