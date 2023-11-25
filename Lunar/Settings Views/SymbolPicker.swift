////
////  SymbolPicker.swift
////  Lunar
////
////  Created by Mani on 09/09/2023.
////
//
// import Foundation
// import SwiftUI
//
// struct SymbolPickerView: View {
//  @Binding var selectedSymbol: String?
//  @Binding var selectedColor: Color
//  @Binding var isPopoverPresented: Bool
//
//  var body: some View {
//    NavigationView {
//      VStack {
//        ColorSelectionView(selectedColor: $selectedColor)
//
//        ScrollView {
//          LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 10) {
//            ForEach(SFSymbol.allCases, id: \.self) { symbol in
//              Button(action: {
//                selectedSymbol = symbol.rawValue
//                isPopoverPresented = false
//              }) {
//                Image(systemName: symbol.rawValue)
//                  .font(.system(size: 24))
//                  .foregroundColor(selectedColor)
//              }
//              .buttonStyle(SymbolButtonStyle())
//            }
//          }
//          .padding()
//        }
//      }
//      .navigationTitle("Select a Symbol")
//      .navigationBarItems(trailing: Button("Cancel") {
//        isPopoverPresented = false
//      })
//    }
//  }
// }
//
// struct SymbolButtonStyle: ButtonStyle {
//  func makeBody(configuration: Configuration) -> some View {
//    configuration.label
//      .frame(minWidth: 0, maxWidth: .infinity)
//      .padding()
//      .background(Color.white)
//      .cornerRadius(10)
//      .shadow(radius: 2)
//  }
// }
//
// struct ColorSelectionView: View {
//  @Binding var selectedColor: Color
//
//  var body: some View {
//    HStack {
//      Text("Select a Color:")
//        .font(.headline)
//        .padding(.leading)
//
//      ColorPicker("Color", selection: $selectedColor)
//        .padding()
//    }
//  }
// }
//
// enum SFSymbol: String, CaseIterable {
//  case heart
//  case star
//  case moon
// }
