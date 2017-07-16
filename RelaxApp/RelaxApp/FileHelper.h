//
//  FileHelper.h
//  demo
//
//  Created by Admin on 3/29/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_DIRECTORY       @"RELAX"

@interface FileHelper : NSObject

#pragma mark - general file operations

+ (BOOL)isfileExisting:(NSString*)filePath;

+ (NSError*)removeFileAtPath:(NSString*)filePath;

+ (NSError*)duplicateFileFromPath:(NSString*)filePath toPath:(NSString*)targetPath;

+ (NSError*)moveFileAtPath:(NSString*)filePath toPath:(NSString*)targetPath;

+ (NSError*)createFile:(NSString*)path withData:(NSData*)data overwrite:(BOOL)overwrite;

+(NSError*)createFolderAtPath:(NSString*)folderpath;

+(NSNumber*) sizeForFileInBytes:(NSString*)filePath;

+(NSNumber*) convertBytesToMegaBytes:(NSNumber*)bytes;

+(NSArray*) contentsOfDirectoryAtPath:(NSString*)folderpath;

#pragma mark -

+ (NSString *)temporaryDataDirectory;

+ (NSString *)applicationDataDirectory;

+ (NSString*)pathForApplicationDataFile:(NSString*)filename;

+ (NSString*)pathForSecondSplashFile;

#pragma mark - 
+ (NSString *) documentSecureDirectory;
+ (NSString *) documentTempDirectory;
+ (NSError*)duplicateFiletoAppDataFromBundle:(NSString*)filename toPath:(NSString*)strPath overwrite:(BOOL)overwrite;

@end
