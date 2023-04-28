// main.swift

import Foundation

class Person {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    func introduce() {
        print("Hi, my name is \(name) and I am \(age) years old.")
    }
}

func main() {
    let person = Person(name: "Alice", age: 30)
    person.introduce()
}

main()

