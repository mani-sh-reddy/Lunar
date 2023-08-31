//
//  WelcomeScreenView.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import SwiftUI

struct OnboardingCard: Identifiable, Hashable {
  var id = UUID()
  var title: String
  var description: String
  var image: String
  var imageColor: Color
}

struct WelcomeScreenView: View {

  var onboardingCards: [OnboardingCard] = [
    OnboardingCard(
      title: "Welcome to Lunar",
      description: """
        _An iOS client for Lemmy_

        Thanks for trying out Lunar's early beta version! Keep track of the progress on the [Project Board](https://github.com/users/mani-sh-reddy/projects/3)

        If you find any bugs, please let me know on the [Issues Page](https://github.com/mani-sh-reddy/Lunar/issues) or at [lemmy.world/c/lunar](lemmy.world/c/lunar)

        Show your support by starring the [GitHub repo](https://github.com/mani-sh-reddy/Lunar).

        **Your help is greatly appreciated!**

        """,
      image: "",
      imageColor: .teal
    ),
    OnboardingCard(
      title: "What's Lemmy?",
      description: """
        Lemmy is a platform where people can post and discuss links, text, and images in different communities.

        You can pick one that fits your interests, _c/retrogaming_ or just a generic one, _c/world_
        """,
      image: "bubble.left.and.bubble.right.fill",
      imageColor: .purple
    ),
    OnboardingCard(
      title: "Instances",
      description: """
        There are many different instances hosted across the world.

        Your account lives in the instance you select but you can still interact people from other instances, all thanks to the ActivityPub protocol.
        """,
      image: "INSTANCES",
      imageColor: .teal
    ),
    OnboardingCard(
      title: "Login",
      description: """
        Login to get started
        """,
      image: "rectangle.and.pencil.and.ellipsis",
      imageColor: .orange
    ),
  ]
  
  @AppStorage("showWelcomeScreen") var showWelcomeScreen = Settings.showWelcomeScreen
  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    ZStack(alignment: .topTrailing){
      Button{
        haptics.impactOccurred(intensity: 0.5)
        showWelcomeScreen = false
      }label: {
        Image(systemName: "xmark.circle.fill")
          .resizable()
          .frame(width: 40, height: 40)
          .foregroundStyle(.ultraThickMaterial)
      }
      .padding(.top, 0)
      .padding(.trailing, 30)
      TabView {
        ForEach(Array(onboardingCards.enumerated()), id: \.element) { index, element in
          OnboardingCardView(card: element, index: index, lastIndex: (onboardingCards.count - 1))
        }
        
        ForEach(onboardingCards, id: \.id) { card in
        }
      }
      .tabViewStyle(.page)
      .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
      .padding(.vertical, 20)
    }
  }
}

struct OnboardingCardView: View {
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @AppStorage("showWelcomeScreen") var showWelcomeScreen = Settings.showWelcomeScreen

  @State private var isAnimating = false

  var card: OnboardingCard
  let haptics = UIImpactFeedbackGenerator(style: .soft)

  let index: Int
  let lastIndex: Int

  var body: some View {
    VStack(spacing: 10) {
      Spacer().frame(height: 50)

      if card.image.isEmpty {
        Image(asset: "LunarLogo")
          .resizable()
          .scaledToFit()
          .frame(width: 200)
          .foregroundStyle(card.imageColor)
          .symbolRenderingMode(.hierarchical)
          .padding(.top, -40)
      } else if card.image == "INSTANCES" {
        ZStack {
          //          RoundedRectangle(cornerRadius: 20, style: .continuous)
          //            .foregroundStyle(.ultraThickMaterial)
          ScrollView {
            InstanceRowView(instanceURL: "lemmy.world", flag: "W")
            InstanceRowView(instanceURL: "beehaw.org", flag: "US")
            InstanceRowView(instanceURL: "programming.dev", flag: "W")
            InstanceRowView(instanceURL: "discuss.tchncs.de", flag: "DE")
            InstanceRowView(instanceURL: "feddit.uk", flag: "GB")
            InstanceRowView(instanceURL: "feddit.de", flag: "DE")
            InstanceRowView(instanceURL: "lemmy.ca", flag: "CA")
            InstanceRowView(instanceURL: "lemmy.dbzer0.com", flag: "SE")
            InstanceRowView(instanceURL: "reddthat.com", flag: "W")
            InstanceRowView(instanceURL: "lemm.ee", flag: "W")
          }
          .background(.foreground.opacity(0.1))
          .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        }
        .padding()
        .frame(height: 380)
        .padding(.top, -40)
      } else {
        Image(systemName: card.image)
          .resizable()
          .scaledToFit()
          .frame(width: 150)
          .foregroundStyle(card.imageColor)
          .symbolRenderingMode(.hierarchical)
      }

      Spacer().frame(height: 5)

      Text(card.title)
        .fontWeight(.bold)
        .font(.largeTitle)
        .padding(.horizontal, 30)
        .padding(.vertical, 10)

      ScrollView {
        Text(LocalizedStringKey(card.description))
          .multilineTextAlignment(.leading)
          .padding(.horizontal, 30)
      }

      Spacer()

      if index == lastIndex {
        HStack {
          ReactionButton(
            text: "Login",
            icon: "lock.circle.fill",
            color: .orange,
            iconSize: .title,
            active: .constant(false),
            opposite: .constant(false)
          )
          .highPriorityGesture(
            TapGesture().onEnded {
              haptics.impactOccurred(intensity: 0.5)
              showWelcomeScreen = false
              let _ = LoginView(
                showingPopover: .constant(false), isLoginFlowComplete: .constant(false))
            }
          )
          ReactionButton(
            text: "Just Browse",
            icon: "arrow.right.circle.fill",
            color: .blue,
            iconSize: .title,
            active: .constant(false),
            opposite: .constant(false)
          )
          .highPriorityGesture(
            TapGesture().onEnded {
              haptics.impactOccurred(intensity: 0.5)
              showWelcomeScreen = false
            }
          )
        }
        .padding(.bottom, 80)
      }
    }
  }
}

struct InstanceRowView: View {
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled

  var instanceURL: String
  var flag: String

  var body: some View {
    ZStack(alignment: .leading) {
      RoundedRectangle(cornerRadius: 10, style: .continuous)
        .foregroundStyle(.thinMaterial)
      HStack {
        Image(asset: "LemmyInstances/\(instanceURL)")
          .resizable()
          .scaledToFit()
          .frame(width: 30, height: 30)
          .padding(10)
        Text(instanceURL)
        Spacer()
        Image(asset: "Flags/\(flag)")
          .resizable()
          .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
          .scaledToFit()
          .frame(width: 30, height: 30)
          .padding(10)
      }
    }
    .frame(height: 50)
    .padding(.horizontal, 20)
    .padding(.top, 2)
  }
}

struct WelcomeScreenView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeScreenView()
  }
}
