//
//  BOSHDefines.h
//  BOSHVideo
//
//  Created by yang on 2017/9/25.
//  Copyright © 2017年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

//错误相关
#define CustomErrorDomain @"com.both.video"
typedef enum {
    BOTHDefultFailed = -1000,
    BOTHENVError,//输入参数
    BOTHErrorPath,//路径错误
    BOTHExportFileFailed,
    BOTHShareFailed,// 分享失败
}BOTHErrorFailed;

#define BOTHERROR(A) [NSDictionary dictionaryWithObject:@A forKey:NSLocalizedDescriptionKey]

//define log
#ifdef DEBUG
#define BLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define BLog(...)
#endif

//支持视频封装格式
typedef enum {
    BOSHFileTypeUnknown = 0,
    BOSHFileTypeMP4,
    BOSHFileTypeMOV,
    BOSHFileTypeMP3,
    BOSHFileTypeAAC,
    BOSHFileTypeAVS,//
    BOSHFileTypeFLV,//Flash Video
    BOSHFileTypeTS,//MPEG2 transport stream
    BOSHFileTypeES,//Element Stream
    BOSHFileTypePES,//Package Element Stream
    BOSHFileTypeM3U8,
}BOSHFileType;

//支持的网络协议
typedef enum {
    BOSHTransferProtocolUnknown = 0,
    BOSHTransferProtocolHTTP,//HTTP
    BOSHTransferProtocolRTMP,//RTMP
    BOSHTransferProtocolHTTPS,//HTTPS
    BOSHTransferProtocolUDP,//UDP
    BOSHTransferProtocolTCP,//TCP
    BOSHTransferProtocolSSDP,//简单发现协议
}BOSHTransferProtocol;

#define BOSHIMG(A) [UIImage imageNamed:@A]

//支持分段功能
typedef enum {
    BOSHTimelineActionUnknown = 0,
    BOSHTimelineActionMute,
    BOSHTimelineActionRotate,
    BOSHTimelineActionAddSubtiles,
    BOSHTimelineActionAddGIF,
    BOSHTimelineActionRecord,//
    BOSHTimelineActionFilter,
    BOSHTimelineActionReplace,
    BOSHTimelineActionInsert,
}BOSHTimelineAction;


#define kHiddenAllOverlayNotice @"kHiddenAllOverlayNotice"

