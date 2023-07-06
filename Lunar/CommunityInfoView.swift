//
//  PostView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import SwiftUI

struct CommunityInfoView: View {
    var community: CommunityObject
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                
                VStack {
                    AsyncImage(url: URL(string: community.icon ?? "file:./LemmyLogo.png")) { image in
                        image
                            .resizable()
                            .clipped()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .padding(geometry.size.width * 0.05)
                    } placeholder: {
                        Image("LemmyLogo", bundle: Bundle(identifier:"io.github.mani-sh-reddy.Lunar"))
                            .resizable()
                            .clipped()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .padding(geometry.size.width * 0.05)
                    }
                    
                    HStack {
                        Text(community.description ?? "No Description")
                            .multilineTextAlignment(.leading)
                            .padding(.all, 16)
                        Spacer()
                    }
                    
                    
                }
                .frame(alignment: .top)
                .navigationTitle(community.title)
                
            }
            
        }
    }
    
}

//struct PostsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PostsListView()
//    }
//}
