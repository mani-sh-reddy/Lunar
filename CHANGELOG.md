# Change Log

All notable changes to this project will be documented in this file.

- `### Added` for new features.
- `### Changed` for changes in existing functionality.
- `### Fixed` for any bug fixes.
- `### Misc` for tech debt and other changes.

## [Unreleased]

### Changed

- Links inside comments now open with in-app safari

## [2023.12.8]

### Added

- Page cursor support for Lemmy 0.19

### Fixed

- Added a UUID to realm posts model to prevent post overwrites
- Fixed delete-posts-on-refresh logic

## [2023.12.6]

### Changed

- Updated inbox tab design
- Rendering images in comments view with LazyImage

### Fixed

- Disabled subscribed community blocking
- Fixed a bug in blocking comment creator

### Misc

- Removed legacy views

## [2023.12.3]

### Added

- Blocking users via a post
- Reporting posts
- Blocking users via a comment
- Reporting comments
- Blocking communities
- Warning to notify users about errors performing actions outside of home instance

### Misc

- Removed `Shiny` package due to lag
- Removed `Local Console` package
- Cleaned up API fetchers code

## [2023.12.1]

### Added

- Brand new community app icon created by @MrSebSin

## [2023.12.0]

### Added

- Font size slider

### Changed

- Rearranged settings view
- Decreased default font size
- Using github styled markdown


## [2023.11.22]

### Fixed

- Stutter caused by phase change actions
- Stutter cause by @Environment Dismiss

### Misc

- Code clean up
- Removed unused code and comments
- Added SwiftLint and Periphery run script and schemes

## [2023.11.19]

### Added

- Matrix tag in settings.
- Hide Communities button functionality.
- Pinned (Featured) posts labels.
- Go to comments from Posts Search View

### Changed

- Confirmation of Logged Out All Users action
- Using SwiftUI built-in picker for app icon selection
- Using SwiftUI built-in picker for account selection

## [2023.11.17]

### Changed

- Using package (@gonzalezreal /swift-markdown-ui) to parse post headers and comment text.
- Hiding Create Post, Create Comment, and Reply buttons when not logged in.

### Fixed

- Image links now rendering images instead of showing an empty line.

## [2023.11.16]

### Changed

- Hiding Create Post, Create Comment, and Reply buttons when not logged in.

### Misc

- Testing Automated Deployments

## [2023.11.14]

### Added

- Home Screen Quick Actions.
- Share Sheet Updates.
- Home screen and lock screen widgets.
- Setting to change accent colours of UI elements.
- Hidden Posts section in the settings tab, unlocked with biometrics.
- Added Scaled sort descriptor.
- Progress indicator when loading posts.
- Sort and Type information on Quicklink label.

### Changed

- Lots of small UI changes.
- Updated timestamp parser to support timezones.
- Requests are now authenticated via a token in the authorisation header.
- Updated icons in the context menu and swipe actions.
- Removed background from header sections in posts views.

### Fixed

- Community icon and descriptions in community header view.
- CodingKey bug in SiteInfoFetcher.

### Misc

- File directory cleanup.
- Removed keychainaccess package and references.
- Refetching subscribed communities after resetting realm.
- Resetting realm posts table on instance change.

## [2023.11.2]

### Added

- A new app icon.
- Local database to cache posts offline.
- Subscribed communities now saved to local database.
- Create new post popover.
- Offline downloader for posts.

### Changed

- Minor UI changes.
- Expanding post body in comments view UI change.
- Community / User specific post view pages now have an expandable info section.
- Sparse and Compact post views (changeable in settings).
- Rearranged feed tab to show subscriptions above trending.

### Fixed

- Fixed excessive API calls when in the Account tab.
- Minimise and Hide Posts swipe actions.
- Upvote and downvote buttons now functional.
- Subscribe and unsubscribe actions are now functional.
- Reply to comment popover now shows the correct comment.

### Misc

- Added @duraidabdul /LocalConsole Package for debugging.
- Added draggable user icon in account tab.

## [2023.10.0]

### Added

- "Create New Post" popover.
- Common dismiss button to popover views.
- Iridescent effect for the score in the MyUser view with setting to toggle it on and off (@maustinstar /shiny).
- Functionality to display saved posts and saved comments in the MyUser view.
- Re-added the expandable textbox.
- Random string generation in the updated placeholder view.

### Changed

- Made minor UI changes.
- Replaced some SF Symbols with alternatives.
- Updated the account view and added navigational buttons to go to posts.
- Resized images to a width of 200 before presenting in the view.
- Migrated most symbols to SFSafeSymbols to ensure compatibility with iOS 15+.
- Updated symbol colours in settings view.

### Fixed

- Fixed a bug related to the "Clear Cache" button.
- Resolved issues related to the "Quicklinks" feature with an option to toggle it.

### Misc

- Cleaned up the codebase.
- Replaced `@AppStorage` with `@Defaults` from the Defaults package (@sindresorhus /Defaults).
- Added a toggle for auto-collapse bots (not yet functional).
- Updated the account switching logic to simplify the currently selected account variable.
- Changed from SemVer to CalVer versioning (0.8.116 -> 2023.10.0)

