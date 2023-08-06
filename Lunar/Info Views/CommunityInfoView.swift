//
//  CommunityInfoView.swift
//  Lunar
//
//  Created by Mani on 05/08/2023.
//

import Kingfisher
import SwiftUI

struct CommunityInfoView: View {
    @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled

    @State private var bannerFailedToLoad = false
    @State private var avatarFailedToLoad = false

    @State private var loadingOpacity: Double = 1
    @State private var progressViewValue: Double = 0

    var community: SearchCommunityInfo
    var hasBanner: Bool {
        community.banner != "" && community.banner != nil
    }

    var hasAvatar: Bool {
        community.icon != "" && community.icon != nil
    }

    var body: some View {
        ZStack {
            ScrollView {
                if hasBanner, !bannerFailedToLoad {
                    KFImage(URL(string: community.banner ?? ""))
                        .resizable()
                        .fade(duration: 0.25)
                        .onFailure { _ in
                            withAnimation(.bouncy) {
                                bannerFailedToLoad = true
                            }
                        }
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .padding(5)
                        .padding(.horizontal, 10)
                        .border(debugModeEnabled ? Color.red : Color.clear)
                }

                VStack(alignment: .leading) {
                    HStack {
                        if hasAvatar, !avatarFailedToLoad {
                            KFImage(URL(string: community.icon ?? ""))
                                .fade(duration: 0.25)
                                .resizable()
                                .onFailure { _ in
                                    withAnimation(.snappy) {
                                        avatarFailedToLoad = true
                                    }
                                }
                                .clipped()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 75, height: 75)
                                .padding(5)
                                .border(debugModeEnabled ? Color.red : Color.clear)
                        } else {
                            EmptyView()
                                .frame(width: 0, height: 0)
                        }
                        VStack(alignment: .leading) {
                            Text(community.name)
                                .font(.title).bold()
                            Text("@\(URLParser.extractDomain(from: community.actorID))").font(.headline)
                        }
                    }.padding(.bottom, 10)

                    if let description = community.description {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .foregroundStyle(.ultraThinMaterial)
                            Text(description)
                                .padding(10)
                        }
                    }
                }.padding()
            }
            Rectangle()
                .foregroundStyle(.background)
                .opacity(loadingOpacity)
            ProgressView(value: progressViewValue)
                .frame(width: 100)
                .opacity(loadingOpacity)
        }
        /// Workaround to stop blank space appearing and disappearing
        /// when loading an invalid image
        .task {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                withAnimation(.smooth) {
                    progressViewValue += 1
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    loadingOpacity = 0
                }
            }
        }
    }
}

struct CommunityInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityInfoView(community: MockData.communityInfoView4)
    }
}
