//
//  SettingView.swift
//  SAEAL
//
//  Created by 김유진 on 12/12/23.
//

import SwiftUI
import StoreKit
import MessageUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var settingVM = SettingViewModel()

    var body: some View {
        VStack {
            HStack {
                Text("설정")
                    .tint(.black)
                    .font(.title01)
                    .padding()
                Spacer()
                
            }
            List {
                Section("유저 설정") {
                    Button(action: {
                        settingVM.resetAlert = true
                    }, label: {
                        Text("앱 초기화 하기")
                            .tint(.black)
                            .font(.body01)
                    })
                    .alert(isPresented: Binding<Bool>(
                        get: { settingVM.resetAlert },
                        set: { settingVM.resetAlert = $0 }
                    ), content: {
                        return Alert(title: Text("데이터를 초기화 하시겠습니까?"), message: Text("절대 되돌릴 수 없습니다."),
                              primaryButton: .destructive(Text("삭제") , action: {
                            settingVM.delAll()
                            dismiss()
                        }),
                              secondaryButton: .cancel(Text("취소"), action: {
                            settingVM.resetAlert = false
                        })
                        )
                    })
                }
                .font(.title05)
                
                Section("지원") {
                    Button(action: {
                        settingVM.isShowingMailView.toggle()
                    }, label: {
                        Text("문의하기")
                            .font(.body01)
                    })
                    .sheet(isPresented: Binding<Bool>(
                        get: { settingVM.isShowingMailView },
                        set: { settingVM.isShowingMailView = $0 }
                    )) {
                        MailView(content: "", to: "chris3209@naver.com", subject: "[새알] ")
                    }
                    .alert(isPresented: Binding<Bool>(
                        get: { settingVM.cantSend },
                        set: { settingVM.cantSend = $0 }
                    ), content: {
                        return Alert(title: Text("문의를 보낼 수 없습니다."), message: Text("이메일을 복사하시겠습니까?"),
                                     primaryButton: .default(Text("네") , action: {
                            UIPasteboard.general.string = "chris3209@naver.com"
                        }),
                              secondaryButton: .cancel(Text("아니오"), action: {
                            settingVM.cantSend = false
                        })
                        )
                    })
                    
                    Button(action: {
                        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive
                        }) as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    }, label: {
                        Text("앱 평가하기")
                            .font(.body01)
                    })
                }
                .font(.title05)
                
                Section("기타") {
                    if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                        Text("버전 v\(buildNumber)")
                            .font(.body01)
                    }
                    
                    
                    NavigationLink {
                        VStack {
                            Spacer()
                            Image(uiImage: .bb)
                                .resizable()
                                .frame(width: 300, height: 375)
                            Spacer()
                            Text("YOOJIN KIM")
                                .font(.body01)
                            Text("Instagram @7uly8ighth")
                                .font(.body01)
                            Text("Email chris3209@naver.com")
                                .font(.body01)
                            Text("Github https://github.com/usingkim")
                                .font(.body01)
                            Spacer()
                                
                        }
                    } label: {
                        Text("개발자 소개")
                            .font(.body01)
                    }
                }
                .font(.title05)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}


struct MailView : UIViewControllerRepresentable{
    
    var content: String
    var to: String
    var subject: String
    
    typealias UIViewControllerType = MFMailComposeViewController
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
        
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        if MFMailComposeViewController.canSendMail(){
            let view = MFMailComposeViewController()
            view.mailComposeDelegate = context.coordinator
            view.setToRecipients([to])
            view.setSubject(subject)
            view.setMessageBody(content, isHTML: false)
            return view
        } else {
            return MFMailComposeViewController()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    
    class Coordinator : NSObject, MFMailComposeViewControllerDelegate{
        
        var parent : MailView
        
        init(_ parent: MailView){
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
        
       
    }
}
