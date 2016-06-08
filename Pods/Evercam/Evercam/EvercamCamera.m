#import "EvercamCamera.h"

@implementation EvercamCamera

- (id) initWithDictionary: (NSDictionary *)cameraDict {
    self= [super init];
    if (self)
    {
        
        self.camId = [cameraDict valueForKey:@"id"];
        self.name = [cameraDict valueForKey:@"name"];
        self.owner = [cameraDict valueForKey:@"owner"];
        self.rights = [[EvercamRights alloc] initWithString:[cameraDict valueForKey:@"rights"]];
        self.hasCredentials = [cameraDict valueForKey:@"cam_username"] && [cameraDict valueForKey:@"cam_password"];
        if (self.hasCredentials) {
            self.username = [cameraDict valueForKey:@"cam_username"];
            self.password = [cameraDict valueForKey:@"cam_password"];
        }
        self.timezone = [cameraDict valueForKey:@"timezone"];
        self.vendor = [cameraDict valueForKey:@"vendor_name"];
        self.model = [cameraDict valueForKey:@"model_name"];
        self.macAddress = [cameraDict valueForKey:@"mac_address"];
        if ([cameraDict valueForKey:@"is_online"] != [NSNull null]) {
            self.isOnline = [[cameraDict valueForKey:@"is_online"] boolValue];
        }
        

        self.externalH264Url = @"";
        self.externalJpgUrl = @"";
        self.externalHost = @"";
        self.externalHttpPort = 0;
        self.externalRtspPort = 0;
        NSDictionary *externalDict = [cameraDict valueForKey:@"external"];
        if (externalDict) {
            self.externalHost = [externalDict valueForKey:@"host"];
            
            NSDictionary *httpDict = [externalDict valueForKey:@"http"];
            if (httpDict) {
                self.externalJpgUrl = [httpDict valueForKey:@"jpg"];
                if ([httpDict valueForKey:@"port"] && [httpDict valueForKey:@"port"] != [NSNull null]) {
                    self.externalHttpPort = [[httpDict valueForKey:@"port"] intValue];
                }
            }
            
            NSDictionary *rtspDict = [externalDict valueForKey:@"rtsp"];
            if (rtspDict) {
                NSString *externalH264Url = [rtspDict valueForKey:@"h264"];
                self.externalH264Url = externalH264Url;
                if ([rtspDict valueForKey:@"port"] && [rtspDict valueForKey:@"port"] != [NSNull null]) {
                    self.externalRtspPort = [[rtspDict valueForKey:@"port"] intValue];
                }
            }
        }
        
        self.internalH264Url = @"";
        self.internalJpgUrl = @"";
        self.internalHost = @"";
        self.internalHttpPort = 0;
        self.internalRtspPort = 0;
        NSDictionary *internalDict = [cameraDict valueForKey:@"internal"];
        if (internalDict) {
            self.internalHost = [internalDict valueForKey:@"host"];
            
            NSDictionary *httpDict = [internalDict valueForKey:@"http"];
            if (httpDict) {
                self.internalJpgUrl = [httpDict valueForKey:@"jpg"];
                if ([httpDict valueForKey:@"port"] && [httpDict valueForKey:@"port"] != [NSNull null]) {
                    self.internalHttpPort = [[httpDict valueForKey:@"port"] intValue];
                }
            }
            
            NSDictionary *rtspDict = [internalDict valueForKey:@"rtsp"];
            if (rtspDict) {
                NSString *internalH264Url = [rtspDict valueForKey:@"h264"];
                self.internalH264Url = internalH264Url;
                if ([rtspDict valueForKey:@"port"] && [rtspDict valueForKey:@"port"] != [NSNull null]) {
                    self.internalRtspPort = [[rtspDict valueForKey:@"port"] intValue];
                }
            }
        }
        self.hlsUrl             = cameraDict[@"proxy_url"][@"hls"];
        self.rtmpUrl            = cameraDict[@"proxy_url"][@"rtmp"];
        self.is_Public          = [cameraDict[@"is_public"] boolValue];
        self.is_Discoverable    = [cameraDict[@"discoverable"] boolValue];
        self.model_id           = cameraDict[@"model_id"];
        
    }
    
    return self;
}

- (NSString *)replaceUrl:(NSString *)url withCredential:(NSString *)prefix {
    if (url && ![url isEqualToString:@""] && [url hasPrefix:prefix]) {
        NSString *replacedPrefix = [NSString stringWithFormat:@"%@%@:%@@", prefix, self.username, self.password];
        return [url stringByReplacingOccurrencesOfString:prefix withString:replacedPrefix];
    }
    return @"";
}

- (BOOL) isHikvision {
    if ([self.vendor isEqualToString:@"hikvision"]) {
        return YES;
    }
    return NO;
}

- (NSString *)getJpgPath {
    if (self.internalJpgUrl && self.internalJpgUrl.length > 0) {
        return [NSURL URLWithString:self.internalJpgUrl].path;
    } else if (self.externalJpgUrl && self.externalJpgUrl.length > 0) {
        return [NSURL URLWithString:self.externalJpgUrl].path;
    }
    
    return @"";
}

- (NSString *)getRTSPUrl {
    if (self.internalH264Url && self.internalH264Url.length > 0) {
        return [NSURL URLWithString:self.internalH264Url].path;
        
    } else if (self.externalH264Url && self.externalH264Url.length > 0) {
        return [NSURL URLWithString:self.externalH264Url].path;
    }
    
    return @"";
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Camera Name: %@", self.name];
}

@end
