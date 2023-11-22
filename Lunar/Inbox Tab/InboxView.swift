//
//  InboxView.swift
//  Lunar
//
//  Created by Mani on 22/11/2023.
//

import Defaults
import Foundation
import MarkdownUI
import NukeUI
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct InboxView: View {
  @Default(.activeAccount) var activeAccount
  @Default(.loggedInAccounts) var loggedInAccounts
  @Default(.privateMessagesRetrieved) var privateMessagesRetrieved

  @ObservedResults(RealmPrivateMessage.self) var messages

  var body: some View {
    NavigationView {
      List {
        if messages.count == 0 {
          Text("No messages found")
            .listRowBackground(Color.clear)
        } else {
          Section {
            ForEach(messages, id: \.messageID) { message in
              if message.creatorActorID != activeAccount.actorID {
                MessageItem(message: message)
              }
            }
          } header: {
            Text("Received")
          }
          Section {
            ForEach(messages, id: \.messageID) { message in
              if message.creatorActorID == activeAccount.actorID {
                MessageItem(message: message)
              }
            }
          } header: {
            Text("Sent")
          }
        }
      }
      .listStyle(.insetGrouped)
      .navigationTitle("Inbox")
      .onAppear {
        guard !privateMessagesRetrieved else { return }
        reloadMessages()
      }
      .refreshable {
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
//        clearMessages()
        reloadMessages()
      }
      .onChange(of: activeAccount) { _ in
        clearMessages()
        reloadMessages()
      }
    }
  }

  func reloadMessages() {
    PrivateMessageFetcher(instance: URLParser.extractDomain(from: activeAccount.actorID)).loadContent()
    privateMessagesRetrieved = true
  }

  func clearMessages() {
    let realm = try! Realm()
    try! realm.write {
      let messages = realm.objects(RealmPrivateMessage.self)
      realm.delete(messages)
    }
    privateMessagesRetrieved = false
  }
}

enum messageDirection {
  case incoming
  case outgoing
}

struct MessageItem: View {
  @Default(.activeAccount) var activeAccount

  @ObservedRealmObject var message: RealmPrivateMessage

  let haptics = UIImpactFeedbackGenerator(style: .rigid)

  var messageDirection: messageDirection {
    message.creatorActorID == activeAccount.actorID ? .outgoing : .incoming
  }

  var fromTo: String {
    messageDirection == .incoming ? "from" : "to"
  }

  var name: String {
    messageDirection == .incoming ? message.creatorName : message.recipientName
  }

  var actorID: String {
    messageDirection == .incoming ? message.creatorActorID : message.recipientActorID
  }

  var avatar: String {
    messageDirection == .incoming ? message.creatorAvatar : message.recipientAvatar
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack(alignment: .center) {
//        fromToLabel
        fromAvatar
        header
        Spacer()
      }
      messageBody
      timeAgoHeader
    }
  }

//
//  var fromToLabel: some View {
//    Text()
//      .foregroundStyle(.secondary)
//  }

  var header: some View {
    HStack(alignment: .firstTextBaseline, spacing: 1) {
      Text("\(name)")
        .textCase(.uppercase)
        .fixedSize()

      Text("@\(URLParser.extractDomain(from: actorID))")
        .foregroundStyle(.secondary)
    }
    .lineLimit(1)
    .font(.caption)
  }

  var timeAgoHeader: some View {
    Text("\(message.messageTimeAgo) ago")
      .font(.caption)
      .foregroundStyle(.secondary)
  }

  @ViewBuilder
  var fromAvatar: some View {
    LazyImage(url: URL(string: avatar)) { state in
      if let image = state.image {
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(Circle())
      } else {
        Image(systemSymbol: .personCircleFill)
          .resizable()
          .symbolRenderingMode(.hierarchical)
      }
    }
    .processors([.resize(width: 50)])

    .frame(width: 20, height: 20)
    .transition(.opacity)
  }

  var messageBody: some View {
    Markdown { message.messageContent }
      .padding(.bottom, 2)
  }
}

//  @ViewBuilder
//  var actionButtons: some View {
//    ReactionButton(
//      icon: SFSafeSymbols.SFSymbol.checkmarkCircleFill,
//      color: Color.blue,
//      active: $message.messageRead.not,
//      opposite: .constant(false)
//    )
//    .hapticFeedbackOnTap(style: .rigid)
//
//    ReactionButton(
//      icon: SFSafeSymbols.SFSymbol.flagCircleFill,
//      color: Color.red,
//      active: $message.messageRead.not,
//      opposite: .constant(false)
//    )
//    .hapticFeedbackOnTap(style: .rigid)
//
//    ReactionButton(
//      icon: SFSafeSymbols.SFSymbol.arrowshapeTurnUpLeftCircleFill,
//      color: Color.orange,
//      active: $message.messageRead.not,
//      opposite: .constant(false)
//    )
//    .hapticFeedbackOnTap(style: .rigid)
//
//    ReactionButton(
//      icon: SFSafeSymbols.SFSymbol.docCircleFill,
//      color: Color.gray,
//      active: $message.messageRead.not,
//      opposite: .constant(false)
//    )
//    .hapticFeedbackOnTap(style: .rigid)
//  }

struct MessageItem_Previews: PreviewProvider {
  static var previews: some View {
    MessageItem(message: RealmPrivateMessage(
      messageID: 123,
      messageContent: "Hello, this is a placeholder message.",
      messageDeleted: false,
      messageRead: true,
      messagePublished: "2023-09-15T16:11:33.739267",
      messageApID: "abc123",
      messageIsLocal: true,
      creatorID: 456,
      creatorName: "John Doe",
      creatorAvatar: "https://example.com/john_avatar.jpg",
      creatorActorID: "https://lemmy.world/u/mani",
      recipientID: 789,
      recipientName: "Jane Smith",
      recipientAvatar: "https://example.com/jane_avatar.jpg",
      recipientActorID: "actor456"
    ))
    .previewLayout(.sizeThatFits)
  }
}
