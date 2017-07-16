//
//  FileHelper.m
//  demo
//
//  Created by Admin on 3/29/15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "FileHelper.h"
#import "Define.h"

@implementation FileHelper

#pragma mark - general file operations

+(BOOL) isfile:(NSString *)filePath
{
    BOOL isDir;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
    if (exists) {
        /* file exists */
        if (isDir) {
            /* file is a directory */
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isfileExisting:(NSString*)filePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (NSError*)removeFileAtPath:(NSString*)filePath
{
    NSError *err=nil;
    if([FileHelper isfileExisting:filePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&err];
    }
    return err;
}

+ (NSError*)duplicateFileFromPath:(NSString*)filePath toPath:(NSString*)targetPath
{
    NSError *err=nil;
    [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:targetPath error:&err];
    return err;
}

+ (NSError*)moveFileAtPath:(NSString*)filePath toPath:(NSString*)targetPath
{
    NSError *err=nil;
    if([FileHelper isfileExisting:filePath]) {
        [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:targetPath error:&err];
    }
    return err;
}

+ (NSError*)createFile:(NSString*)path withData:(NSData*)data overwrite:(BOOL)overwrite
{
    NSError *err=nil;
    if([FileHelper isfileExisting:path] && overwrite)
    {
        err=[FileHelper removeFileAtPath:path];
    }
    
    if(err==nil)
    {
        [data writeToFile:path atomically:YES];
    }
    return err;
}

+(NSError*)createFolderAtPath:(NSString*)folderpath
{
    NSError *err=nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:folderpath withIntermediateDirectories:YES attributes:nil error:&err];
    return err;
}

+(NSArray*)contentsOfDirectoryAtPath:(NSString*)folderpath
{
    NSArray *files=nil;
    NSError *error=nil;
    
    files=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderpath error:&error];
    
    if(error!=nil)
        return nil;
    return files;
}

/*
 *Get size for the given file
 */
+(NSNumber*) sizeForFileInBytes:(NSString*)filePath
{
    NSError *error = nil;
    
    if(![FileHelper isfileExisting:filePath])
        return [NSNumber numberWithInt:0];
    
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
    
    NSNumber *size=0;
    if (!error)
    {
        size = [attributes objectForKey:NSFileSize];
    }
    return size;
}

/*
 *Convert Bytes to MegaBytes
 */
+(NSNumber*) convertBytesToMegaBytes:(NSNumber*)bytes
{
    NSNumber* result =[NSNumber numberWithDouble:([bytes longLongValue] / 1048576.0)];
    return result;
}

#pragma mark -

+ (NSString *)temporaryDataDirectory
{
    NSArray *applicationDataDirectories = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *applicationDataDirectory = [applicationDataDirectories objectAtIndex:0];
    applicationDataDirectory = [applicationDataDirectory stringByAppendingPathComponent:@"gif_temporary"];
    
    //Create the directory if it not exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:applicationDataDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:applicationDataDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return applicationDataDirectory;
}

+ (NSString *)applicationDataDirectory
{
    NSArray *applicationDataDirectories = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *applicationDataDirectory = [applicationDataDirectories objectAtIndex:0];
    applicationDataDirectory = [applicationDataDirectory stringByAppendingPathComponent:APP_DIRECTORY];
    
    //Create the directory if it not exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:applicationDataDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:applicationDataDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return applicationDataDirectory;
}

+ (NSString*)pathForApplicationDataFile:(NSString*)filename
{
    NSString *applicationDataDirectory=[FileHelper applicationDataDirectory];
    return [applicationDataDirectory stringByAppendingPathComponent:filename];
}

+ (NSString*)pathForSecondSplashFile
{
    NSString *applicationDataDirectory=[FileHelper applicationDataDirectory];
    return [applicationDataDirectory stringByAppendingPathComponent:@"AdsSplash.png"];
}



+ (NSError*)duplicateFiletoAppDataFromBundle:(NSString*)filename toPath:(NSString*)strPath overwrite:(BOOL)overwrite;
{
    NSString *ext=[filename pathExtension];
    NSString *name=[filename stringByDeletingPathExtension];
    NSString *bundlepath=[[NSBundle mainBundle] pathForResource:name ofType:ext];
    
    if(bundlepath==nil)
    {
        return [NSError errorWithDomain:@"FileSystem" code:10000 userInfo:nil];
    }
    
    NSError *err=nil;
    if(overwrite && [FileHelper isfileExisting:strPath])
    {
        err=[self removeFileAtPath:strPath];
        if(!err)
        {
        }
    }
    err=[FileHelper duplicateFileFromPath:bundlepath toPath:strPath];
    return err;
}


@end
