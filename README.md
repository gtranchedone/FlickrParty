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
- [ ] Add support for multiple results pages
- [ ] Improve performance when scrolling many pages
- [ ] Add tab for photos near current location
- [ ] Add tab for searching photos freely
