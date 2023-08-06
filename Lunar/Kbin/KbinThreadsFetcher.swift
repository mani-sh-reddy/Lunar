//
//  KbinThreadsFetcher.swift
//  Lunar
//
//  Created by Mani on 06/08/2023.
//

import Alamofire
import SwiftSoup
import SwiftUI

class KbinThreadsFetcher: ObservableObject {
//    @Published var webpage: KbinWebPage?
    @Published var posts = [KbinPost]()
    @Published var isLoading = false

    private var currentPage = 1

    init() {
        loadMoreContent()
    }

    func refreshContent() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        } catch {}

        guard !isLoading else { return }

        isLoading = true
        currentPage = 1

        posts.removeAll()

        loadMoreContent()
    }

    func loadMoreContentIfNeeded(currentItem item: KbinPost?) {
        guard let item else {
            loadMoreContent()
            return
        }
        let thresholdIndex = posts.index(posts.endIndex, offsetBy: -1)
        if posts.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent()
        }
    }

    func loadMoreContent() {
        guard !isLoading else { return }

        isLoading = true

        AF.request("https://kbin.social/?p=\(currentPage)").response { response in
            if let data = response.data, let htmlString = String(data: data, encoding: .utf8) {
                do {
                    let doc = try SwiftSoup.parse(htmlString)

                    let posts = try doc.select("article.entry")

                    // Extract the elements with the class name "entry section subject"
//                    let elementsWithClass = try doc.select(".entry.section.subject")

                    for post in posts {
                        let id = try post.attr("id")
                        let title = try post.select("h2").text()
                        let user = try post.select("aside.meta a.user-inline").text()
                        let timeAgo = try post.select("aside.meta time.timeago").text()
                        let upvotesString = try post.select("aside.vote span[data-subject-target=favCounter]").text()
                        let upvotes = Int(upvotesString) ?? 0
                        let downvotesString = try post.select("aside.vote span[data-subject-target=downvoteCounter]").text()
                        let downvotes = Int(downvotesString) ?? 0
                        let previewImageUrl = try post.select("figure div.image-filler").attr("style")
                        let commentsCountString = try post.select("a.stretched-link span[data-subject-target=commentsCounter]").text()
                        let commentsCount = Int(commentsCountString) ?? 0
                        let imageUrl = try post.select("img.thumb-subject").attr("src")
                        let magazine = try post.select("a.magazine-inline").text()

                        let postURL = try post.select("h2 a").attr("href")

//                        let anchorElement = try doc.select("article header a").first()
//                        let postURL = try anchorElement?.attr("href")

                        // Extract user information
                        let username = try post.select("aside.meta.entry__meta a.user-inline").text()
                        let avatarUrl = try post.select("aside.meta.entry__meta figure img").attr("src")
                        let joined = try post.select("aside.meta.entry__meta li time.timeago").text()
                        let reputationPointsString = try post.select("aside.meta.entry__meta li a[href*='reputation/threads']").text()
                        let reputationPoints = Int(reputationPointsString) ?? 0
                        let browseUrl = try post.select("aside.meta.entry__meta li a[href*='lemmy.world']").attr("href")
                        let followCountString = try post.select("aside.meta.entry__meta aside.user__follow div").text()
                        let followCount = Int(followCountString) ?? 0

                        let userObject = KbinUser(username: username, avatarUrl: avatarUrl, joined: joined, reputationPoints: reputationPoints, browseUrl: browseUrl, followCount: followCount)

                        let instanceLink = try post.select("span.entry__domain a").attr("href")
                            .replacingOccurrences(of: "/d/", with: "")
                            .trimmingCharacters(in: .whitespaces)

                        let post = KbinPost(
                            id: id,
                            title: title,
                            user: user,
                            timeAgo: timeAgo,
                            upvotes: upvotes,
                            downvotes: downvotes,
                            previewImageUrl: previewImageUrl,
                            commentsCount: commentsCount,
                            imageUrl: imageUrl,
                            magazine: magazine,
                            userObject: userObject,
                            instanceLink: instanceLink,
                            postURL: postURL ?? ""
                        )
                        self.posts.append(post)
                        self.isLoading = false
                        self.currentPage += 1
                    }
                } catch {
                    print("Error parsing HTML: \(error)")
                }
            } else {
                print("Failed to get HTML content")
            }
        }
    }
}
