//
//  SettingsQuicklinksView.swift
//  Lunar
//
//  Created by Mani on 08/09/2023.
//

import Defaults
import Foundation
import SFSafeSymbols
import SwiftUI

struct SettingsQuicklinksView: View {
  @Default(.quicklinks) var quicklinks
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.enableQuicklinks) var enableQuicklinks
  @Default(.accentColor) var accentColor

  @Environment(\.colorScheme) var colorScheme

  @State var showingAddQuicklinkPopover = false
  @State var showingResetConfirmation = false
  @State var quicklinkTitle: String = ""
  @State var quicklinkSort: SortType = .active
  @State var quicklinkType: String = "All"
  @State var quicklinkIcon: String? = "circle.dashed"
  @State var quicklinkColorString: String = "007AFF"
  @State var quicklinkColor: Color = .blue
  @State var addQuicklinkErrorMessage: String = ""
  @State var showingAddQuicklinkErrorAlert: Bool = false

  let notificationHaptics = UINotificationFeedbackGenerator()
  let haptics = UIImpactFeedbackGenerator(style: .soft)
  var defaultQuicklinks: [Quicklink] = DefaultQuicklinks().getDefaultQuicklinks()
  var iconList: [String] = CircleFillIcons().iconsList()

  var body: some View {
    /// **Future implementation**
    //    DroppableList("Users 1", users: $users1) { dropped, index in
    //      users1.insert(dropped, at: index)
    //      users2.removeAll { $0 == dropped }
    //    }
    //    DroppableList("Users 2", users: $users2)  { dropped, index in
    //      users2.insert(dropped, at: index)
    //      users1.removeAll { $0 == dropped }
    //    }

    List {
      Section {
        Toggle(isOn: $enableQuicklinks) {
          Text("Enable Quicklinks")
        }
        .tint(accentColor)
      } header: {
        Text("Quicklinks")
      }
      footer: {
        Text("With QuickLinks off, you'll only see Local and Federated links. Use the picker in the toolbar to sort posts.")
      }
      if enableQuicklinks {
        Section {
          ForEach(quicklinks, id: \.self) { quicklink in
            GeneralCommunityQuicklinkButton(
              image: quicklink.icon,
              hexColor: quicklink.iconColor,
              title: quicklink.title,
              brightness: quicklink.brightness,
              saturation: quicklink.saturation,
              type: quicklink.type,
              sort: quicklink.sort
            )
          }
          .onDelete(perform: delete)
          Button {
            print(quicklinks)
            showingAddQuicklinkPopover = true
          } label: {
            Text("Add Quicklink")
              .foregroundStyle(.blue)
          }
        }
        Section {
          Button {
            showingResetConfirmation = true
          } label: {
            Text("Reset Quicklinks List")
              .foregroundStyle(.red)
          }
        }
        .confirmationDialog("Confirm Quicklinks List Reset", isPresented: $showingResetConfirmation) {
          Button("Reset", role: .destructive) {
            quicklinks = defaultQuicklinks
          }

          Button("Cancel", role: .cancel) {}
        }
      }
    }
    .toolbar {
      EditButton()
    }

    .sheet(isPresented: $showingAddQuicklinkPopover) {
      popover
    }
    .navigationTitle("Quicklinks")
    .navigationBarTitleDisplayMode(.inline)
  }

  var popover: some View {
    List {
      Section {
        TextField("Enter Quicklink Name", text: $quicklinkTitle)
      } header: {
        HStack {
          Spacer()
          Text("Create Quicklink").textCase(.none)
          Spacer()
        }
        .padding(.bottom, 10)
      }

      Section {
        ScrollView(.horizontal) {
          HStack(spacing: 10) {
            ForEach(iconList, id: \.self) { icon in
              ZStack {
                if icon == quicklinkIcon {
                  Image(systemSymbol: .circle)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(quicklinkColor)
                }
                Image(systemName: icon) /// Cannot use SFSafeSymbols due to @AppStorage
                  .resizable()
                  .frame(width: 60, height: 60)
                  .foregroundStyle(quicklinkColor)
                  .symbolRenderingMode(.hierarchical)
                  .brightness(colorScheme == .light ? -0.3 : 0.3)
                  .saturation(colorScheme == .light ? 2 : 2)
                  .onTapGesture {
                    haptics.impactOccurred(intensity: 0.6)
                    quicklinkIcon = icon
                  }
              }
            }
            .padding(.horizontal, 0)
            .padding(.bottom, 15)
          }
        }
        ColorPicker("Icon Color", selection: $quicklinkColor, supportsOpacity: false)
        if debugModeEnabled {
          Text("quicklinkColor.toHex: \(String(describing: quicklinkColor.toHex()))")
          Text("quicklinkColor: \(String(describing: quicklinkColor))")
          Text("quicklinkTitle: \(quicklinkTitle)")
          Text("quicklinkType: \(quicklinkType)")
          Text("quicklinkSort: \(quicklinkSort.rawValue)")
          Text("quicklinkIcon: \(quicklinkIcon ?? "")")
          Text("quicklinkColorString: \(quicklinkColorString)")
        }
      } header: {
        Text("Icon")
      }

      Section {}
        .onDebouncedChange(of: $quicklinkColor, debounceFor: 0.3) { _ in
          quicklinkColorString = quicklinkColor.toHex() ?? "007AFF"
        }

      Section {
        Picker("Post Type", selection: $quicklinkType) {
          Text("All").tag("All")
          Text("Local").tag("Local")
          Text("Subscribed").tag("Subscribed")
        }
        .pickerStyle(.menu)

        SortPicker(sortType: $quicklinkSort)
          .labelStyle(TitleOnlyLabelStyle())

//        Picker("Post Sort", selection: $quicklinkSort) {
//          Text("Active").tag("Active")
//          Text("Hot").tag("Hot")
//          Text("New").tag("New")
//          Text("Top Day").tag("TopDay")
//          Text("Top Week").tag("TopWeek")
//          Text("Top Month").tag("TopMonth")
//          Text("Top Year").tag("TopYear")
//          Text("Top All").tag("TopAll")
//          Text("Most Comments").tag("MostComments")
//          Text("New Comments").tag("NewComments")
//        }
//        .pickerStyle(.menu)
      } header: {
        Text("Type")
      }

      Section {
        GeneralCommunityQuicklinkButton(
          image: quicklinkIcon ?? "",
          hexColor: quicklinkColorString,
          title: quicklinkTitle.isEmpty ? "Title" : quicklinkTitle,
          brightness: 0.3,
          saturation: 2,
          type: quicklinkType,
          sort: quicklinkSort.rawValue
        )
      } header: {
        Text("Quicklink Preview")
      }
      .listRowBackground(Color(hex: quicklinkColorString)?.opacity(0.1))

      Section {
        Button {
          saveQuicklink()
        } label: {
          Text("Add Quicklink")
        }
      }
      .alert(addQuicklinkErrorMessage, isPresented: $showingAddQuicklinkErrorAlert) {
        Button("OK", role: .cancel) {}
      }
      DismissButtonView(dismisser: $showingAddQuicklinkPopover)
    }
  }

  func saveQuicklink() {
    guard let quicklinkIcon, !quicklinkIcon.isEmpty, quicklinkIcon != "circle.dashed" else {
      addQuicklinkErrorMessage = "Select an Icon"
      showingAddQuicklinkErrorAlert = true
      notificationHaptics.notificationOccurred(.error)
      return
    }

    guard !quicklinkTitle.isEmpty else {
      addQuicklinkErrorMessage = "Enter a Name"
      showingAddQuicklinkErrorAlert = true
      notificationHaptics.notificationOccurred(.error)
      return
    }

    quicklinks.append(
      Quicklink(
        title: quicklinkTitle,
        type: quicklinkType,
        sort: quicklinkSort.rawValue,
        icon: quicklinkIcon,
        iconColor: quicklinkColorString
      )
    )

    showingAddQuicklinkPopover = false
    notificationHaptics.notificationOccurred(.success)
  }

  func delete(at offsets: IndexSet) {
    quicklinks.remove(atOffsets: offsets)
  }
}

#Preview {
  SettingsQuicklinksView(showingAddQuicklinkPopover: true)
}
