//
//  DownLoadCategory.m
//  RelaxApp
//
//  Created by JoJo on 10/2/16.
//  Copyright © 2016 JoJo. All rights reserved.
//

#import "DownLoadCategory.h"
#import "SSZipArchive.h"
#import "Define.h"
static DownLoadCategory *sharedInstance = nil;
static bool isFinish;

@implementation DownLoadCategory
+ (DownLoadCategory *) sharedInstance
{
    static dispatch_once_t once = 0;
    
    dispatch_once(&once, ^{sharedInstance = [[self alloc] init];});
    return sharedInstance;
}
-(id)init
{
    if (self = [super init]) {
        self.operationQueue =  [NSOperationQueue new];
        
        isFinish = YES;
        
        return self;
    }
    
    return nil;
}
-(void)setCallback:(DownLoadCategoryCallback)callback
{
    _callback = callback;
}
-(void)setCallbackProgess:(ProgressCallback)callbackProgess
{
    _callbackProgess = callbackProgess;
}
-(void) doOperator:(NSArray*)myArrType
{
    __weak DownLoadCategory *myWeak = self;

    if (myArrType.count > 0) {
        NSDictionary *dic = myArrType[0];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,dic[@"source"]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
       float progress = downloadProgress.fractionCompleted;
        if (_callbackProgess) {
            _callbackProgess(progress);
        }
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        [self unzipWithCategoryItem:dic];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:myArrType];
        [arr removeObjectAtIndex:0];
        [myWeak doOperator:arr];
        
    }];
    [downloadTask resume];
    }
    else
    {
        isFinish = YES;
    }

}
-(void) resetParam
{
    isFinish = YES;
    
    [self.operationQueue cancelAllOperations];
    [manager invalidateSessionCancelingTasks: YES];
}

-(void)fnListMusicWithCategory :(NSArray*) arrCategory
{
    if (isFinish) {
        isFinish = NO;
        [self performSelector:@selector(resetParam) withObject:nil afterDelay:180];
        NSInvocationOperation *operationOne = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doOperator:) object:arrCategory];
        [self.operationQueue addOperation:operationOne];
    }
}
//MARK: - UNZIP
- (void)unzipWithCategoryItem:(NSDictionary*)dicCategory {
    NSString *filename = (NSString*)dicCategory[@"source"];
    // use extracted files from [-testUnzipping]
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:filename];
    //
    NSString *unzipPath = documentsDirectory;
    //unzip
    [SSZipArchive unzipFileAtPath:archivePath toDestination:unzipPath overwrite:YES password:pwd_Unzip progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        //PRORESS
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
        //COMPLETE
        if (_callback) {
            _callback(dicCategory);
        }
        if (_callbackProgess) {
            _callbackProgess(1);
        }
    }];
}
@end
