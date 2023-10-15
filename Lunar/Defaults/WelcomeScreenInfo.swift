////
////  WelcomeScreenInfo.swift
////  Lunar
////
////  Created by Mani on 03/09/2023.
////
//
// import SwiftUI
//
// struct OnboardingInfo: Identifiable, Hashable {
//  var id = UUID()
//  var group: Int
//  var heading: String
//  var body: String
//  var systemImage: String
//  var color: Color? = Color.blue
// }
//
// class WelcomeScreenInfo {
//  var info: [[OnboardingInfo]] {
//    return [
//      introduction,
//      walkthrough,
//      lunar,
//      features
//    ]
//  }
//
//  var introduction: [OnboardingInfo] = [
//    // MARK: - 1.1
//
//    OnboardingInfo(
//      group: 1,
//      heading: "Thank you for joining the Lunar beta!",
//      body: """
//      Explore the world of Lemmy, communities, instances, and the Fediverse.
//      """,
//      systemImage: "hand.wave.fill",
//      color: .blue
//    ),
//
//    // MARK: - 1.2
//
//    OnboardingInfo(
//      group: 1,
//      heading: "What is Lemmy?",
//      body: """
//      Lemmy is an online platform where you can create and participate in communities centered around your interests and connect with people who share your hobbies.
//      """,
//      systemImage: "person.fill.questionmark",
//      color: .blue
//    )
//  ]
//
//  var walkthrough: [OnboardingInfo] = [
//    // MARK: - 2.1
//
//    OnboardingInfo(
//      group: 2,
//      heading: "The 'Fediverse' Analogy",
//      body: """
//      Imagine the Fediverse as our planet, with platforms (Lemmy, Kbin, Mastodon, Threads, and more) as the continents.
//      """,
//      systemImage: "globe.desk.fill",
//      color: .blue
//    ),
//
//    // MARK: - 2.2
//
//    OnboardingInfo(
//      group: 2,
//      heading: "Instances & Communities",
//      body: """
//      Each of these continents has many countries, which we refer to as 'Instances', each with its unique set of rules and cities, symbolising 'Communities'.
//      """,
//      systemImage: "building.2.fill",
//      color: .blue
//    ),
//
//    // MARK: - 2.3
//
//    OnboardingInfo(
//      group: 2,
//      heading: "Users & Accounts",
//      body: """
//      An account resides within a particular instance, but users have the freedom to engage with and become a part of communities from other instances as well.
//      """,
//      systemImage: "person.crop.circle.fill",
//      color: .blue
//    )
//  ]
//
//  var lunar: [OnboardingInfo] = [
//    // MARK: - 3.1
//
//    OnboardingInfo(
//      group: 3,
//      heading: "Lunar",
//      body: """
//      Lunar acts as an iOS client, allowing you to connect and interact with Lemmy and Kbin.
//
//      With Lunar, you can access the vibrant communities and discussions right from your iPhone or iPad.
//      """,
//      systemImage: "moonphase.waning.gibbous",
//      color: .blue
//    ),
//
//    // MARK: - 3.2
//
//    OnboardingInfo(
//      group: 3,
//      heading: "Features",
//      body: """
//      Here are some of the key features and functionalities that Lunar offers:
//
//      Secure Authentication using Keychain
//      Multi-Account, Multi-Instance
//      Community Discovery
//
//      """,
//      systemImage: "key.fill",
//      color: .blue
//    )
//  ]
//
//  var features: [OnboardingInfo] = [
//    // MARK: - 4.1
//
//    OnboardingInfo(
//      group: 4,
//      heading: "Streamlined User Interface",
//      body: """
//      Lunar is written in Swift and SwiftUI and provides a native interface iOS devices.
//      """,
//      systemImage: "speedometer",
//      color: .blue
//    ),
//
//    // MARK: - 4.2
//
//    OnboardingInfo(
//      group: 4,
//      heading: "Secure Authentication",
//      body: """
//      Login to the Fediverse securely. Lunar uses Apple Keychain, ensuring your data is protected.
//      """,
//      systemImage: "lock.iphone",
//      color: .red
//    ),
//
//    // MARK: - 4.3
//
//    OnboardingInfo(
//      group: 4,
//      heading: "Multi-Platform Access",
//      body: """
//      Currently Lunar supports Lemmy and Kbin, with more platforms coming soon.
//      """,
//      systemImage: "globe",
//      color: .green
//    ),
//
//    // MARK: - 4.4
//
//    OnboardingInfo(
//      group: 4,
//      heading: "Community Discovery",
//      body: """
//      Discover interesting and trending communities on the Explore Communities page.
//      """,
//      systemImage: "location",
//      color: .yellow
//    ),
//
//    // MARK: - 4.5
//
//    OnboardingInfo(
//      group: 4,
//      heading: "Open source",
//      body: """
//      The code for Lunar is available on Github and I welcome community involvement. If you'd like to contribute visit then github repo for more info.
//      """,
//      systemImage: "curlybraces",
//      color: .primary
//    ),
//
//    // MARK: - 4.6
//
//    OnboardingInfo(
//      group: 4,
//      heading: "Customization",
//      body: """
//      Being open source allows developers to customize Lunar to suit their needs or preferences.
//      """,
//      systemImage: "gearshape.2",
//      color: .purple
//    ),
//
//    // MARK: - 4.6
//
//    OnboardingInfo(
//      group: 4,
//      heading: "Regular Updates",
//      body: """
//      Lunar is still in early development but I'm committed to improving the app and adding new features regularly.
//
//      If you'd like to suggest features or improvements please visit the github repo:
//
//      github.com/mani-sh-reddy/Lunar
//      """,
//      systemImage: "square.and.arrow.down.on.square",
//      color: .brown
//    )
//  ]
// }
