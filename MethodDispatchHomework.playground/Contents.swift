import Foundation


//MARK: - Value type
// enum и struct не могут быть унаследованы, поэтому компилятор вызывает для них всегда direct dispatch
struct Cat {
    func sayMeow() {} // Direct Dispatch
}

extension Cat {
    func poop() {} // Direct Dispatch
}

// MARK: - Protocol
// key point -  Любой метод в exstension использует Direct Dispatch
protocol Animal {
    func eat() // Witness Table Dispatch
}

extension Animal {
    func washHands() {} // Direct Dispatch
}

struct Dolphin: Animal {
    func eat() {} // Direct/Witness
}

let dolphin1 = Dolphin()
let dolphin2: Animal = Dolphin()
 
dolphin1.eat() // Direct
dolphin2.eat() // Witenss Table

// MARK: - Class
// Если мы помечаем класс как final, то он не может наследоваться, поэтому будет Direct Dispatch
class Shark: Animal {
    func eat() {} // Virtual Table Dispatch
    
    @objc dynamic func swim() {} // Message Dispatch
}

extension Shark {
    func bite() {} // Direct Dispatch
    
    @objc func swimSuperFast() {} // Message Dispatch
}

final class Dog {
    func bark() {} // Direct Dispatch
}

protocol Kekable {
    func kek() 
}

class Human {}

extension Human: Kekable {
    func kek() { } // Direct / Witness
}
var human = Human()
//  если вызывать метод kek у human, то будет Direct Dispatch, но если скастить его к Kekable, то будет Witness table
