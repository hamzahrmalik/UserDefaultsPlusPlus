import Quick
import Nimble
import UserDefaultsPlusPlus

class TestStorage {
    
    static let someString = UserDefault<String>(key: "someString")
    static let someInt = UserDefault<Int>(key: "someInt")
    static let someBool = UserDefault<Bool>(key: "someBool")
    static let someDouble = UserDefault<Double>(key: "someDouble")
    static let someFloat = UserDefault<Float>(key: "someFloat")
    static let someCustomObject = UserDefault<CustomObject>(key: "someCustomObject")
    static let someIntArray = UserDefault<[Int]>(key: "someIntArray")
    static let someCustomObjectArray = UserDefault<[CustomObject]>(key: "someCustomObjectArray")
}

struct CustomObject: PlistStorable, Equatable {
    
    let a: String
    let b: Int
    let c: AnotherCustomObject
    
}

struct AnotherCustomObject: PlistStorable, Equatable {
    
    let d: Double
    
}

class UserDefaultsTestSpec: QuickSpec {
    override func spec() {
        describe("Store Primitives") {
            it("can store strings") {
                TestStorage.someString.persist("testing")
                expect(TestStorage.someString.get()) == "testing"
            }
            it("can store ints") {
                TestStorage.someInt.persist(42)
                expect(TestStorage.someInt.get()) == 42
            }
            it("can store bool") {
                TestStorage.someBool.persist(true)
                expect(TestStorage.someBool.get()) == true
            }
            it("can store double") {
                TestStorage.someDouble.persist(3.14)
                expect(TestStorage.someDouble.get()) == 3.14
            }
            it("can store floats") {
                TestStorage.someFloat.persist(2.71)
                expect(TestStorage.someFloat.get()) == 2.71
            }
        }
        describe("Store Objects") {
            it("Can store a custom object") {
                let object = CustomObject(a: "hello", b: 93, c: AnotherCustomObject(d: 54.2))
                TestStorage.someCustomObject.persist(object)
                expect(TestStorage.someCustomObject.get()) == object
            }
        }
        
        describe("Store Primitive arrays") {
            it("Can store int array") {
                let array = [2, 4, 6, 8, 10]
                TestStorage.someIntArray.persist(array)
                expect(TestStorage.someIntArray.get()) == array
            }
        }
        
        describe("Store Complex arrays") {
            it("Can store object array") {
                let objectA = CustomObject(a: "object a", b: 1, c: AnotherCustomObject(d: 2.0))
                let objectB = CustomObject(a: "object b", b: 10, c: AnotherCustomObject(d: 12.0))
                let objectC = CustomObject(a: "object c", b: 20, c: AnotherCustomObject(d: 22.0))
                let array = [objectA, objectB, objectC]
                TestStorage.someCustomObjectArray.persist(array)
                expect(TestStorage.someCustomObjectArray.get()) == array
            }
        }
        
        describe("Clear saved items") {
            it("Can clear items") {
                TestStorage.someInt.clear()
                expect(TestStorage.someInt.get()).to(beNil())
            }
        }
        
    }
}
