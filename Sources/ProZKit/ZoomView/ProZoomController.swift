//
//  ProZoomController.swift
//  ProZKitDemo
//
//  Created by Low Jung Xuan on 12/3/25.
//

import Foundation
import MobileRTC

@MainActor
public class ProZoomController: NSObject { // 添加 public
    public static let shared = ProZoomController() // 添加 public

    var jwt: String?
    var meetingId: String?
    var passcode: String?

    lazy var customMeetingVC: CustomMeetingViewController = .init()

    lazy var waitingHostVC: WaitingHostViewController = .init()

    lazy var navigationController: UINavigationController? = MobileRTC.shared().mobileRTCRootController()

    public func initialize() {
        PrettyLogger.info("正在初始化 Zoom SDK...")
        let context = MobileRTCSDKInitContext()
        context.domain = "https://zoom.us" // 确保替换为你的真实 domain
        context.enableLog = true
        context.locale = .default
        context.enableCustomizeMeetingUI = true // 必须开启自定义UI
        guard MobileRTC.shared().initialize(context) else {
            PrettyLogger.error("Zoom SDK 初始化失败。")
            return
        }
        PrettyLogger.info("初始化成功。")
    }

    public func startMeeting(
        _ controller: UIViewController,
        jwt: String,
        meetingId: String,
        passcode: String,
        clinicName: String,
        docterName: String,
        docterNumber: String
    ) {
        self.jwt = jwt
        self.meetingId = meetingId
        self.passcode = passcode

        guard let authService = MobileRTC.shared().getAuthService() else {
            PrettyLogger.error("无法获取认证服务。")
            return
        }

        guard let navigationController = controller.navigationController else {
            PrettyLogger.error("没有UINavigationController。")
            return
        }

        self.navigationController = navigationController

        customMeetingVC.configureInfo(
            clinicName: clinicName,
            docterName: docterName,
            docterNumber: docterNumber
        )

        authService.delegate = self
        authService.jwtToken = jwt
        authService.sdkAuth()
    }

    private func joinMeeting() {
        PrettyLogger.info("点击加入会议按钮，准备加入会议...")

        guard let meetingService = MobileRTC.shared().getMeetingService() else {
            PrettyLogger.error("无法获取会议服务。")
            return
        }

        MobileRTC.shared().getWaitingRoomService()?.delegate = self

        meetingService.customizedUImeetingDelegate = self
        meetingService.delegate = self

        let joinParam = MobileRTCMeetingJoinParam()
        joinParam.meetingNumber = meetingId
        joinParam.password = passcode
        joinParam.userName = UIDevice.current.name

        let result = meetingService.joinMeeting(with: joinParam)
        MobileRTC.shared().getMeetingSettings()?.setAutoConnectInternetAudio(true)
        PrettyLogger.info("[INFO] 加入会议结果: \(result)")
    }
}

extension ProZoomController: MobileRTCAuthDelegate {
    public nonisolated func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        Task { @MainActor in
            switch returnValue {
            case .success:
                PrettyLogger.info("[AUTH SUCCESS] ✅ 认证成功，SDK 可用，准备加入会议。")
                joinMeeting()
            case .keyOrSecretEmpty:
                PrettyLogger.error("[ERROR] 🔑 JWT Token 或 Secret 为空，请检查配置。")
            case .keyOrSecretWrong:
                PrettyLogger.error("[ERROR] ❌ JWT Token 或 Secret 无效，请检查。")
            case .accountNotSupport:
                PrettyLogger.error("[ERROR] 🚫 账户不支持 SDK 功能。")
            case .accountNotEnableSDK:
                PrettyLogger.error("[ERROR] 🔒 账户未启用 SDK 功能，请确认权限。")
            case .unknown:
                PrettyLogger.error("[ERROR] 🤔 认证过程中发生未知错误。")
            case .serviceBusy:
                PrettyLogger.error("[ERROR] 🛑 Zoom 服务繁忙，请稍后再试。")
            case .none:
                PrettyLogger.error("[ERROR] ⚪️ 空错误状态，请检查日志。")
            case .overTime:
                PrettyLogger.error("[ERROR] ⏰ 认证超时，请检查网络。")
            case .networkIssue:
                PrettyLogger.error("[ERROR] 📡 网络连接问题，请检查网络状态。")
            case .clientIncompatible:
                PrettyLogger.error("[ERROR] 💻 客户端版本不兼容，请更新 Zoom 客户端。")
            case .tokenWrong:
                PrettyLogger.error("[ERROR] 🔐 Token 格式错误，请检查 Token 配置。")
            case .limitExceededException:
                PrettyLogger.error("[ERROR] 🆘 API 调用次数超限，请稍后再试。")
            @unknown default:
                PrettyLogger.error("[ERROR] ⚠️ 未知错误状态: \(returnValue.rawValue)")
            }
        }
    }
}

