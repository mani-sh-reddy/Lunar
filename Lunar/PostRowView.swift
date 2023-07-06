//
//  CommunityRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import SwiftUI

struct PostRowView: View {
    //    var post: PostPost
    //    var creator: Creator
    //    var community: Community
    //    var counts: Counts
    var post: PostElement
    
    //    func calculateRelativeTime(isoDate: String) -> String {
    //        let formatter = RelativeDateTimeFormatter()
    //        formatter.unitsStyle = .full
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    //        if let date = dateFormatter.date(from: isoDate) {
    //            let userCalendar = Calendar.current // Use the user's current calendar
    //            formatter.calendar = userCalendar
    //            return formatter.localizedString(for: date, relativeTo: Date())
    //        }
    //
    //        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    //        if let date = dateFormatter.date(from: isoDate) {
    //            let userCalendar = Calendar.current // Use the user's current calendar
    //            formatter.calendar = userCalendar
    //            return formatter.localizedString(for: date, relativeTo: Date())
    //        }
    //
    //        return "Invalid date format"
    //    }
    
    
    var body: some View {
        VStack(alignment: .leading, content: {
            Text(post.post.name).font(.headline)
            Spacer().frame(height: 5)
            HStack {
                Text("\(post.creator.name)").textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                
                Spacer()
                Text(String(post.post.published).prefix(10))
            }
            .font(.system(size: 13))
            .opacity(0.6)
            Spacer().frame(height: 15)
            HStack{
                AsyncImage(url: URL(string: post.post.thumbnailURL ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    
                } placeholder: {
                    Image("LemmyLogo", bundle: Bundle(identifier:"io.github.mani-sh-reddy.Lunar"))
                        .hidden()
                        .frame(height: 0)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(alignment: .center)
//                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
            }
            Spacer().frame(height: 15)
            HStack {
                AsyncImage(url: URL(string: post.community.icon ?? "file:./LemmyLogo.png")) { image in
                    image
                        .resizable()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle()).background()
                } placeholder: {
                    Image("LemmyLogo", bundle: Bundle(identifier:"io.github.mani-sh-reddy.Lunar"))
                        .resizable()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle()).background()
                }
                
                HStack {
                    Text(post.community.title)
                        .opacity(0.6)
                    Spacer()
                    Image(systemName: "arrow.up")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.green)
                    Text(String(post.counts.upvotes))
                        .foregroundColor(.green)
                    Spacer().frame(width: 25)
                    Image(systemName: "bubble.left")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.indigo)
                    Text(String(post.counts.comments))
                        .foregroundColor(.indigo)
                }
                .font(.system(size: 15))
                
                
            }
            
            
            //            Text(String(calculateRelativeTime(isoDate: post.post.published)))
            //            Text(post.post.url ?? "")
            
            
            
        })
        .padding(.vertical)
    }
}

//struct PostRowView_Previews: PreviewProvider {
//    var posts: PostElement
//    static var previews: some View {
//        PostRowView()
//    }
//}
