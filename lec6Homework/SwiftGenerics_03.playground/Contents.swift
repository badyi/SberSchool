
protocol Container {
    associatedtype Element
    var count: Int { get }
    mutating func append(_ element: Element)
    mutating func append(_ array: [Element])
    func isEmpty() -> Bool
}

protocol ListProtocol: Container {
    subscript (_ index: Int) -> Element { get set }
    mutating func remove(at index: Int)
    mutating func insert(at index: Int, newValue: Element)
    func printList()
}


enum LinkedList<T> {
    case none
    indirect case element(value: T, next: LinkedList<T>)

    init() {
        self = .none
    }
}

extension LinkedList {
    private func reverse() -> LinkedList {
        var i = 0
        var temp = self
        let count = self.count
        var newList = LinkedList<T>()
        
        while i < count {
            switch temp {
            case .none:
                fatalError("Error. Index out of range")
            case let .element(value, next):
                newList.append(value)
                temp = next
                i += 1
            }
        }
        return newList
    }
    
    private func get(by index: Int) -> LinkedList {
        var i = 0
        let count = self.count
        let innerIndex = count - index - 1
        var temp = self
        
        while i != innerIndex {
            switch temp {
            case .none:
                fatalError("Error. Index out of range")
            case let .element(_, next):
                temp = next
                i += 1
            }
        }
        return temp
    }
    
    private mutating func set(newValue: T, at index: Int) {
        var i = 0
        let count = self.count
        let innerIndex = count - index - 1
        var temp = self
        var newList = LinkedList<T>()
        
        while i < count {
            switch temp {
            case .none:
                fatalError("Error. Index out of range")
            case let .element(value, next):
                if i == innerIndex {
                    newList.append(newValue)
                } else {
                    newList.append(value)
                }
                temp = next
            }
            i += 1
        }
        self = newList.reverse()
    }
    
    private func isIndexValid(_ index: Int) {
        if isEmpty() || index < 0 || index >= count {
            fatalError("index out of range")
        }
    }
}

extension LinkedList: ListProtocol {
    var count: Int {
        var i = 0
        var temp = self
        while true {
            switch temp {
            case .none:
                return i
            case let .element(_, next):
                temp = next
                i += 1
            }
        }
        return i
    }
    
    subscript(index: Int) -> T {
        get {
            isIndexValid(index)
            let element = get(by: index)
            
            switch element {
            case let .element(value,_):
                return value
            case .none:
                fatalError("list is empty")
            }
        }
        set {
            isIndexValid(index)
            set(newValue: newValue,at: index)
        }
    }
    
    mutating func remove(at index: Int) {
        isIndexValid(index)
        var i = 0
        let count = self.count
        let innerIndex = count - index - 1
        var temp = self
        var newList = LinkedList<T>()
        
        while i < count {
            switch temp {
            case .none:
                fatalError("Error. Index out of range")
            case let .element(value, next):
                if i != innerIndex {
                    newList.append(value)
                }
                temp = next
            }
            i += 1
        }
        self = newList.reverse()
    }
    
    mutating func insert(at index: Int, newValue: T) {
        isIndexValid(index)
        var i = 0
        let count = self.count
        let innerIndex = count - index - 1
        var temp = self
        var newList = LinkedList<T>()
        
        while i < count {
            switch temp {
            case .none:
                fatalError("Error. Index out of range")
            case let .element(value, next):
                if i == innerIndex {
                    newList.append(value)
                    newList.append(newValue)
                } else {
                    newList.append(value)
                }
                temp = next
            }
            i += 1
        }
        self = newList.reverse()
    }
    
    func printList() {
        let count = self.count
        for i in 0..<count {
            print(self[i])
        }
    }
    
    mutating func append(_ element: T) {
        self = .element(value: element, next: self)
    }
    
    mutating func append(_ array: [T]) {
        for i in array {
            append(i)
        }
    }
    
    func isEmpty() -> Bool {
        switch self {
        case .none:
            return true
        case .element:
            return false
        }
    }
}

var list = LinkedList<Int>()

list.append([1,2,3])
print("added to list values 1,2,3")
print("--list--")
list.printList()

list[0] = 111
list[2] = 333
print("\nchanged values at first and last index to 111 and 333")
print("--list--")
list.printList()

list.remove(at: 0)
list.remove(at: list.count - 1)
print("\nremoved first value")
print("removed last value")
print("--list--")
list.printList()

list.insert(at: 0, newValue: 77)
list.insert(at: 1, newValue: 88)
list.insert(at: list.count - 1, newValue: 99)
print("\ninserted 77 at 0,88 at 1 and 99 at last index")
print("--list--")
list.printList()
