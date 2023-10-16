//
//  CreatePostPopoverView.swift
//  Lunar
//
//  Created by Mani on 21/08/2023.
//

import SFSafeSymbols
import SwiftUI

struct CreatePostPopoverView: View {
  @Binding var showingCreatePostPopover: Bool
  @State private var postBody: String = ""
  @State private var userInputBody: String = ""

  @State var postName: String = ""
  @State var userInputTitle: String = ""

  @State var postURL: String = ""
  @State var userInputURL: String = ""

  @State var photoPickerIsPresented = false
  @State var pickerResult: [UIImage] = []
  @State var showingImagePopover: Bool = false
  @State var showingImageUploadResult: Bool = false

  @State var responseMessage: String = ""
  @State var fileToken: String = ""
  @State var deleteToken: String = ""

  @State var siteMetadata = SiteMetadataObject(
    title: nil,
    description: nil,
    image: nil
  )

  @State var expandSiteMetadata: Bool = false

  @State var imageIsUploading: Bool = false

  @State var urlProtocolPrependTextColor: Color = .gray

  var communityID: Int
  var communityName: String
  var communityActorID: String

  var submittable: Bool {
    !userInputTitle.isEmpty && communityID != 0
  }

  let notificationHaptics = UINotificationFeedbackGenerator()

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
        URLInputView(siteMetadata: $siteMetadata, userInputURL: $userInputURL)
      } header: {
        Text("URL:")
          .textCase(.none)
      } footer: {
        URLInputFooterView(
          siteMetadata: $siteMetadata,
          expandSiteMetadata: $expandSiteMetadata
        )
      }
      .onDebouncedChange(of: $userInputURL, debounceFor: 1) { newValue in
        URLInputDebounceLogic(siteMetadata: $siteMetadata, userInputURL: $userInputURL, newValue: newValue).run()
      }

      // MARK: - Text Field

      Section {
        TextEditor(text: $userInputBody)
          .background(Color.clear)
          .font(.body)
          .frame(height: 150)
      } header: {
        Text("Body:")
          .textCase(.none)
      }

      // MARK: - Image

      Section {
        ImageUploaderView(
          photoPickerIsPresented: $photoPickerIsPresented,
          pickerResult: $pickerResult,
          showingImagePopover: $showingImagePopover,
          showingImageUploadResult: $showingImageUploadResult,
          imageIsUploading: $imageIsUploading,
          responseMessage: $responseMessage,
          fileToken: $fileToken,
          deleteToken: $deleteToken
        )
      } header: {
        Text("Image Uploader Coming Soon:")
          .textCase(.none)
      }

      // MARK: - Submit Button

      Section {
        Button {
          // MARK: - keep this

          postBody = userInputBody
          postName = userInputTitle
          postURL = userInputURL
          if !postURL.isEmpty {
            postURL = "https://\(postURL)"
          }
          if submittable {
            PostSender(
              communityID: communityID,
              postName: postName,
              postURL: postURL,
              postBody: postBody
            ).fetchPostSentResponse { response, postID in
              if response == "success" {
                notificationHaptics.notificationOccurred(.success)
                showingCreatePostPopover = false
                print("CREATED NEW POST: id=\(postID)")
              } else {
                notificationHaptics.notificationOccurred(.error)
                print("ERROR SUBMITTING POST")
              }
            }
          }
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