extension ProZoomController: MobileRTCCustomizedUIMeetingDelegate {
    public nonisolated func onInitMeetingView() {
        Task { @MainActor in
            PrettyLogger.info("[INFO] Zoom SDK 初始化会议视图，进入会议前...")
            if (navigationController?.presentedViewController as? CustomMeetingViewController) != nil {
                return
            }
            let vc = customMeetingVC
            vc.modalPresentationStyle = .fullScreen
            navigationController?.present(vc, animated: true)
            customMeetingVC.loadingView()
        }
    }

    public nonisolated func onDestroyMeetingView() {
        Task { @MainActor in
            PrettyLogger.info("[INFO] Zoom SDK 销毁会议视图，退出会议...")
            navigationController?.dismiss(animated: true)
        }
    }
}

extension ProZoomController: MobileRTCMeetingServiceDelegate {
    public nonisolated func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        Task { @MainActor in
            switch state {
            case .idle:
                PrettyLogger.info("[MEETING STATE] 会议状态: 空闲（idle）。")
            case .connecting:
                PrettyLogger.info("[MEETING STATE] 会议状态: 连接中（connecting）。")
                if (navigationController?.presentedViewController as? CustomMeetingViewController) != nil {
                    customMeetingVC.loadingView()
                    return
                }
                let vc = customMeetingVC
                vc.modalPresentationStyle = .fullScreen
                navigationController?.present(vc, animated: true)
                customMeetingVC.loadingView()
            case .waitingForHost:
                PrettyLogger.info("[MEETING STATE] 会议状态: 等待主持人（waitingForHost）。")
                customMeetingVC.waitingHost()
            case .inMeeting:
                PrettyLogger.info("[MEETING STATE] 会议状态: 正在进行（inMeeting）。")
                customMeetingVC.reloadVideoView()
            case .disconnecting:
                PrettyLogger.info("[MEETING STATE] 会议状态: 正在断开连接（disconnecting）。")
            case .reconnecting:
                PrettyLogger.info("[MEETING STATE] 会议状态: 正在重新连接（reconnecting）。")
            case .failed:
                PrettyLogger.info("[MEETING STATE] 会议状态: 连接失败（failed）。")
            case .ended:
                PrettyLogger.info("[MEETING STATE] 会议状态: 会议结束（ended）。")
            case .locked:
                PrettyLogger.info("[MEETING STATE] 会议状态: 会议已锁定（locked）。")
            case .unlocked:
                PrettyLogger.info("[MEETING STATE] 会议状态: 会议已解锁（unlocked）。")
            case .inWaitingRoom:
                PrettyLogger.info("[MEETING STATE] 会议状态: 在等待室中（inWaitingRoom）。")
            case .webinarPromote:
                PrettyLogger.info("[MEETING STATE] 会议状态: 正在推广为研讨会（webinarPromote）。")
            case .webinarDePromote:
                PrettyLogger.info("[MEETING STATE] 会议状态: 正在撤销研讨会（webinarDePromote）。")
            case .joinBO:
                PrettyLogger.info("[MEETING STATE] 会议状态: 正在加入 BO（joinBO）。")
            case .leaveBO:
                PrettyLogger.info("[MEETING STATE] 会议状态: 正在离开 BO（leaveBO）。")
            @unknown default:
                PrettyLogger.info("[MEETING STATE] 会议状态: 未知状态（unknown）。")
            }
            PrettyLogger.info("[MEETING STATE CHANGE] 当前会议状态：\(state)")
        }
    }

    public nonisolated func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
        Task { @MainActor in
            switch error {
            case .success:
                PrettyLogger.info("[MEETING ERROR] 会议没有错误，正常运行。")
            case .networkError:
                PrettyLogger.error("[MEETING ERROR] 网络错误，无法连接到会议。")
            case .reconnectError:
                PrettyLogger.error("[MEETING ERROR] 重新连接失败，请检查网络。")
            case .mmrError:
                PrettyLogger.error("[MEETING ERROR] 会议 MMR 错误，无法加入会议。")
            case .passwordError:
                PrettyLogger.error("[MEETING ERROR] 密码错误，请核对会议密码。")
            case .sessionError:
                PrettyLogger.error("[MEETING ERROR] 会议会话错误，无法加入会议。")
            case .meetingOver:
                PrettyLogger.error("[MEETING ERROR] 会议已经结束，无法加入。")
            case .meetingNotStart:
                PrettyLogger.error("[MEETING ERROR] 会议尚未开始，请稍后再试。")
            case .meetingNotExist:
                PrettyLogger.error("[MEETING ERROR] 会议不存在，请确认会议号。")
            case .meetingUserFull:
                PrettyLogger.error("[MEETING ERROR] 会议人数已满，无法加入。")
            case .meetingClientIncompatible:
                PrettyLogger.error("[MEETING ERROR] 客户端不兼容，无法加入会议。")
            case .noMMR:
                PrettyLogger.error("[MEETING ERROR] 无法获取 MMR，无法加入会议。")
            case .meetingLocked:
                PrettyLogger.error("[MEETING ERROR] 会议已锁定，无法加入。")
            case .meetingRestricted:
                PrettyLogger.error("[MEETING ERROR] 会议受限制，无法加入。")
            case .meetingRestrictedJBH:
                PrettyLogger.error("[MEETING ERROR] 会议受限制，需要加入会议的主持人验证。")
            case .cannotEmitWebRequest:
                PrettyLogger.error("[MEETING ERROR] 无法发送 Web 请求，检查网络。")
            case .cannotStartTokenExpire:
                PrettyLogger.error("[MEETING ERROR] 无法开始会议，Token 已过期。")
            case .videoError:
                PrettyLogger.error("[MEETING ERROR] 视频错误，无法启动视频。")
            case .audioAutoStartError:
                PrettyLogger.error("[MEETING ERROR] 音频自动启动错误。")
            case .registerWebinarFull:
                PrettyLogger.error("[MEETING ERROR] 注册的研讨会人数已满。")
            case .registerWebinarHostRegister:
                PrettyLogger.error("[MEETING ERROR] 研讨会主持人注册失败。")
            case .registerWebinarPanelistRegister:
                PrettyLogger.error("[MEETING ERROR] 研讨会嘉宾注册失败。")
            case .registerWebinarDeniedEmail:
                PrettyLogger.error("[MEETING ERROR] 研讨会拒绝了该邮箱注册。")
            case .registerWebinarEnforceLogin:
                PrettyLogger.error("[MEETING ERROR] 研讨会强制登录，无法加入。")
            case .zcCertificateChanged:
                PrettyLogger.error("[MEETING ERROR] 证书已更改，无法继续。")
            case .vanityNotExist:
                PrettyLogger.error("[MEETING ERROR] 自定义域名不存在。")
            case .joinWebinarWithSameEmail:
                PrettyLogger.error("[MEETING ERROR] 已使用相同的电子邮件加入研讨会。")
            case .writeConfigFile:
                PrettyLogger.error("[MEETING ERROR] 无法写入配置文件。")
            case .removedByHost:
                PrettyLogger.error("[MEETING ERROR] 被主持人移除。")
            case .hostDisallowOutsideUserJoin:
                PrettyLogger.error("[MEETING ERROR] 主持人不允许外部用户加入会议。")
            case .unableToJoinExternalMeeting:
                PrettyLogger.error("[MEETING ERROR] 无法加入外部会议。")
            case .blockedByAccountAdmin:
                PrettyLogger.error("[MEETING ERROR] 账户被管理员屏蔽，无法加入。")
            case .needSignInForPrivateMeeting:
                PrettyLogger.error("[MEETING ERROR] 需要登录才能加入私人会议。")
            case .invalidArguments:
                PrettyLogger.error("[MEETING ERROR] 参数无效，检查会议设置。")
            case .invalidUserType:
                PrettyLogger.error("[MEETING ERROR] 无效用户类型，无法加入会议。")
            case .inAnotherMeeting:
                PrettyLogger.error("[MEETING ERROR] 用户已在另一个会议中。")
            case .tooFrequenceCall:
                PrettyLogger.error("[MEETING ERROR] API 调用过于频繁，请稍后再试。")
            case .wrongUsage:
                PrettyLogger.error("[MEETING ERROR] 错误用法，检查代码。")
            case .failed:
                PrettyLogger.error("[MEETING ERROR] 会议加入失败，稍后再试。")
            case .vbBase:
                PrettyLogger.error("[MEETING ERROR] 视频基础配置错误。")
            case .vbMaximumNum:
                PrettyLogger.error("[MEETING ERROR] 视频最大人数限制。")
            case .vbSaveImage:
                PrettyLogger.error("[MEETING ERROR] 视频保存图片失败。")
            case .vbRemoveNone:
                PrettyLogger.error("[MEETING ERROR] 无法移除视频流。")
            case .vbNoSupport:
                PrettyLogger.error("[MEETING ERROR] 视频不支持当前操作。")
            case .vbGreenScreenNoSupport:
                PrettyLogger.error("[MEETING ERROR] 不支持绿幕功能。")
            case .appPrivilegeTokenError:
                PrettyLogger.error("[MEETING ERROR] 应用权限 Token 错误。")
            case .unknown:
                PrettyLogger.error("[MEETING ERROR] 发生未知错误，请检查。")
            @unknown default:
                PrettyLogger.error("[MEETING ERROR] 未处理的错误：\(error.rawValue)")
            }
            PrettyLogger.error("[MEETING ERROR] 错误详情: \(error) - \(message ?? "")")
        }
    }

    public nonisolated func onSinkMeetingActiveVideo(forDeck userID: UInt) {
        Task { @MainActor in
            customMeetingVC.onSinkMeetingActiveVideo(userID)
        }
    }

    public nonisolated func onSinkMeetingVideoStatusChange(_ userID: UInt) {
        Task { @MainActor in
            customMeetingVC.onSinkMeetingVideoStatusChange(userID)
        }
    }
}

extension ProZoomController: MobileRTCWaitingRoomServiceDelegate {
    public nonisolated func onWaitingRoomPresetAudioStatusChanged(_ audioCanTurnOn: Bool) {
        Task { @MainActor in
            PrettyLogger.log("[MEETING PRESET AUDIO: \(audioCanTurnOn)]")
        }
    }

    public nonisolated func onWaitingRoomPresetVideoStatusChanged(_ videoCanTurnOn: Bool) {
        Task { @MainActor in
            PrettyLogger.log("[MEETING PRESET VIDEO: \(videoCanTurnOn)]")
        }
    }
}
