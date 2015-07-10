[![Build Status](https://travis-ci.org/gtranchedone/FlickrParty.svg?branch=develop)](https://travis-ci.org/gtranchedone/FlickrParty)
[![Coverage Status](https://coveralls.io/repos/gtranchedone/FlickrParty/badge.svg?branch=master&service=github)](https://coveralls.io/github/gtranchedone/FlickrParty?branch=master)

# FlickrParty
A simple photo gallery implemented using Flickr API written in Swift

## Project Setup

This project is written in Swift and uses CocoaPods for dependencies. The only Pods used so far are:

* [Alamofire](https://github.com/Alamofire/Alamofire) (Swiftly equivalent of AFNetworking)
* [HanekeSwift](https://github.com/Haneke/HanekeSwift) (Swift port of the caching framework Haneke)

To build and run this project, clone the repository and run `pod install`.

    git clone ...
    cd path/to/FlickrParty
    # if required [sudo] gem install cocoapods
    pod install

**Note: This project exposes a Flickr API Key. It would be recommended not to store API Keys like displayed in this project. I've done like so for simplicity.
Moreover, it would be adviced that you used your own Flickr API Key. You can get one at [https://www.flickr.com/services/api/](https://www.flickr.com/services/api/).**

## TODO

- [x] Implement simple UI and logic for photos tagged 'Party'
- [x] Implement simple UI for photo details
- [x] Add support for multiple results pages
- [x] Improve image caching by setting a limit on the cache
- [x] Improve memory usage by responding to -didReceiveMemoryWarning and dropping all photos. Then reload to display content. (temporary solution)
- [x] Improve performance when scrolling many pages by temporarily dropping Photos that aren't being displayed (final memory usage solution)
- [x] Add tab for photos near current location
- [ ] ~~Improve test coverage to make it >= 90%~~ Measures cannot be taken using Xcode 6.
