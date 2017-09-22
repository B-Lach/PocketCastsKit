# PocketCastsKit
[![Build Status](https://www.bitrise.io/app/b1a7baab2672d1b7/status.svg?token=puVh6MgHEoHK74nXk0LS9g&branch=develop)](https://www.bitrise.io/app/b1a7baab2672d1b7)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

> PocketCastsKit is an unofficial [Pocket Casts] (https://www.shiftyjelly.com/pocketcasts/) API Wrapper written in Swift 4.0 and available for iOS, macOS and tvOS 

## Requirements

- iOS 11.0+ / macOS 10.13+ / tvOS 11.0+
- Xcode 9.0+
- Swift 4.0+


## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate PocketCastsKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "B-Lach/PocketCastsKit"
```

Run `carthage update` to build the framework and drag the built `PocketCastsKit.framework` into your Xcode project.
Install using Carthage as usual:

### Manually

If you prefer not to use Carthage, you can integrate PocketCastsKit into your project manually by cloning the repository and build the needed target.

## Models

### PCKCountry

Represents a country available in Pocket Casts

```swift
public struct PCKCountry {
    public let code: String
    public let name: String
}
```
### PCKCategory

Represents a category in Pocket Casts

```swift 
public struct PCKCategory {
    public let id: Int
    public let name: String
}
```

### PCKCategoryContent

Represents a child of a `PCKCategory`. In a nutshell it's just a simplified version of `PCKPodcast`. If you want a more detailed version request `PCKClient.shared.getPodcast(with: PCKCategoryContent.uuid)`

```swift
public struct PCKCategoryContent {
    public let author: String
    public let title: String
    public let collectionId: Int
    public let description: String
    public let thumbnail: URL
    public let uuid: UUID
}
```

### PCKNetwork

Represents a network available in Pocket Casts

```swift
public struct PCKNetwork {
    public let id: Int
    public let title: String
    public let description: String
    public let imgURL: URL
    public let color: String
}
```

### PCKNetworkGroup

Represents a group of a specific `PCKNetwork`

```swift
public struct PCKNetworkGroup {    
    public let title: String
    public let description: String
    public let imgURL: URL
    // TODO: - No idea so far - private podcast uuid ?
    public let ppu: UUID
    public let podcasts: [PCKNetworkPodcast]
}
```

### PCKNetworkPodcast

Represents a Podcast object in a  `PCKNetworkGroup`. In a nutshell, it's just a simplified version of PCKPodcast. If you want a more detailed version request `PCKClient.shared.getPodcast(with: PCKNetworkPodcast.uuid)`

```swift
public struct PCKNetworkPodcast {
    public let uuid: UUID
    public let fileType: String?
}
```

### PCKPodcast
Represents a Podcast object in  Pocket Casts

```swift
public struct PCKPodcast {
    public let id: Int
    public let uuid: UUID
    public let url: URL?
    public let title: String
    public let category: String
    public let description: String
    public let mediaType: String
    public let language: String
    public let thumbnail: URL
    public let author: String
    public let sortOrder: Int
}
```

### PCKEpisode

Represents a specific Episode of a `PCKPodcast`.

```swift
public struct PCKEpisode {
    public let id: Int
    public let uuid: UUID
    public let url: URL
    public let publishedAt: Date
    public let duration: Int
    public let fileType: String
    public let title: String
    public let size: Int
    public let podcastId: Int
    public let podcastUUID: UUID?
    public var playingStatus: Int
    public var playedUpTo: Int
    public var isDeleted: Bool?
    public var starred: Bool?
}
```

## API
### Usage

#### Store a reference if you want to

```swift
import PocketCastskit

let client = PCKClient.shared
```

### Unauthorized requests
There are some endpoints you can consume without being authenticated.

#### Get Top 100 Podcasts

```swift
client.getTop100 { (result) in
    switch result {
    case .error(let error):
        // handle the error
    case .success(let podcasts):
        // do anything with the fetched podcasts
    }
}
```

#### Get Featured Podcasts

```swift
client.getFeatured { (result) in
    switch result {
    case .error(let error):
        // handle the error
    case .success(let podcasts):
        // do anything with the fetched podcasts
    }
}
```

#### Get currently trending Podcasts

```swift
client.getTrending { (result) in
    switch result {
    case .error(let error):
        // handle the error
    case .success(let podcasts):
        // do anything with the fetched podcasts
    }
}
```

#### Get available Networks

```swift
client.getNetworks { (result) in
    switch result {
    case .error(let error):
        // handle the error
    case .success(let networks):
        // do anything with the fetched networks
    }
}
```

#### Get all Groups of a Network

```swift
client.getNetworkGroups(networkId: 28) { (result) in
    switch result {
    case .error(let error):
        // handle the error
        print(error)
    case .success(let groups):
        // do anything with the fetched groups
    }
}
```

#### Get all available categories and countries
Podcasts are subdevided into categories which and can be filtered by country.
To get a touple of all available categories and countries use this endpoint. 

```swift
client.getCategoriesAndCountries { (result) in
    switch result {
    case .error(let error):
        // hanlde the error
        print(error)
        
    case .success(let touple):
        // do anything with the fetched categories and countries
        
        // print(touple.categories)
        // print(touple.countries)
    }
}
```

#### Get all podcasts of a specific category for a given country
You will get 50 podcast for each category.
It is not possible to fetch all podcast for a category without naming the country.

```swift
client.getCategoryContent(categoryId: category.id, countryCode: country.code) { (result) in
    switch result {
    case .error(let error):
        // handle the error
    case .success(let content):
        // do anything the fetched category content
    }
}
```

### Authentication
Before requesting any user related data you have to authenticate as a valid user

#### Authenticate with email and password

```swift
client.authenticate(username: "foo@example.com", password: "bar") { (result) in
    switch(result) {
    case .error(let error):
        // handle the error
    case .success(_):
        // you are authenticated
    }
}
```

#### Check if you are still authenticated

```swift
client.isAuthenticated { (result) in
    switch(result) {
    case .error(let error):
        // handle the error
    case .success(_):
        // you are authenticated
    }
}
```

### Authorized requests - User feeds

#### Get all subscribed podcast

```swift
client.getSubscriptions { (result) in
    switch(result) {
    case .error(let error):
        // handle the error
    case .success(let podcasts):
        // do anything with the subscribed podcasts
    }
}
```

#### Get new episodes

```swift
client.getNewEpisodes { (result) in
    switch(result) {
    case .error(let error):
        // handle the error
    case .success(let episodes):
        // do anything with the new episodes
    }
}
```

#### Get episodes in progress

```swift
client.getEpisodesInProgress { (result) in
    switch(result) {
    case .error(let error):
        // handle the error
    case .success(let episodes):
        // do anything with the fetched episodes currently in progress
    }
}
```

#### Get starred episodes

```swift
client.getStarredEpisodes { (result) in
    switch(result) {
    case .error(let error):
        // handle the error
    case .success(let episodes):
        // do anything with the starred episodes 
    }
}
```

### Authenticated requests - Podcast actions

#### Search Podcast by String

```swift
client.searchPodcasts(by: "apple") { (result) in
        switch(result) {
        case .error(let error):
            // handle the error
        case .success(let podcasts):
            // do anything with the found podcasts
        }
}
```

#### Get Podcast by UUID

```swift
client.getPodcast(with: uuid) { (result) in
    switch(result) {
    case .error(let error):
        // handle the error
    case .success(let podcast):
        // do anything with the found podcast
    }
}
```

#### Get Episodes of a specific Podcast
By default this request will fetch the first page of the available episodes sorted from newest to oldest (descending)
Due to pagination you are able to define which page you want to fetch.You are able to change the sorting as well.
##### Default

```swift
client.getEpisodes(for: uuid) { (result) in
    switch(result) {
    case .error(let error):
        // handle the error
        print(error)
    case .success(let epsidodes):
        // do anything with the fetched episodes
    }
}

```

##### Custom

```swift
client.getEpisodes(for: uuid, page: 2, order: SortOrder.ascending) { (result) in
    switch(result) {
    case .error(let error):
        // handle the error
    case .success(let podcast):
        // do anything with the fetched episodes
    }
}
```

#### Subscribe to a Podcast by UUID

```swift
client.subscribe(podcast: uuid) { (result) in
    switch(result) {
    case .error(let error):
        // handle the error
    case .success(_):
    	 // Successfully subscribed to the Podcast
    }
}
```

#### Unsubscribe from a Podcast by UUID

```swift
client.unsubscribe(podcast: uuid) { (result) in
    switch(result) {
    case .error(let error):
        // handle the error
        print(error)
    case .success(_):
        // Successfully unsubscribed from the Podcast
    }
}
```

### Authenticated requests - Episode actions

#### Get Episode by UUID
To fetch a specific Episode you have to know its UUID and the UUID of the Podcast the Episode belongs to.

```swift
client.getEpisode(with: episode_uuid, of: podcast_uuid) { (result) in
    switch result {
    case .error(let error):
        // handle the error
    case .success(let episode):
        // do anything with the fetched episode
    }
}
```

#### Get Show Notes of an Episode

```swift
client.getShowNotes(for: episode_uuid) { (result) in
    switch result {
    case .error(let error):
    // handle the error
    case .success(let notes):
        // do anything with the fetched string
    }
}
```

#### Update the playing position for an Episode

```swift
client.setPlayingPosition(for: episode_uuid, podcast: podcast_uuid, position: 300) { (result) in
    switch result {
    case .error(let error):
    // handle the error
    case .success(_):
        // Successfully updated the position
    }
}
```

#### Update the playing status for an Episode

The status can be on of `PlayingStatus.unplayed`,  `PlayingStatus.playing` or 
`PlayingStatus.played`

```swift
client.setPlayingStatus(for: episode_uuid, podcast: podcast_uuid, status: status) { (result) in
    switch result {
    case .error(let error):
    // handle the error
    case .success(_):
        // Successfully updated the status
    }
}
```

#### Update the starred status for an Episode

You are able to star or unstar an episode

```swift
client.setStarred(for: episode_uuid, podcast: podcast_uuid, starred: true/false) { (result) in
    switch result {
    case .error(let error):
    // handle the error
    case .success(_):
        // Successfully updated the starred status
    }
}
```
## Contributing

> If you found a bug or have a feature request, feel free to create a pull request.