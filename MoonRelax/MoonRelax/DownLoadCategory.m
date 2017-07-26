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
#import "FileHelper.h"
static DownLoadCategory *sharedInstance = nil;
static bool isFinish;

@import FirebaseStorage;
@implementation DownLoadCategory
{
    FIRStorageReference *storageRef;
}
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
        FIRStorage *storage = [FIRStorage storage];
        storageRef = [storage reference];
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
        ;
        
        // Create a reference to the file we want to download
        FIRStorageReference *starsRef = [storageRef child:dic[@"source"]];
        
        // Start the download (in this case writing to a file)
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        NSURL *localURL = [documentsDirectoryURL URLByAppendingPathComponent:dic[@"source"]];
        FIRStorageDownloadTask *downloadTask = [starsRef writeToFile:localURL];
        
        // Observe changes in status
        [downloadTask observeStatus:FIRStorageTaskStatusResume handler:^(FIRStorageTaskSnapshot *snapshot) {
            // Download resumed, also fires when the download starts
        }];
        
        [downloadTask observeStatus:FIRStorageTaskStatusPause handler:^(FIRStorageTaskSnapshot *snapshot) {
            // Download paused
        }];
        
        [downloadTask observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot *snapshot) {
            // Download reported progress
            double percentComplete = 100.0 * (snapshot.progress.completedUnitCount) / (snapshot.progress.totalUnitCount);
            if (_callbackProgess) {
                _callbackProgess(percentComplete);
            }

        }];
        
        [downloadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot) {
            // Download completed successfully
            [self unzipWithCategoryItem:dic];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:myArrType];
            [arr removeObjectAtIndex:0];
            [myWeak doOperator:arr];

        }];
        
        // Errors only occur in the "Failure" case
        [downloadTask observeStatus:FIRStorageTaskStatusFailure handler:^(FIRStorageTaskSnapshot *snapshot) {
            if (snapshot.error != nil) {
                switch (snapshot.error.code) {
                    case FIRStorageErrorCodeObjectNotFound:
                        // File doesn't exist
                        break;
                        
                    case FIRStorageErrorCodeUnauthorized:
                        // User doesn't have permission to access file
                        break;
                        
                    case FIRStorageErrorCodeCancelled:
                        // User canceled the upload
                        break;
                        
                        /* ... */
                        
                    case FIRStorageErrorCodeUnknown:
                        // Unknown error occurred, inspect the server response
                        break;
                }
            }
        }];
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
    NSString *unzipPath = [FileHelper applicationDataDirectory];
    //unzip
    [SSZipArchive unzipFileAtPath:archivePath toDestination:unzipPath overwrite:YES password:pwd_Unzip progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
        //PRORESS
    } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nonnull error) {
        [FileHelper removeFileAtPath:archivePath];
        
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
