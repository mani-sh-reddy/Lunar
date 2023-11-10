//
//  HiddenPostsGuardView.swift
//  Lunar
//
//  Created by Mani on 09/11/2023.
//

import RealmSwift
import SFSafeSymbols
import SwiftUI

struct HiddenPostsGuardView: View {
  @ObservedResults(RealmPost.self, where: ({ $0.postHidden })) var hiddenRealmPosts

  @StateObject var appContext = Biometrics()

  var body: some View {
    ZStack {
      if appContext.appUnlocked {
        PostsView(
          filteredPosts: hiddenRealmPosts.filter { post in post.postHidden },
          sort: "", /// Can set these to anything because nothing is being fetched here.
          type: "",
          user: 0,
          communityID: 0,
          personID: 0,
          filterKey: "",
          heading: "Hidden Posts"
        )
        .animation(.default, value: 5)
        .transition(.opacity)

      } else {
        FaceIDLoginView(appContext: appContext)
          .animation(.default, value: 1)
          .transition(.move(edge: .top))
      }
    }
  }
}

struct FaceIDLoginView: View {
  @ObservedObject var appContext: Biometrics

  var biometricType = CheckBiometricType.biometricType()

  var unlockPrompt: String {
    if biometricType == .face {
      "Unlock with Face ID"
    } else if biometricType == .touch {
      "Unlock with Touch ID"
    } else {
      "Unlock"
    }
  }

  var body: some View {
    VStack(spacing: 24) {
      Spacer()

      Button {
        appContext.requestBiometricUnlock()
      } label: {
        Label {
          Text(unlockPrompt)
        } icon: {
          Image(systemSymbol: .lock)
        }
        .font(.body)
        .padding(20)
        .padding(.horizontal, 5)
        .background(Color.secondary.opacity(0.3))
        .foregroundStyle(.foreground)
        .clipShape(Capsule())
      }

      Spacer()
    }
    .padding()
  }
}
