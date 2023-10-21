//
//  AboutLemmyInfo.swift
//  Lunar
//
//  Created by Mani on 21/10/2023.
//

import SFSafeSymbols
import SwiftUI

struct LemmyInfoSection {
  let title: String
  let description: String
  let icon: SFSafeSymbols.SFSymbol
}

class AboutLemmyInfo {
  let introSections: ([LemmyInfoSection], String)
  let gettingStartedSections: ([LemmyInfoSection], String)
  let mediaSections: ([LemmyInfoSection], String)
  let voteAndRankingSections: ([LemmyInfoSection], String)
  let moderationSections: ([LemmyInfoSection], String)
  let censorshipSections: ([LemmyInfoSection], String)
  let otherSections: ([LemmyInfoSection], String)
  let historySections: ([LemmyInfoSection], String)

  init() {
    introSections = ([
      LemmyInfoSection(
        title: "About Lemmy",
        description: """
        Lemmy is a selfhosted, federated social link aggregation and discussion forum. It consists of many different communities which are focused on different topics. Users can post text, links or images and discuss it with others. Voting helps to bring the most interesting items to the top. There are strong moderation tools to keep out spam and trolls. All this is completely free and open, not controlled by any company. This means that there is no advertising, tracking, or secret algorithms.
        """,
        icon: .infoCircleFill
      ),
      LemmyInfoSection(
        title: "Decentralized Social Networking",
        description: """
        Federation is a form of decentralization. Instead of a single central service that everyone uses, there are multiple services that any number of people can use.
        """,
        icon: .point3ConnectedTrianglepathDotted
      ),
      LemmyInfoSection(
        title: "The Fediverse",
        description: """
        A Lemmy website can operate alone. Just like a traditional website, people sign up on it, post messages, upload pictures and talk to each other. Unlike a traditional website, Lemmy instances can interoperate, letting their users communicate with each other; just like you can send an email from your Gmail account to someone from Outlook, Fastmail, Proton Mail, or any other email provider, as long as you know their email address, you can mention or message anyone on any website using their address.
        """,
        icon: .globeEuropeAfricaFill
      ),
      LemmyInfoSection(
        title: "Federation via ActivityPub",
        description: """
        Lemmy uses a standardized, open protocol to implement federation which is called ActivityPub. Any software that likewise implements federation via ActivityPub can seamlessly communicate with Lemmy, just like Lemmy instances communicate with one another. 

        The fediverse (\"federated universe\") is the name for all instances that can communicate with each other over ActivityPub and the World Wide Web. That includes all Lemmy servers, but also other implementations:

        - Mastodon (microblogging)
        - PeerTube (videos)
        - Friendica (multi-purpose)
            and many more!

        In practical terms: Imagine if you could follow a Facebook group from your Reddit account and comment on its posts without leaving your account. If Facebook and Reddit were federated services that used the same protocol, that would be possible. With a Lemmy account, you can communicate with any other compatible instance, even if it is not running on Lemmy. All that is necessary is that the software support the same subset of the ActivityPub protocol.
        """,
        icon: .linkCircleFill
      ),
      LemmyInfoSection(
        title: "Freedom and Personalisation",
        description: """
        Unlike proprietary services, anyone has the complete freedom to run, examine, inspect, copy, modify, distribute, and reuse the Lemmy source code. Just like how users of Lemmy can choose their service provider, you as an individual are free to contribute features to Lemmy or publish a modified version of Lemmy that includes different features. These modified versions, also known as software forks, are required to also uphold the same freedoms as the original Lemmy project. Because Lemmy is libre software that respects your freedom, personalizations are not only allowed but encouraged.
        """,
        icon: .airplaneDeparture
      ),
    ], "Introduction")
    gettingStartedSections = ([
      LemmyInfoSection(
        title: "Choosing an instance",
        description: """
        If you are used to sites like Reddit, then Lemmy works in a fundamentally different way. Instead of a single website like reddit.com, there are many different websites (called instances). These are operated by different people, have different topics and rules. Nevertheless, posts created in one instance can directly be seen by users who are registered on another. Its basically like email, but for social media.

        This means before using Lemmy and registering an account, you need to pick an instance. For this you can browse the instance list and look for one that matches your topics of interest. You can also see if the rules match your expectations, and how many users there are. It is better to avoid very big or very small instances. But don't worry too much about this choice, you can always create another account on a different instance later.
        """,
        icon: .globeEuropeAfricaFill
      ),
      LemmyInfoSection(
        title: "Registration",
        description: """
        Once you choose an instance, it's time to create your account. To do this, click sign up in the top right of the page, or click the top right button on mobile to open a menu with sign up link.

        On the signup page you need to enter a few things:

        - Username: How do you want to be called? This name can not be changed and is unique within an instance. Later you can also set a displayname which can be freely changed. If your desired username is taken, consider choosing a different instance where it is still available.

        - Email: Your email address. This is used for password resets and notifications (if enabled). Providing an email address is usually optional, but admins may choose to make it mandatory. In this case you will have to wait for a confirmation mail and click the link after completing this form.

        - Password: The password for logging in to your account. Make sure to choose a long and unique password which isn't used on any other website.

        - Verify password: Repeat the same password from above to ensure that it was entered correctly.

        There are also a few optional fields, which you may need to fill in depending on the instance configuration:

        - Question/Answer: Instance admins can set an arbitrary question which needs to be answered in order to create an account. This is often used to prevent spam bots from signing up. After submitting the form, you will need to wait for some time until the answer is approved manually before you can login.

        - Code: A captcha which is easy to solve for humans but hard for bots. Enter the letters and numbers that you see in the text box, ignoring uppercase or lowercase. Click the refresh button if you are unable to read a character. The play button plays an audio version of the captcha.

        - Show NSFW content: Here you can choose if content that is "not safe for work" (or adult-only) should be shown.

        When you are done, press the sign up button.

        It depends on the instance configuration when you can login and start using the account. In case the email is mandatory, you need to wait for the confirmation email and click the link first. In case "Question/Answer" is present, you need to wait for an admin to manually review and approve your registration. If you have problems with the registration, try to get in contact with the admin for support. You can also choose a different instance to sign up if your primary choice does not work.
        """,
        icon: .cursorarrowRays
      ),
      LemmyInfoSection(
        title: "Following communities",
        description: """
        After logging in to your new account, its time to follow communities that you are interested in. For this you can click on the communities link at the top of the page (on mobile, you need to click the menu icon on the top right first). You will see a list of communities which can be filtered by subscribed, local or all. Local communities are those which are hosted on the same site where you are signed in, while all also contains federated communities from other instances. In any case you can directly subscribe to communities with the right-hand subscribe link. Or click on the community name to browse the community first, see what its posted and what the rules are before subscribing.

        Another way to find communities to subscribe to is by going to the front page and browsing the posts. If there is something that interests you, click on the post title to see more details and comments. Here you can subscribe to the community in the right-hand sidebar, or by clicking the "sidebar" button on mobile.

        These previous ways will only show communities that are already known to the instance. Especially if you joined a small or inactive Lemmy instance, there will be few communities to discover. You can find more communities by browsing different Lemmy instances, or using the Lemmy Community Browser. When you found a community that you want to follow, enter its URL (e.g. https://feddit.de/c/main) or the identifier (e.g. !main@feddit.de) into the search field of your own Lemmy instance. Lemmy will then fetch the community from its original instance, and allow you to interact with it. The same method also works to fetch users, posts or comments from other instances.
        """,
        icon: .person3Fill
      ),
      LemmyInfoSection(
        title: "Setting up your profile",
        description: """
        Before you start posting, its a good idea to provide some details about yourself. Open the top-right menu and go to "settings". Here the following settings are available for your public profile:

        - Displayname: An alternative username which can be changed at any time
        - Bio: Long description of yourself, can be formatted with Markdown
        - Matrix User: Your username on the decentralized Matrix chat
        - Avatar: Profile picture that is shown next to all your posts
        - Banner: A header image for your profile page

        On this page you can also change the email and password. Additionally there are many other settings available, which allow customizing of your browsing experience:

        - Blocks (tab at top of the page): Here you can block users and communities, so that their posts will be hidden.
        - Interface language: Which language the user interface should use.
        - Languages: Select the languages that you speak to see only content in these languages. This is a new feature and many posts don't specify a language yet, so be sure to select "Undetermined" to see them.
        - Theme: You can choose between different color themes for the user interface. Instance admins can add more themes.
        - Type: Which timeline you want to see by default on the frontpage; only posts from communities that you subscribe to, posts in local communities, or all posts including federated.
        - Sort type: How posts and comments should be sorted by default. See Votes and Ranking for details.
        - Show NSFW content: Whether or not you want to see content that is "not safe for work" (or adult-only).
        - Show Scores: Whether the number of upvotes and downvotes should be visible.
        - Show Avatars: Whether profile pictures of other users should be shown.
        - Bot Account: Enable this if you are using a script or program to create posts automatically
        - Show Bot Accounts: Disable this to hide posts that were created by bot accounts.
        - Show Read Posts: If this is disabled, posts that you already viewed are not shown in listings anymore. Useful if you want to find new content easily, but makes it difficult to follow ongoing discussion under existing posts.
        - Show Notifications for New Posts: Enable this to receive a popup notification for each new post that is created.
        - Send notifications to Email: Enable to receive notifications about new comment replies and private messages to your email address.
        """,
        icon: .personCropCircle
      ),
      LemmyInfoSection(
        title: "Start posting",
        description: """
        Finally its time to start posting! To do this it is always a good idea to read the community rules in the sidebar (below the Subscribe button). When you are ready, go to a post and type your comment in the box directly below for a top-level reply. You can also write a nested reply to an existing comment, by clicking the left-pointing arrow.

        Other than commenting on existing posts, you can also create new posts. To do this, click the button Create a post in the sidebar. Here you can optionally supply an external link or upload an image. The title field is mandatory and should describe what you are posting. The body is again optional, and gives space for long texts. You can also embed additional images here. The Community dropdown below allows choosing a different community to post in. With NSFW posts can be marked as "not safe for work". Finally you can specify the language that the post is written in, and then click on Create.

        One more possibility is to write private messages to individual users. To do this, simply visit a user profile and click Send message. You will be notified about new private messages and comment replies with the bell icon in the top right.
        """,
        icon: .listBulletBelowRectangle
      ),
    ], "Getting Started")
    mediaSections = ([
      LemmyInfoSection(
        title: "Text",
        description: """
        The main type of content in Lemmy is text which can be formatted with Markdown. Refer to the table below for supported formatting rules. The Lemmy user interface also provides buttons for formatting, so it's not necessary to remember all of it. You can also follow the interactive CommonMark tutorial to get started.

        CommonMark Basics:

        *Italic* or _Italic_

        **Bold** or __Bold__

        # Heading 1

        ## Heading 2

        [Link](http://link.com)

        ![Image](http://url/image.png)

        > Blockquote

        * List
        * List
        * List

        1. Numbered List
        2. Numbered List
        3. Numbered List

        Horizontal Rule
        ---

        `Inline code` with backticks

        ```
        # code block
        print '3 backticks or'
        print 'indent 4 spaces'
        ```

        ::: spoiler hidden or nsfw stuff
        a bunch of spoilers here
        :::

        -subscript-

        ^superscript^

        """,
        icon: .textformat
      ),
      LemmyInfoSection(
        title: "Images and video",
        description: """
        Lemmy also allows sharing of images and videos. To upload an image, go to the Create post page and click the little image icon under the URL field. This allows you to select a local image. If you made a mistake, a popup message allows you to delete the image. The same image button also allows uploading of videos in .gif format. Instead of uploading a local file, you can also simply paste the URL of an image or video from another website.

        Note that this functionality is not meant to share large images or videos, because that would require too many server resources. Instead, upload them on another platform like PeerTube or Pixelfed, and share the link on Lemmy.
        """,
        icon: .photo
      ),
    ], "Media")
    voteAndRankingSections = ([
      LemmyInfoSection(
        title: "Voting System",
        description: """
        Lemmy uses a voting system to sort post listings. On the left side of each post there are up and down arrows, which let you upvote or downvote it. You can upvote posts that you like so that more users will see them. Or downvote posts so that they are less likely to be seen. Each post receives a score which is the number of upvotes minus number of downvotes.

        When browsing the frontpage or a community, you can choose between the following sort types for posts:

        - Active (default): Calculates a rank based on the score and time of the latest comment, with decay over time

        - Hot: Like active, but uses time when the post was published

        - Scaled: Like hot, but gives a boost to less active communities

        - New: Shows most recent posts first

        - Old: Shows oldest posts first

        - Most Comments: Shows posts with highest number of comments first

        - New Comments: Bumps posts to the top when they are created or receive a new reply, analogous to the sorting of traditional forums

        - Top Day: Highest scoring posts during the last 24 hours

        - Top Week: Highest scoring posts during the last 7 days

        - Top Month: Highest scoring posts during the last 30 days

        - Top Year: Highest scoring posts during the last 12 months

        - Top All Time: Highest scoring posts during all time

        Comments are by default arranged in a hierarchy which shows at a glance who it is replying to. Top-level comments which reply directly to a post are on the very left, not indented at all. Comments that are responding to top-level comments are indented one level and each further level of indentation means that the comment is deeper in the conversation. With this layout it is always easy to see the context for a given comment, by simply scrolling up to the next comment which is indented one level less.

        Comments can be sorted in the following ways. These all keep the indentation intact, so only replies to the same parent are shuffled around.

        - Hot (default): Equivalent to the Hot sort for posts

        - Top: Shows comments with highest score first

        - New: Shows most recent comments first

        - Old: Shows oldest comments first

        Additionally there is a sort option Chat. This eliminates the hierarchy, and puts all comments on the top level, with newest comments shown at the top. It is useful to see new replies at any point in the conversation, but makes it difficult to see the context.

        The ranking algorithm is described in detail here: https://join-lemmy.org/docs/contributors/07-ranking-algo.html.
        """,
        icon: .chartBarFill
      ),
    ], "Votes and ranking")
    moderationSections = ([
      LemmyInfoSection(
        title: "Rules",
        description: """
        The internet is full of bots, trolls and other malicious actors. Sooner or later they will post unwanted content to any website that is open to the public. It is the task of administrators and moderators to remove such unwanted content. Lemmy provides many tools for this, from removing individual posts, over temporary bans, to removing all content from an offending user.

        Moderation in Lemmy is divided between administrators and moderators. Admins are responsible for the entire instance, and can take action on any content. They are also the only ones who can completely ban users. In contrast, moderators are only responsible for a single community. Where admins can ban a user from the entire instance, mods can only ban them from their community.

        The most important thing that normal users can do if they notice a rule breaking post is to use the report function. If you notice such a post, click the flag icon to notify mods and admins. This way they can take action quickly and remove the offending content. To find out about removals and other mod actions, you can use the mod log which is linked at the bottom of the page. In some cases there may be content that you personally dislike, but which doesn't violate any rules. For this exists a block function which hides all posts from a given user or community.

        Each instance has a set of rules to let users know which content is allowed or not. These rules can be found in the sidebar and apply to all local communities on that instance. Some communities may have their own rules in the respective sidebar, which apply in addition to the instance rules.

        Because Lemmy is decentralized, there is no single moderation team for the platform, nor any platform-wide rules. Instead each instance is responsible to create and enforce its own moderation policy. This means that two Lemmy instances can have rules that completely disagree or even contradict. This can lead to problems if they interact with each other, because by default federation is open to any instance that speaks the same protocol. To handle such cases, administrators can choose to block federation with specific instances. To be even safer, they can also choose to be federated only with instances that are allowed explicitly.
        """,
        icon: .listBulletRectanglePortrait
      ),
      LemmyInfoSection(
        title: "How to moderate",
        description: """
        To get moderator powers, you either need to create a new community, or be appointed by an existing moderator. Similarly to become an admin, you need to create a new instance, or be appointed by an existing instance admin. Community moderation can be done over federation, you don't need to be registered on the same instance where the community is hosted. To be an instance administrator, you need an account on that specific instance. Admins and moderators are organized in a hierarchy, where the user who is listed first has the power to remove admins or mods who are listed later.

        All moderation actions are taken on the context menu of posts or comments. Click the three dot button to expand available mod actions, as shown in the screenshot below. All actions can be reverted in the same way.
        """,
        icon: .computermouseFill
      ),
      LemmyInfoSection(
        title: "Moderation actions",
        description: """
        Action: Lock
        Result: Prevents making new comments under the post
        Permission level: Moderator

        Action: Sticky (Community)
        Result: Pin the publication to the top of the community listing
        Permission level: Moderator

        Action: Sticky (Local)
        Result: Pin the publication to the top of the frontpage
        Permission level: Admin

        Action: Remove
        Result: Delete the post
        Permission level: Moderator

        Action: Ban from community
        Result: Ban user from interacting with the community, but can still use the rest of the site. There is also an option to remove all existing posts.
        Permission level: Moderator

        Action: Appoint as mod
        Result: Gives the user moderator status
        Permission level: Moderator

        Action: Ban from site
        Result: Completely bans the account, so it can't login or interact at all. There is also an option to remove all existing posts.
        Permission level: Admin

        Action: Purge user
        Result: Completely delete the user, including all posts and uploaded media. Use with caution.
        Permission level: Admin

        Action: Purge post/comment
        Result: Completely delete the post, including attached media.
        Permission level: Admin

        Action: Appoint as admin
        Result: Gives the user administrator status
        Permission level: Admin
        """,
        icon: .shieldLefthalfFilled
      ),
    ], "Moderation")
    censorshipSections = ([
      LemmyInfoSection(
        title: "Censorship",
        description: """
        Today's social media landscape is extremely centralized. The vast majority of users are concentrated on only a handful of platforms like Facebook, Reddit or Twitter. All of these are maintained by large corporations that are subject to profit motive and United States law. In recent years these platforms have increasingly censored users and entire communities, often with questionable justifications. It is only natural that those who are affected by this search for alternatives. This document is intended to help with the evaluation.

        For this purpose we will consider as censorship anything that prevents a person from expressing their opinion, regardless of any moral considerations. All the options explained here also have legitimate uses, such as deleting spam. Nevertheless it is important for users to understand why their posts are getting removed and how to avoid it.

        The first and most common source of censorship in this sense is the admin of a given Lemmy instance. Due to the way federation works, an admin has complete control over their instance, and can arbitrarily delete content or ban users. The moderation log helps to provide transparency into such actions.

        The second source of censorship is through legal means. This often happens for copyright violation, but can also be used for other cases. What usually happens in this case is that the instance admin receives a takedown notice from the hosting provider or domain registrar. If the targeted content is not removed within a few days, the site gets taken down. The only way to avoid this is to choose the hosting company and country carefully, and avoid those which might consider the content as illegal.

        Another way to censor is through social pressure on admins. This can range from spamming reports for unwanted content, to public posts from influential community members demanding to take certain content down. Such pressure can keep mounting for days or weeks, making it seem like everyone supports these demands. But in fact it is often nothing more than a vocal minority. It is the task of admins to gauge the true opinion of their community. Community members should also push back if a minority tries to impose its views on everyone else.

        All of this shows that it is relatively easy to censor a single Lemmy instance. Even a group of instances can be censored if they share the same admin team, hosting infrastructure or country. Here it is important that an admin can only censor content on their own instance, or communities which are hosted on his instance. Other instances will be unaffected. So if there is a problem with censorship, it can always be solved by using a different Lemmy instance, or creating a new one.

        But what if the goal was to censor the entire Lemmy network? This is inherently difficult because there is no single entity which has control over all instances. The closest thing to such an entity are the developers, because they can make changes to the code that all the instances run. For example, developers could decide to implement a hardcoded block for certain domains, so that they can't federate anymore. However, changes need to be released and then installed by instance admins. Those who are affected would have no reason to upgrade. And because the code is open source, they could publish a forked software version without these blocks. So the effect would be very limited, but it would split the project and result in loss of reputation for the developers. This is probably the reason why it has never happened on any Fediverse platform.

        Lastly it might be possible to abuse software vulnerabilities for network-wide censorship. Imagine a bug in Lemmy or in the underlying software stack which allows the attacker to delete arbitrary content. This could remain undetected for a while if used sparingly, but would certainly be discovered after some time. And experience has shown that such critical flaws are fixed very quickly in open source software. It is also highly unlikely that critical vulnerabilities be present in multiple different Fediverse platforms at the same time.

        In conclusion, the best way to avoid censorship on Lemmy is through the existence of many independent instances. These should have different admins, different hosting providers and be located in different countries. Additionally users should follow the development process to watch for changes that might create a centralized point of control for all instances. Based on this explanation it should be clear that censorship on Lemmy is difficult, and can always be circumvented. This is in contrast to centralized platforms like Facebook or Reddit. They are not open source and can't be self-hosted, so it is necessary to switch to an entirely different platform to avoid censorship. And due to lack of federation, such a switch means losing contact with users who decide to stay on the censored platform.
        """,
        icon: .eyeSlash
      ),
    ], "Censorship resistance")
    otherSections = ([
      LemmyInfoSection(
        title: "Theming",
        description: """
        Users can choose between a number of built-in color themes. Admins can also provide additional themes and set them as default.
        """,
        icon: .paintpaletteFill
      ),
      LemmyInfoSection(
        title: "Easy to install, low hardware requirements",
        description: """
        Lemmy is written in Rust, which is an extremely fast language. Thats why it has very low hardware requirements. It can easily run on a Raspberry Pi or similar low-powered hardware. This makes it easy to administrate and keeps costs low.
        """,
        icon: .serverRack
      ),
      LemmyInfoSection(
        title: "Language Tags",
        description: """
        Lemmy instances and communities can specify which languages can be used for posting. Consider an instance aimed at Spanish users, it would limit the posting language to Spanish so that other languages can't be used. Or an international instance which only allows languages that the admin team understands. Community languages work in the same way, and are restricted to a subset of the instance languages. By default all languages are allowed (including undefined).

        Users can also specify which languages they speak, and will only see content in those languages. Lemmy tries to smartly select a default language for new posts if possible. Otherwise you have to specify the language manually.
        """,
        icon: .tagFill
      ),
      LemmyInfoSection(
        title: "Lemmy as a blog",
        description: """
        Lemmy can also function as a blogging platform. Doing this is as simple as creating a community and enabling the option "Only moderators can post to this community". Now only you and other people that you invite can create posts, while everyone else can comment. Like any Lemmy community, it is also possible to follow from other Fediverse platforms and over RSS. For advanced usage it is even possible to use the API and create a different frontend which looks more blog-like.
        """,
        icon: .laptopcomputer
      ),

    ], "Other Features")
    historySections = ([
      LemmyInfoSection(
        title: "Quote from the Lemmy Developer",
        description: """
        The idea to make Lemmy was a combination of factors.

        Open source developers like myself have long watched the rise of the “Big Five”, the US tech giants that have managed to capture nearly all the world’s everyday communication into their hands. We’ve been asking ourselves why people have moved away from content-focused sites, and what we can do to subvert this trend, in a way that is easily accessible to a non-tech focused audience.

        The barriers to entry on the web are much lower than say in the physical world: all it takes is a computer and some coding knowhow… yet the predominant social media firms have been able to stave off competition for at least two reasons: their sites are easy to use, and they have huge numbers of users already (the “first mover” advantage). The latter is more important; if you’ve ever tried to get someone to use a different chat app, you’ll know what I mean.

        Now I loved early Reddit, not just for the way that it managed to put all the news for the communities and topics I wanted to see in a single place, but for the discussion trees behind every link posted. I still have many of these saved, and have gained so much more from the discussion behind the links, than I have from the links themselves. In my view, its the community-focused, tree-like discussions, as well as the ability to make, grow, and curate communities, that has made Reddit the 5th most popular site in the US, and where so many people around the world get their news.

        But that ship sailed years ago; the early innovative spirit of Reddit left with Aaron Swartz: its libertarian founders have allowed some of the most racist and sexist online communities to fester on Reddit for years, only occasionally removing them when community outcry reaches a fever pitch. Reddit closed its source code years ago, and the Reddit redesign has become a bloated anti-privacy mess.

        Its become absorbed into that silicon valley surveillance-capitalist machine that commodifies users to sell ads and paid flairs, and propagandizes pro-US interests above all. Software technology being one of the last monopoly exports the US has, it would be naive to think that one of the top 5 most popular social media sites, where so many people around the world get their news, would be anything other than a mouthpiece for the interests of those same US coastal tech firms.

        Despite the conservative talking point that big tech is dominated by “leftist propaganda”, it is liberal, and pro-US, not left (leftism referring to the broad category of anti-capitalism). Reddit has banned its share of leftist users and communities, and the Reddit admins via announcement posts repeatedly vilify the US’s primary foreign-policy enemies as having “bot campaigns”, and “manipulating Reddit”, yet the default Reddit communities (/r/news, /r/pics, etc), who share a small number of moderators, push a line consistent with US foreign-policy interests. The aptly named /r/copaganda subreddit has exposed the pro-police propaganda that always seems to hit Reddit’s front page in the wake of every tragedy involving US police killing the innocent (or showing police kissing puppies, even though US police kill ~ 30 dogs every day, which researchers have called a “noted statistical phenomenon”).

        We’ve also seen a rise in anti-China posts that have hit Reddit lately, and along with that comes anti-chinese racism, which Reddit tacitly encourages. That western countries are seeing a rise in attacks against Asian-Americans, just as some of the perpetrators of several hate-crimes against women were found to be Redditors active in mens-rights Reddit communities, is not lost on us, and we know where these tech companies really stand when it comes to violence and hate speech. Leftists know that our position on these platforms is tenuous at best; we’re currently tolerated, but that will not always be the case.

        The idea for making a Reddit alternative seemed pointless, until Mastodon (a federated twitter alternative), started becoming popular. Using Activitypub (a protocol / common language that social media services can use to speak to each other), we finally have a solution to the “first mover” advantage: now someone can build or run a small site, but still be connected to a wider universe of users.

        Nutomic and I originally made Lemmy to fill the role as a federated alternative to Reddit, but as it grows, it has the potential become a main source of news and discussion, existing outside of the US’s jurisdictional domain and control.
        """,
        icon: .quoteClosing
      ),
    ], "History of Lemmy")
  }
}
