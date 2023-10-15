//
//  PlaceholderView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import BetterSafariView
import SwiftUI

struct PlaceholderView: View {
  @State var showSafari: Bool = false
  @State var currentPlaceholderSentence = PlaceholderSentences.shared.getPlaceholderSentence()

  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
//        Image(systemSymbol: .exclamationmarkTriangleFill)
//          .imageScale(.medium)
//          .foregroundColor(.secondary)
//          .frame(maxWidth: .infinity, alignment: .leading)
//          .clipped()
//          .font(.title3)
//          .padding(.bottom)
        Text(currentPlaceholderSentence)
          .font(.subheadline)
          .fixedSize(horizontal: false, vertical: true)
          .lineSpacing(1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .clipped()
      }
      .padding()
      HStack {
        VStack(alignment: .leading) {
          Text("Follow the progress here:")
            .italic().bold()
            .font(.headline)
          Text("github.com/mani-sh-reddy/Lunar")
            .foregroundColor(.secondary)
            .font(.footnote)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipped()
        Image(asset: "AppIconLight")
          .renderingMode(.original)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 32)
          .clipped()
          .mask { RoundedRectangle(cornerRadius: 8, style: .continuous) }
      }
      .padding(.horizontal)
      .padding(.vertical, 10)
      .background {
        RoundedRectangle(cornerRadius: 0, style: .continuous)
          .fill(Color(.systemGray5))
      }
    }
    .frame(width: 300)
    .clipped()
    .background { Rectangle().fill(Color(.systemGray6)) }
    .mask { RoundedRectangle(cornerRadius: 16, style: .continuous) }
    .onTapGesture { showSafari.toggle() }
    .onAppear {
      // Change the displayed sentence every time the view appears
      currentPlaceholderSentence = PlaceholderSentences.shared.getPlaceholderSentence()
    }
    .inAppSafari(
      isPresented: $showSafari,
      stringURL: "https://github.com/users/mani-sh-reddy/projects/3/views/5"
    )
  }
}

class PlaceholderSentences {
  static let shared = PlaceholderSentences()

  private let sentences: [String] = [
    "Stay tuned for something amazing.",
    "Under construction but not for long.",
    "Baking up something special for you.",
    "Work in progress – exciting things ahead.",
    "We're renovating this space.",
    "Preparing something awesome!",
    "Be patient, great things are coming.",
    "Check back soon for updates.",
    "Creating magic behind the scenes.",
    "The future is just around the corner.",
    "Hold tight, big things are brewing.",
    "Watch this space for something new.",
    "Something cool is in the works.",
    "Don't blink, you might miss it.",
    "Our surprise is on the way.",
    "Wait for it...something incredible!",
    "The countdown begins now.",
    "Exciting changes are underway.",
    "We're making things happen.",
    "Revamping for your delight.",
    "Stay patient, stay excited!",
    "Something awesome is loading.",
    "Our team is hard at work.",
    "It's not ready yet, but it will be.",
    "Greatness is in the making.",
    "Change is in the air.",
    "Coming soon to a screen near you.",
    "Anticipate something wonderful.",
    "Unlock the mystery soon.",
    "The best is yet to come.",
    "Stay curious, stay excited.",
    "Something big is in progress.",
    "Patience is a virtue.",
    "Refresh for updates.",
    "The future is unfolding.",
    "Stay tuned for the grand reveal.",
    "Exciting times are ahead.",
    "Adventure awaits you here.",
    "Don't leave – surprises coming.",
    "Change is on the horizon.",
    "Hold your breath, it's coming.",
    "The future looks bright.",
    "Watch this space closely.",
    "Something epic is brewing.",
    "We're crafting something amazing.",
    "Excitement is on the way.",
    "Something beautiful is coming.",
    "Keep your eyes on this space.",
    "The countdown is on!",
    "A surprise is in the making.",
    "We're cooking up something good.",
    "Stay tuned for the magic.",
    "Adventure begins soon.",
    "This space is transforming.",
    "Greatness is in progress.",
    "Stay curious, stay patient.",
    "Something special is brewing.",
    "Anticipate the extraordinary.",
    "Change is in motion.",
    "Prepare for something amazing.",
    "The future is taking shape.",
    "The grand reveal is coming.",
    "Brace yourself for excitement.",
    "Big things are happening.",
    "New experiences await you.",
    "We're on the move.",
    "Stay excited, stay curious.",
    "Something spectacular is near.",
    "The best is yet to come.",
    "Stay with us for more.",
    "Patience is a virtue.",
    "Refresh for the latest.",
    "The future is unfolding.",
    "A new world is emerging.",
    "Stay tuned for the unveil.",
    "Exciting times lie ahead.",
    "Adventure awaits, stay put.",
    "Don't miss what's coming.",
    "Change is on its way.",
    "Hold tight for greatness.",
    "The countdown has begun.",
    "A surprise is brewing.",
    "Cooking up something special.",
    "Expect excitement soon.",
    "Something beautiful is brewing.",
    "Keep a close watch here.",
    "The clock is ticking!",
    "The future is under construction.",
    "We're crafting magic.",
    "Excitement is on the horizon.",
    "Something extraordinary awaits.",
    "Anticipate great things.",
    "Change is in the air.",
    "Prepare for greatness.",
    "The future is getting closer.",
    "The grand reveal approaches.",
    "Get ready for excitement.",
    "Big things are coming.",
    "New experiences on the horizon.",
    "Stay with us for updates.",
  ]

  func getPlaceholderSentence() -> String {
    if let randomSentence = sentences.randomElement() {
      randomSentence
    } else {
      "No placeholder sentences available."
    }
  }
}
