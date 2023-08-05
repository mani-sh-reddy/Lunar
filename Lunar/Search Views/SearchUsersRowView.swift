//
//  SearchUsersRowView.swift
//  Lunar
//
//  Created by Mani on 05/08/2023.
//

import SwiftUI
import Kingfisher

struct SearchUsersRowView: View {
    @State var showingPlaceholderAlert = false
    var searchUsersResults: [SearchUserElement]
    let processor = DownsamplingImageProcessor(size: CGSize(width: 60, height: 60))

    var body: some View {
        ForEach(searchUsersResults, id: \.person.id) { person in
            NavigationLink {
                UserInfoView(person: person.person)
            } label: {
                HStack {
                
                    KFImage(URL(string: person.person.avatar ?? ""))
                        .setProcessor(processor)
                        .placeholder { Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.blue)
                        }
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())

                    VStack(alignment: .leading) {
                        Text(person.person.name).lineLimit(2)

                    }.padding(.horizontal, 10)
                    Spacer()
                    Text(String("\(URLParser.extractDomain(from: person.person.actorID))"))
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .fixedSize()
                }
            }

           
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button {
                showingPlaceholderAlert = true
            } label: {
                Label("go", systemImage: "chevron.forward.circle.fill")
            }.tint(.blue)
            Button {
                showingPlaceholderAlert = true
            } label: {
                Label("Hide", systemImage: "eye.slash.circle.fill")
            }.tint(.orange)
        }

        .contextMenu {
            Menu("Menu") {
                Button {
                    showingPlaceholderAlert = true
                } label: {
                    Text("Coming Soon")
                }
            }

            Button {
                showingPlaceholderAlert = true
            } label: {
                Text("Coming Soon")
            }

            Divider()

            Button(role: .destructive) {
                showingPlaceholderAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Coming soon", isPresented: $showingPlaceholderAlert) {
            Button("OK", role: .cancel) {}
        }
        }
    }
}
