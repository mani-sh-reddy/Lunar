//
//  ManageInstancesView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Alamofire
import Defaults
import SwiftUI

struct ManageInstancesView: View {
  @Default(.lemmyInstances) var lemmyInstances
  @Default(.selectedInstance) var selectedInstance
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.kbinActive) var kbinActive
  @Default(.accentColor) var accentColor
  @Default(.accentColorString) var accentColorString

  @State var enteredCustomInstance = ""
  @State var showingAddInstanceAlert = false
  @State var showingInvalidInstanceError = false
  @State var showingAlreadyExistsError = false
  @State var showingResetConfirmation = false

  var body: some View {
    List {
      if debugModeEnabled {
        Text(String(describing: lemmyInstances))
      }

      Section {
        Toggle("kbin.social", isOn: $kbinActive)
          .tint(accentColorString == "Default" ? .purple : accentColor)
      } header: {
        Text("Kbin")
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
      } header: {
        Text("Lemmy")
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
    .navigationTitle("Manage Instances")
    .navigationBarTitleDisplayMode(.inline)
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

#Preview {
  ManageInstancesView()
}
