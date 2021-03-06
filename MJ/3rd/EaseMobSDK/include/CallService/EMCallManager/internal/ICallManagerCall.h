/*!
 @header ICallManagerCall.h
 @abstract 为CallManager提供实时通话操作
 @author EaseMob Inc.
 @version 1.00 2014/01/01 Creation (1.00)
 */

#import <Foundation/Foundation.h>

#import "EMCallServiceDefs.h"

@class EMCallSession;
@class EMError;

/*!
 @protocol
 @brief 本协议主要处理实时通话操作
 @discussion 所有不带Block回调的异步方法, 需要监听回调时, 需要先将要接受回调的对象注册到delegate中, 示例代码如下:
 [[[EMSDKFull sharedInstance] callManager] addDelegate:self delegateQueue:dispatch_get_main_queue()]
 */
@protocol ICallManagerCall <NSObject>

@required

#pragma mark - call

/*!
 @method
 @brief  接收方同意语音通话的请求
 @param sessionId 要进行的语音通话的ID
 @result          检查语音通话条件是否具备，不具备则返回错误信息（未进行实际的拨打动作）
 @discussion      需监听[callSessionStatusChanged:changeReason:error:]
 */
- (EMError *)asyncAcceptCallSessionWithId:(NSString *)sessionId EM_DEPRECATED_IOS(2_1_2, 2_1_4, "Use - asyncAnswerCall");

- (EMError *)asyncAnswerCall:(NSString *)sessionId;

/*!
 @method
 @brief  发起方或接收方结束通话
 @param sessionId 要进行的语音通话的ID
 @param reason    结束原因
 @result          检查挂断语音通话条件是否具备，不具备则返回错误信息
 @discussion      需监听[callSessionStatusChanged:changeReason:error:]
 */
- (EMError *)asyncTerminateCallSessionWithId:(NSString *)sessionId
                                      reason:(EMCallStatusChangedReason)reason EM_DEPRECATED_IOS(2_1_2, 2_1_4, "Use - asyncEndCall:reason:");

- (EMError *)asyncEndCall:(NSString *)sessionId
                   reason:(EMCallStatusChangedReason)reason;

#pragma mark - call audio

/*!
 @method
 @brief  进行实时语音
 @param chatter  要进行语音通话的username（不能与自己通话）
 @param timeout  超时时间（传0，使用SDK默认超时时间）
 @param pError   检查语音通话条件是否具备，不具备则返回错误信息（未进行实际的拨打动作）
 @result         语音通话的实例
 @discussion     需监听[callSessionStatusChanged:changeReason:error:]
 */
- (EMCallSession *)asyncCallAudioWithChatter:(NSString *)chatter
                                     timeout:(NSUInteger)timeout
                                       error:(EMError **)pError EM_DEPRECATED_IOS(2_1_2, 2_1_4, "Use - asyncMakeVoiceCall:timeout:error:");

- (EMCallSession *)asyncMakeVoiceCall:(NSString *)chatter
                              timeout:(NSUInteger)timeout
                                error:(EMError **)pError;

#pragma makr - call video

/*!
 @method
 @brief  进行实时语音
 @param chatter  要进行视频通话的username（不能与自己通话）
 @param timeout  超时时间（传0，使用SDK默认超时时间）
 @param pError   检查视频通话条件是否具备，不具备则返回错误信息（未进行实际的拨打动作）
 @result         视频通话的实例
 @discussion     需监听[callSessionStatusChanged:changeReason:error:]
 */
- (EMCallSession *)asyncMakeVideoCall:(NSString *)chatter
                              timeout:(NSUInteger)timeout
                                error:(EMError **)pError;


@end
