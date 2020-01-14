/*
    Copyright (c) 2020 Hamzah Malik <hamzahrmalik@yahoo.co.uk>
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
*/

import Foundation

// A protocol defining how an object should be stored in UserDefaults
public protocol Persistable {
    //Encode this object to a primitive or property list which can be stored in UserDefaults
    func encode() -> Any?
}

// An implementation of Persistable which does no encoding, to be used by primitive types
public extension Persistable {
    func encode() -> Any? {
        self
    }
}

// A protocol defining how an object should be retrieved from UserDefaults
public protocol Retrievable {
    static func decode(encoded: Any) -> Self?
}

// An implementation of Retrievable which does no decoding, to be used by primitive types
extension Retrievable {
    public static func decode(encoded: Any) -> Self? {
        encoded as? Self
    }
}

// All objects which you want to store must be both Persistable and Retrievable
public typealias Storable = Persistable & Retrievable

// An implementation of Storable for Codable objects, storing them encoded as plists
public protocol PlistStorable: Codable, Storable {
    func encode() -> Any?
    static func decode(encoded: Any) -> Self?
}

public extension PlistStorable {
    func encode() -> Any? {
        try? PropertyListEncoder().encode(self)
    }
    
    static func decode(encoded: Any) -> Self? {
        if let data = encoded as? Data {
            if let result = try? PropertyListDecoder().decode(self, from: data) {
                return result
            }
        }
        return nil
    }
}

/*
    Conform primitives to Storable using the default implementation
*/

extension String: Storable {
}

extension Int: Storable {
}

extension Double: Storable {
}

extension Float: Storable {
}

extension Bool: Storable {
}

extension Data: Storable {
}


// Conform Storable arrays to Storable by mapping the elements using their encode and decode functions
extension Array: Persistable where Element: Persistable {
    public func encode() -> Any? {
        self.map({ $0.encode() })
    }
}

extension Array: Retrievable where Element: Retrievable {
    public static func decode(encoded: Any) -> Array<Element>? {
        if let array = encoded as? [Any] {
            return array.compactMap({ Element.decode(encoded: $0) })
        }
        return nil
    }
}

//Defines a key against which a Storable can be stored
public struct UserDefault<T: Storable> {
    
    let key: String
    let defaults: UserDefaults
    
    public init(key: String, defaults: UserDefaults = .standard) {
        self.key = key
        self.defaults = defaults
    }
    
    public func persist(_ value: T?) {
        defaults.set(value?.encode(), forKey: key)
    }
    
    public func get() -> T? {
        if let encoded = defaults.value(forKey: key) {
            return T.decode(encoded: encoded)
        }
        return nil
    }
    
    public func get(or def: T) -> T {
        get() ?? def
    }
    
    public func clear() {
        defaults.set(nil, forKey: key)
    }
    
}
