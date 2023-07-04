//
//  ImageUploaderView.swift
//  Lunar
//
//  Created by Mani on 16/10/2023.
//

import Foundation

import SwiftUI

struct ImageUploaderView: View {
  @Binding var photoPickerIsPresented: Bool
  @Binding var pickerResult: [UIImage]
  @Binding var showingImagePopover: Bool
  @Binding var showingImageUploadResult: Bool
  @Binding var imageIsUploading: Bool
  @Binding var responseMessage: String
  @Binding var fileToken: String
  @Binding var deleteToken: String

  let haptics = UIImpactFeedbackGenerator(style: .rigid)
  let notificationHaptics = UINotificationFeedbackGenerator()

  var body: some View {
    HStack {
      Button {
        photoPickerIsPresented = true
      } label: {
        if !pickerResult.isEmpty {
          Label {
            Text("Select New Image")
              .padding(.horizontal, 5)
          } icon: {
            Image(uiImage: pickerResult[0])
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 40, height: 40)
              .padding(.horizontal, 10)
              .clipShape(Circle())
              .highPriorityGesture(
                TapGesture().onEnded {
                  showingImagePopover.toggle()
                }
              )
          }
        } else {
          Label {
            Text("Select Image")
              .padding(.horizontal, 5)
              .foregroundStyle(.gray)
          } icon: {
            Image(systemSymbol: .photoCircleFill)
              .symbolRenderingMode(.hierarchical)
              .resizable()
              .frame(width: 40, height: 40)
              .padding(.horizontal, 10)
              .foregroundStyle(.gray)
          }
        }
      }
      Spacer()
      if imageIsUploading {
        Image(systemSymbol: .ellipsis)
          .font(.title2)
          .foregroundStyle(.gray)
      } else {
        Text("Upload")
          .font(.caption)
          .foregroundStyle(.white)
          .padding(5)
          .padding(.horizontal, 4)
          .background(!pickerResult.isEmpty ? Color.blue : Color.secondary.opacity(0.5))
          .clipShape(Capsule())
          .highPriorityGesture(
            TapGesture().onEnded {
              guard !pickerResult.isEmpty else { return }
              haptics.impactOccurred(intensity: 0.5)
              withAnimation(.bouncy) {
                imageIsUploading = true
              }
              if !pickerResult.isEmpty {
                ImageSender(image: pickerResult[0]).uploadImage { responseMessage, fileToken, deleteToken in
                  imageIsUploading = false
                  self.responseMessage = responseMessage
                  self.fileToken = fileToken ?? ""
                  self.deleteToken = deleteToken ?? ""
                  showingImageUploadResult = true
                  if responseMessage == "ok" {
                    notificationHaptics.notificationOccurred(.success)
                  } else {
                    notificationHaptics.notificationOccurred(.error)
                  }
                  print("responseMessage: \(responseMessage)")
                  print("fileToken: \(String(describing: fileToken))")
                  print("deleteToken: \(String(describing: deleteToken))")
                }
              }
            }
          )
      }
    }
    .opacity(0.5)
    .overlay {
      ZStack {
        Rectangle().frame(width: 1000, height: 400)
          .foregroundStyle(Color.black).opacity(0.1)
//        Text("Coming Soon")
//          .font(.callout)
//          .rotationEffect(Angle(degrees: -10))
      }
    }
  }
}
