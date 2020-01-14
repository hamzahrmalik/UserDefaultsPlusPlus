# UserDefaults++

UserDefaults++ is a lightweight wrapper around UserDefaults to make managing keys and their types easier. Simply declare all your keys in one place to be able to save and retrieve items from them in a type safe manner. Plus, you can save any object by providing an encoder and decoder. These are provided automatically for Codable objects

## Usage

First, declare your keys. This is best done as static constants

```swift
import UserDefaults_

struct Storage {
    //define that we want to store a Bool using the key show_completed
    static let showCompleted = UserDefault<Bool>(key: "show_completed")

    //define that we want to store an array of TodoListItem objects using the key todo_list
    //See 'Storing Complex Objects' to see how TodoListItem is defined
    static let todoList = UserDefault<[TodoListItem]>(key: "todo_list")
}
```

Then, anywhere in your app, you can refer to these constants to persist or get the value saved to that key

```swift
//writing
Storage.showCompleted.persist(true)

//reading
let showCompleted: Bool? = Storage.showCompleted.get()
```

## Storing complex objects

For an object to be storable it must conform to the Storable protocol. Int, Double, Float, Bool, String and URL are already conformed to this protocol for you. Also, arrays of Storable elements are automatically Storable.
There is a protocol provided, PlistStorable, that you can conform to which wil allow you to make any struct or class Storable. Conforming to PlistStorable will conform your struct to Codable and will make use of swifts PropertyListEncoder for storage.

### Example

```swift
//We can make this class Storable for free by making it PlistStorable, as long as all its properties are Codable
struct TodoListItem: PlistStorable {
    
    let name: String
    let added: Date
    var completed: Bool
    
}
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

UserDefaults++ is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UserDefaults++'
```

## License

UserDefaults++ is available under the MIT license. See the LICENSE file for more info.
