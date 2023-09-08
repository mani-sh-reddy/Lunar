//
//  ManageInstancesView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Alamofire
import SwiftUI

struct ManageInstancesView: View {
  @AppStorage("lemmyInstances") var lemmyInstances = Settings.lemmyInstances
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled

  @State var enteredCustomInstance = ""
  @State var showingAddInstanceAlert = false
  @State var showingInvalidInstanceError = false
  @State var showingAlreadyExistsError = false
  @State var showingResetConfirmation = false

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
      if debugModeEnabled {
        Text(String(describing: lemmyInstances))
      }
      Section {
        ForEach(lemmyInstances, id: \.self) { instance in
          Text(instance)
        }
        .onDelete(perform: delete)

        Button {
          showingAddInstanceAlert = true
        } label: {
          Text("Add Instance")
            .foregroundStyle(.blue)
        }
      }
      Section {
        Button {
          showingResetConfirmation = true
        } label: {
          Text("Reset Instance List")
            .foregroundStyle(.red)
        }
      }
      .confirmationDialog("Are you sure?", isPresented: $showingResetConfirmation) {
        Button("Reset", role: .destructive) {
          withAnimation {
            lemmyInstances = [
              "lemmy.world",
              "lemmy.ml",
              "beehaw.org",
              "programming.dev",
              "lemm.ee",
            ]
            selectedInstance = "lemmy.world"
          }
        }

        Button("Cancel", role: .cancel) {}
      }
    }
    .alert("Add custom instance", isPresented: $showingAddInstanceAlert) {
      TextField("lemmy.world", text: $enteredCustomInstance)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .keyboardType(.emailAddress)
      Button("Add", role: .none) {
        if !enteredCustomInstance.isEmpty {
          checkInstanceValidity()
        }
      }
      Button("Dismiss", role: .cancel) {}
    }
    .alert(
      "Instance \(enteredCustomInstance) already exists",
      isPresented: $showingAlreadyExistsError
    ) {
      Button("Dismiss", role: .cancel) {}
    }
    .alert(
      "Instance \(enteredCustomInstance) seems invalid",
      isPresented: $showingInvalidInstanceError
    ) {
      Button("Add anyway", role: .none) {
        selectedInstance = enteredCustomInstance
        lemmyInstances.append(enteredCustomInstance)
      }
      Button("Dismiss", role: .cancel) {}
    }

    .toolbar {
      EditButton()
    }
  }

  func checkInstanceValidity() {
    if !lemmyInstances.contains(enteredCustomInstance) {
      AF.request("https://\(enteredCustomInstance)/api/v3/site").response { response in
        if 200 ..< 300 ~= response.response?.statusCode ?? 0 {
          lemmyInstances.append(enteredCustomInstance)
          selectedInstance = enteredCustomInstance
        } else {
          showingInvalidInstanceError = true
        }
      }
    } else {
      showingAlreadyExistsError = true
    }
  }

  func delete(at offsets: IndexSet) {
    lemmyInstances.remove(atOffsets: offsets)
    if lemmyInstances.isEmpty {
      selectedInstance = ""
    } else {
      if !lemmyInstances.contains(selectedInstance) {
        selectedInstance = lemmyInstances[0]
      }
    }
  }
}

struct ManageInstancesView_Previews: PreviewProvider {
  static var previews: some View {
    ManageInstancesView()
  }
}
