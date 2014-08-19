//
//  AsyncImageView.m
//  Postcard
//
//  Created by markj on 2/18/09.
//  Copyright 2009 Mark Johnson. You have permission to copy parts of this code into your own projects for any use.
//  www.markj.net
//

#import "AsyncImageView.h"

#define TMP NSTemporaryDirectory()

// This class demonstrates how the URL loading system can be used to make a UIView subclass
// that can download and display an image asynchronously so that the app doesn't block or freeze
// while the image is downloading. It works fine in a UITableView or other cases where there
// are multiple images being downloaded and displayed all at the same time. 

@implementation AsyncImageView

- (void)dealloc {
    [connection cancel]; //in case the URL is still downloading
    [connection release];
    [data release]; 
    [super dealloc];
}

- (void)loadImageWithTypeFromURLV2:(NSURL *)url contentMode:(UIViewContentMode)_contentMode imageNameBG:(NSString *)_imageNameBG savedFileName:(NSString*) _savedFileName{
    // get a new one
    if (connection != nil) {
        [connection cancel];
        [connection release];
        connection = nil;
    }
    if (data != nil) {
        [data release];
        data = nil;
    }
    
    urlString = [[NSString alloc] initWithString:_savedFileName];
	NSString *uniquePath = [TMP stringByAppendingPathComponent:_savedFileName];
    
    if (imageView == nil){
        imageView = [[UIImageView alloc] init];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = _contentMode;
        self.clipsToBounds = YES;
        [self addSubview:imageView];
        imageView.frame = self.bounds;
		[imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
		[self setNeedsLayout];
    }
    
    imageView.image = [UIImage imageNamed:_imageNameBG];
    
	// Check for a cached version
	if([[NSFileManager defaultManager] fileExistsAtPath:uniquePath]) {
        imageView.image = [UIImage imageWithContentsOfFile:uniquePath];
	} else {
        
        NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}


- (void)loadImageWithTypeFromURL:(NSURL *)url contentMode:(UIViewContentMode)_contentMode imageNameBG:(NSString *)_imageNameBG {            					
    // get a new one
    if (connection != nil) {
        [connection cancel];
        [connection release];
        connection = nil;
    }
    if (data != nil) {
        [data release];
        data = nil;
    }
    
    urlString = [url absoluteString];
	fileNameString = [urlString stringByReplacingOccurrencesOfString:@"/"
                                                          withString:@""];
	NSString *uniquePath = [TMP stringByAppendingPathComponent:fileNameString];
    
    if (imageView == nil){
        imageView = [[UIImageView alloc] init];  
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = _contentMode;
        self.clipsToBounds = YES;
        [self addSubview:imageView];
        imageView.frame = self.bounds;
		[imageView setNeedsLayout]; // is this necessary if superview gets setNeedsLayout?
		[self setNeedsLayout];
    }
    
    imageView.image = [UIImage imageNamed:_imageNameBG];
    
	// Check for a cached version
	if([[NSFileManager defaultManager] fileExistsAtPath:uniquePath]) {
        imageView.image = [UIImage imageWithContentsOfFile:uniquePath];
	} else { 
    
        NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];    
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

//the URL connection calls this repeatedly as data arrives
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
	if (data==nil) { data = [[NSMutableData alloc] initWithCapacity:4096]; } 
	[data appendData:incrementalData];
}

//the URL connection calls this once all the data has downloaded
//the URL connection calls this once all the data has downloaded
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	[connection release];
	connection=nil;
    
    UIImage *image = [UIImage imageWithData:data];
    
    fileNameString = [urlString stringByReplacingOccurrencesOfString:@"/"
                                                          withString:@""];
	NSString *uniquePath = [TMP stringByAppendingPathComponent:fileNameString];
    
    if([fileNameString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound) {
        [UIImagePNGRepresentation(image) writeToFile:uniquePath atomically:YES];
    }
    else if(
            [fileNameString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound ||
            [fileNameString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
            ) {
        [UIImageJPEGRepresentation(image, 100) writeToFile:uniquePath atomically:YES];
    }
    
    imageView.image = image;
    [self setNeedsLayout];
    
	
	[data release];
	data = nil;
}

//just in case you want to get the image directly, here it is in subviews
- (UIImage*) image {
	UIImageView* iv = [[self subviews] objectAtIndex:0];
	return [iv image];
}

@end