## [0.8.116]

### Added

- Color Tester View into Dev Tools used when creating Quicklinks
- Account Tab View showing info of the current user
- Pulse remote debugging (requires network permissions)
- Using WhatsNewKit to show features screen on initial launch
- New placeholder view

### Changed

- Added new icons to debug view
- Updated settings view
- Updated default Quicklink colors
- Rewrote comments logic
- Collapsed comment shows a single line of the comment body
- Removed Splash Screen settings
- Replaced LocalizedString with AttributedString for markdown text
- Made network inspector overlay button smaller
- Moved shared Nuke Image Loading pipeline to AppDelegate
- Opening some links with in-app safari

### Fixed

- Missing placeholder image in header
- Clear Cache button bug
- Migrated most symbols to SFSafeSymbols to fix SFSymbols incompatible with iOS 15+

## [0.8.93]

### Added

- Pulse Logging Framework (https://github.com/kean/Pulse) for easier debugging
- Customisable Quicklinks

### Changed

- Updated posts fetching logic
- Optimised posts view for smoother scrolling
- Disabled unimplemented settings pages

### Fixed

- Removed redundant files
- Glitches related to fetcher views

## [0.8.85]

### Added

- New onboarding pages
- Unreleased views in Developer Options settings for testing
- Added Keychain reset action to the Reset App button

### Changed

- Replaced all Kingfisher image views with Nuke/NukeUI Image Loading System
- Downsampling post view images before displaying
- Slightly increase debounce to prevent stutter when typing in login view
- Added delay to fetch subscribed communities only after all parameters have been set

### Fixed

- Complete code format and cleanup with Periphery and SwiftFormat
- Cleaned up json decodable models

## [0.8.78]

### Added

- Compact mode for posts! (enabled in settings)
- Missing section label in layout view
- Dismiss button to ‘Add Instance’ alert

### Changed

- Removed ‘Manage Instance’ navigation link from login sheet
- Rearranged Layout Settings view

### Fixed

- Instance manager not showing error alerts on first submit of input alert

## [0.8.75]

### Added

- Setting to change app appearance (Light, Dark) independent of system appearance
- Headings for posts page
- Downsized app icon assets
- Close button to onboarding page

### Changed

- Rewrote app icon picker
- Increased size of instances scroll view on the welcome screen

### Fixed

- Fixed redundant “’s” in subscribed list heading when not logged in

## [0.8.71]

### Added

Metadata on communities labels enabled by default
A toggle to disable detailed communities view

### Changed

Rewrote instance selector logic
Created a new page to manage adding and removing instances from the main list
Added debug mode toggle into developer options settings

### Fixed

Bug preventing communities views in Feed from refreshing when changing instance or user

## [0.8.67]

### Added

- Kbin app icon
- Logging errors that arise from fetch classes
- View logs in Developer Option page in settings
- Share button to export logs
- Made by mani footer in settings view

### Changed

- Instance selector now includes many popular Lemmy instances as a temporary workaround for custom instances
- Moved Clear Cache and Reset buttons to separate Developer Option page in settings

### Fixed

- Some Lemmy instance site fetch class causing json decode errors when logging in due to nil values in model
- Potentially fixed: app icon change causing crash

## [0.8.26]

### Added

- Preliminary [Kbin](https://kbin.pub/en) support via HTML parsing
- Post and metadata (upvotes, downvotes, etc) inside Comments View
- Community View header showing icon, title, and description of community
- More mock data for testing
- Automated version number incrementing GitHub action
- DeepSource checks on PR creation

### Changed

- Posts View design
- Comments View design
- Comments View indent markers

### Fixed

- Warnings brought about by linting with DeepSource
- Infinite frame runtime warning
- Progress indicators

## [0.6.0]

### Added

- Search View
- Picker to select to search Users, Posts, and Communities
- User information view
- Community information view

### Fixed

- Account switcher not showing the selected account on first open

## [0.5.0]

### Added

- Login Page and account information persistence to Keychain
- Redesigned settings page
- 4 new app icons
- Instance selector with 7 popular instances (custom instances coming soon)
- Image popover with zoom and pan features
- Debug Mode
- Haptics during the login flow and for upvote & downvote buttons
- Redesigned post metadata buttons
- Reset app button

### Changed

- Included instance URL in Explore Communities Page
- Minor UI design changes
- Better divider between posts

### Fixed

- Background thread publishing bug
- Tab resetting to feed view on loss of app focus
- Graphical glitch when swiping down to refresh

## [0.4.1]

### Changed

- Split structs into separate files

## [0.4.0]

### Added

- Comment sorting logic

## [0.2.0]

### Added

- Pagination
- Comments view
- Pull down to refresh for posts and new communities

### Fixed

- Cache revalidation upon refresh

## [0.1.0]

### Added

- App icon
- Initial communities list view
- Tab bar navigation
- Feed view
- Rudimentary settings view
