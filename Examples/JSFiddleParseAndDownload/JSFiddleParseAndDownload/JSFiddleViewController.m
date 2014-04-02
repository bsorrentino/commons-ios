//
//  JSFiddleViewController.m
//  JSFiddleParseAndDownload
//
//  Created by softphone on 02/08/13.
//  Copyright (c) 2013 softphone. All rights reserved.
//

#import "JSFiddleViewController.h"
#import "HTMLDownloaderViewController.h"

@interface JSFiddleViewController ()



@end

@implementation JSFiddleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");

    NSAssert( [segue.destinationViewController isKindOfClass:[HTMLDownloaderViewController class]], @"destinationViewController is not a HTMLDownloaderViewController class");
    
    __block HTMLDownloaderViewController *downloader = segue.destinationViewController;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    
    NSLog(@"documentsDirectory\n %@",documentsDirectory );
    
    
    
    downloader.downloadDirectory = documentsDirectory;
    //[downloader parseAndDownload:[NSURL URLWithString:@"http://jsfiddle.net/bsorrentino/SHSpw"]];
    //[downloader parseAndDownload:[NSURL URLWithString:@"http://jsfiddle.net/bsorrentino/YXJMk/"]];
    [downloader parseAndDownloadWithBlock:
     [NSURL URLWithString:@"http://jsfiddle.net/bsorrentino/YXJMk/"]
                                            completion:^{
                                                
                                                double delayInSeconds = .5;
                                                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                    if (![downloader isBeingDismissed])
                                                    {
                                                        [downloader dismissViewControllerAnimated:YES completion:nil];
                                                    }
                                                });
                                            }];

}

@end
