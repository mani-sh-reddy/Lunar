//
//  CustomiseFeedQuicklinksView.swift
//  Lunar
//
//  Created by Mani on 08/09/2023.
//

import Foundation
import SwiftUI

struct CustomiseFeedQuicklinksView: View {
  @AppStorage("quicklinks") var quicklinks = Settings.quicklinks
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  
  @State var showingAddQuicklinkPopover = false
  @State var showingResetConfirmation = false
  
  @State var quicklinkTitle: String = ""
  @State var quicklinkSort: String = "Active"
  @State var quicklinkType: String = "All"
  @State var quicklinkIcon: String? = ""
  @State var quicklinkColorString: String = "007AFF"
  @State var quicklinkColor: Color = .blue
  
  @State var addQuicklinkErrorMessage: String = ""
  @State var showingAddQuicklinkErrorAlert: Bool = false
  
  let notificationHaptics = UINotificationFeedbackGenerator()
  let haptics = UIImpactFeedbackGenerator(style: .soft)

  
  let colorConverter = ColorConverter()
  
  var defaultQuicklinks: [Quicklink] = [
    Quicklink(
      title: "Local", type: "Local", sort: "Active", icon: "house.circle.fill", iconColor: "green"
    ),
    Quicklink(
      title: "All", type: "All", sort: "Active", icon: "building.2.crop.circle.fill",
      iconColor: "cyan"
    ),
    Quicklink(
      title: "Top", type: "All", sort: "TopWeek", icon: "chart.line.uptrend.xyaxis.circle.fill",
      iconColor: "pink"
    ),
    Quicklink(
      title: "New", type: "All", sort: "New", icon: "star.circle.fill", iconColor: "yellow"
    ),
  ]
  
  var iconList: [String] = ["mountain.2.circle.fill", "camera.macro.circle.fill"]
  
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
        ForEach(defaultQuicklinks, id: \.self) { quicklink in
          HStack {
            Image(systemName: quicklink.icon)
              .resizable()
              .frame(width: 30, height: 30)
              .symbolRenderingMode(.hierarchical)
              .foregroundStyle(
                colorConverter.convertStringToColor(quicklink.iconColor)
              )
            Text(quicklink.title)
              .padding(.horizontal, 10)
          }
        }
        .onDelete(perform: delete)
        
        Button {
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
          withAnimation {
            quicklinks = defaultQuicklinks
          }
        }
        
        Button("Cancel", role: .cancel) {}
      }
    }
    .toolbar {
      EditButton()
    }
    
    .popover(isPresented: $showingAddQuicklinkPopover) {
      popover
    }
  }
  
  var popover: some View {
    //  title: "Local", type: "Local", sort: "Active", icon: "house.circle.fill", iconColor: "green"
    List {
      Section {
              HStack {
                Image(systemName: quicklinkIcon ?? "")
                  .resizable()
                  .frame(width: 30, height: 30)
                  .symbolRenderingMode(.hierarchical)
                  .foregroundStyle(colorConverter.convertStringToColor(quicklinkColorString))
                Text(quicklinkTitle)
                  .padding(.horizontal, 10)
              }
      }

      Section {
        TextField("Quicklink Name", text: $quicklinkTitle)
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
                  Image(systemName: "circle")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundStyle(quicklinkColor)
                }
                Image(systemName: icon)
                  .resizable()
                  .frame(width: 60, height: 60)
                  .foregroundStyle(quicklinkColor)
                  .symbolRenderingMode(.hierarchical)
                  .onTapGesture {
                    haptics.impactOccurred(intensity: 0.6)
                    quicklinkIcon = icon
                  }
              }
            }
          }
        }
      }
      
      Section {
        ColorPicker("Icon Color", selection: $quicklinkColor, supportsOpacity: false)
        if debugModeEnabled {
          Text(String(describing: quicklinkColor.toHex()))
          Text(String(describing: quicklinkColor))
        }
      }
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
        
        Picker("Post Sort", selection: $quicklinkSort) {
          Text("Active").tag("Active")
          Text("Hot").tag("Hot")
          Text("New").tag("New")
          Text("Top Day").tag("TopDay")
          Text("Top Week").tag("TopWeek")
          Text("Top Month").tag("TopMonth")
          Text("Top Year").tag("TopYear")
          Text("Top All").tag("TopAll")
          Text("Most Comments").tag("MostComments")
          Text("New Comments").tag("NewComments")
        }
        .pickerStyle(.menu)
      }
      
      Section {
        Button {
          saveQuicklink()
        } label: {
          Text("Save Quicklink")
        }
      }
      Section {
        HStack {
          Spacer()
          SmallNavButton(systemImage: "arrow.down.to.line", text: "Dismiss", color: .red, symbolLocation: .left)
            .onTapGesture {
              showingAddQuicklinkPopover = false
            }
          Spacer()
        }
      }
      .listRowBackground(Color.clear)
      .alert(addQuicklinkErrorMessage, isPresented: $showingAddQuicklinkErrorAlert) {
        Button("OK", role: .cancel) {}
      }
    }
  }
  
  func saveQuicklink() {
    guard let quicklinkIcon = quicklinkIcon, !quicklinkIcon.isEmpty else {
      notificationHaptics.notificationOccurred(.error)
      addQuicklinkErrorMessage = "Select an Icon"
      showingAddQuicklinkErrorAlert = true
      return
    }
    
    guard !quicklinkTitle.isEmpty else {
      notificationHaptics.notificationOccurred(.error)
      addQuicklinkErrorMessage = "Enter a Name"
      showingAddQuicklinkErrorAlert = true
      return
    }
    
    quicklinks.append(
      Quicklink(
        title: quicklinkTitle,
        type: quicklinkType,
        sort: quicklinkSort,
        icon: quicklinkIcon,
        iconColor: quicklinkColorString
      )
    )
    
    notificationHaptics.notificationOccurred(.success)
    showingAddQuicklinkPopover = false
  }
    
  func delete(at offsets: IndexSet) {
    quicklinks.remove(atOffsets: offsets)
  }
}

struct CustomiseFeedQuicklinksView_Previews: PreviewProvider {
  static var previews: some View {
    CustomiseFeedQuicklinksView(showingAddQuicklinkPopover: true)
  }
}
