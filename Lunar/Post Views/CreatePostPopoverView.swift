//
//  CreatePostPopoverView.swift
//  Lunar
//
//  Created by Mani on 21/08/2023.
//

import NukeUI
import SFSafeSymbols
import SwiftUI

struct CreatePostPopoverView: View {
  @Binding var showingCreatePostPopover: Bool
  @State private var bodyString: String = ""
  @State private var bodyStringUnsent: String = ""

  @State var userInputURL: String = ""
  @State var userInputTitle: String = ""

  @State private var photoPickerIsPresented = false
  @State var pickerResult: [UIImage] = []
  @State private var showingImagePopover: Bool = false
  @State private var showingImageUploadResult: Bool = false

  @State private var responseMessage: String = ""
  @State private var fileToken: String = ""
  @State private var deleteToken: String = ""

  @State private var imageIsUploading: Bool = false

  let haptics = UIImpactFeedbackGenerator(style: .rigid)
  let notificationHaptics = UINotificationFeedbackGenerator()

  var communityID: Int
  var communityName: String
  var communityActorID: String

  var body: some View {
    List {
      // MARK: - Posting to

      Section {
        VStack(alignment: .leading) {
          Text(communityName)
            .font(.headline)
          Text("@\(URLParser.extractDomain(from: communityActorID))")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
      } header: {
        Text("Posting to:")
          .textCase(.none)
      }
      .listRowSeparator(.hidden)
      .listRowBackground(Color.clear)

      // MARK: - Title

      Section {
        TextField(text: $userInputTitle) {
          Text("required").italic()
            .foregroundStyle(.red.opacity(0.3))
        }
      } header: {
        Text("Title:")
          .textCase(.none)
      }

      // MARK: - URL

      Section {
        TextField(text: $userInputURL) {
          Text("optional").italic()
        }
        .keyboardType(.URL)
        .font(.body)
      } header: {
        Text("URL:")
          .textCase(.none)
      }

      // MARK: - Image

      Section {
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
              } icon: {
                Image(systemSymbol: .photoCircleFill)
                  .symbolRenderingMode(.hierarchical)
                  .resizable()
                  .frame(width: 40, height: 40)
                  .padding(.horizontal, 10)
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
      } header: {
        Text("Image:")
          .textCase(.none)
      }

      // MARK: - Text Field

      Section {
        TextEditor(text: $bodyStringUnsent)
          .background(Color.clear)
          .font(.body)
          .frame(height: 150)
      } header: {
        Text("Body:")
          .textCase(.none)
      }

      // MARK: - Submit Button

      Section {
        Button {
          // MARK: - keep this

//          bodyString = bodyStringUnsent
//          if !bodyString.isEmpty {
//            CommentSender(
//              content: commentString,
//              postID: post.id,
//              parentID: comment?.id
//            ).fetchCommentResponse { response in
//              if response == "success" {
//                showingCommentPopover = false
//                commentsFetcher.loadContent(isRefreshing: true)
//              } else {
//                print("ERROR SENDING COMMENT")
//              }
//            }
//          }
        } label: {
          HStack {
            Spacer()
            Text("Submit")
            Spacer()
          }
        }
      }
      DismissButtonView(dismisser: $showingCreatePostPopover)
    }
    .listStyle(.insetGrouped)
    .popover(isPresented: $photoPickerIsPresented) {
      PhotoPicker(
        pickerResult: $pickerResult,
        isPresented: $photoPickerIsPresented
      )
    }
    .popover(isPresented: $showingImagePopover) {
      LocalImagePopoverView(showingImagePopover: $showingImagePopover, image: pickerResult[0])
    }
    .alert("Uploaded Image Response", isPresented: $showingImageUploadResult) {
      VStack {
        Text("responseMessage: \(responseMessage)")
        Text("fileToken: \(fileToken)")
        Text("deleteToken: \(deleteToken)")
      }

      Button("OK", role: .cancel) {}
    }
    .onChange(of: pickerResult) { _ in
      print(pickerResult)
    }
  }
}

struct CreatePostPopoverView_Previews: PreviewProvider {
  static var previews: some View {
    CreatePostPopoverView(showingCreatePostPopover: .constant(true), communityID: 234_309, communityName: "API Testing Pls Ignore", communityActorID: "https://lemmy.world/c/api_testing_pls_ignore")
  }
}
