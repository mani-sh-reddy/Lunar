//
//  CreatePostPopoverView.swift
//  Lunar
//
//  Created by Mani on 21/08/2023.
//

import Defaults
import SFSafeSymbols
import SwiftUI

struct CreatePostPopoverView: View {
  @Default(.activeAccount) var activeAccount

//  @Environment(\.dismiss) var dismiss

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
  @Binding var showingCreatePostPopover: Bool

  var communityID: Int
  var communityName: String
  var communityActorID: String

  var submittable: Bool {
    !userInputTitle.isEmpty && communityID != 0
  }

  let notificationHaptics = UINotificationFeedbackGenerator()

  var body: some View {
    List {
      createPostHeading
      if activeAccount.userID.isEmpty {
        notLoggedInWarning
      } else {
        postingToSection
        postingAsSection
        titleField
        URLField
        bodyField
        imageUploaderSection
        submitButtonSection
      }
    }
    .listStyle(.insetGrouped)
    .popover(isPresented: $photoPickerIsPresented) {
      PhotoPicker(
        pickerResult: $pickerResult,
        isPresented: $photoPickerIsPresented
      )
    }
    .popover(isPresented: $showingImagePopover) {
      LocalImagePopoverView(
        showingImagePopover: $showingImagePopover,
        image: pickerResult[0]
      )
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

  var notLoggedInWarning: some View {
    HStack {
      Spacer()
      VStack {
        Image(systemSymbol: .personCropCircleBadgeExclamationmarkFill)
          .resizable()
          .scaledToFit()
          .frame(width: 100)
          .padding(30)
          .symbolRenderingMode(.palette)
          .foregroundStyle(.yellow, .secondary)
        Text("Login to Create Post")
          .bold()
          .font(.title2)
          .foregroundStyle(.secondary)
      }
      Spacer()
    }
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }

  var postingToSection: some View {
    Section {
      VStack(alignment: .leading) {
        HStack(spacing: 1) {
          Text(communityName)
            .bold()
          Text("@\(URLParser.extractDomain(from: communityActorID))")
            .foregroundStyle(.secondary)
        }
      }
    } header: {
      Text("Posting to:")
        .textCase(.none)
    }
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }

  var postingAsSection: some View {
    Section {
      VStack(alignment: .leading) {
        HStack(spacing: 1) {
          Text(activeAccount.name)
            .bold()
          Text("@\(URLParser.extractDomain(from: activeAccount.actorID))")
            .foregroundStyle(.secondary)
        }
      }
    } header: {
      Text("Posting as:")
        .textCase(.none)
    }
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }

  var createPostHeading: some View {
    Section {
      HStack {
        Text("Create Post")
          .font(.title)
          .bold()
        Spacer()
        Button {
          showingCreatePostPopover = false
        } label: {
          Image(systemSymbol: .xmarkCircleFill)
            .font(.largeTitle)
            .foregroundStyle(.secondary)
            .saturation(0)
        }
      }
    }
    .listRowBackground(Color.clear)
  }

  var titleField: some View {
    Section {
      TextField(text: $userInputTitle) {
        Text("required").italic()
          .foregroundStyle(.red.opacity(0.3))
      }
    } header: {
      Text("Title:")
        .textCase(.none)
    }
  }

  var URLField: some View {
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
  }

  var bodyField: some View {
    Section {
      TextEditor(text: $userInputBody)
        .background(Color.clear)
        .font(.body)
        .frame(height: 150)
    } header: {
      Text("Body:")
        .textCase(.none)
    }
  }

  var imageUploaderSection: some View {
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
  }

  var submitButtonSection: some View {
    Section {
      Button {
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
          Text(submittable ? "Post" : "Complete required fields to post")
            .foregroundStyle(submittable ? .blue : .secondary)
          Spacer()
        }
      }
    }
  }
}

#Preview {
  CreatePostPopoverView(
    showingCreatePostPopover: .constant(true),
    communityID: 234_309,
    communityName: "API Testing Pls Ignore",
    communityActorID: "https://lemmy.world/c/api_testing_pls_ignore"
  )
}
