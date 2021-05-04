import Foundation

// MARK: - Задача 2

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
    mutating func insert(in index: Int, value: Element)
    func printList()
}

protocol QueueProtocol: Container {
    mutating func dequeue() -> Element?
    mutating func peek() -> Element?
    func printQueue()
}

final class Node<T> {
    var value: T
    var next: Node<T>?
    var previous: Node<T>?
    
    init(with value: T, next: Node<T>? = nil, previous: Node<T>? = nil) {
        self.value = value
        self.next = next
        self.previous = previous
    }
}

// Односвязный список
struct LinkedList<T>: ListProtocol {
    private var _head: Node<T>?
    public private(set) var count: Int
    
    init() {
        _head = nil
        count = 0
    }
    
    //MARK: - is empty
    func isEmpty() -> Bool {
        return _head == nil
    }
    
    //MARK: - push, subscript, remove, insert
    mutating func append(_ element: T) {
        count = count + 1
        if _head == nil {
            self._head = Node<T>(with: element)
        } else {
            simpleCopy()
            append(_head!, element)
        }
    }
    
    mutating func append(_ array: [T]) {
        for i in array {
            append(i)
        }
    }
        
    subscript (_ index: Int) -> T {
        get {
            isIndexValid(index)
        
            return get(by: index)!.value
        }
        
        set {
            isIndexValid(index)
            simpleCopy() // COW
            get(by: index)?.value = newValue
            //O(n+n)
        }
    }
    
    mutating func remove(at index: Int) {
        isIndexValid(index)
        simpleCopy() // COW
        if index == 0 {
            self._head = self._head?.next
        } else {
            let prevNode = get(by: index - 1)
            let nextNode = get(by: index + 1)
            prevNode?.next = nextNode
        }
        count -= 1
        //O(3n)
    }
    
    mutating func insert(in index: Int, value: T) {
        isIndexValid(index)
        simpleCopy() // COW
        
        if index == 0 {
            let node = Node(with: value, next: _head)
            _head = node
        } else {
            let newNode = Node(with: value)
            let prevNode = get(by: index - 1)
            let currentNode = get(by: index)
            prevNode?.next = newNode
            newNode.next = currentNode
        }
        count += 1
        //O(3n)
    }
    
    //MARK: - print
    func printList() {
        if isEmpty() {
            print("List is empty")
            return
        }
        var node: Node<T>? = _head
        
        while node != nil {
            print(node?.value ?? "No value")
            node = node?.next
        }
    }

}

extension LinkedList {
    private func isIndexValid(_ index: Int) {
        if isEmpty() || index < 0 || index >= count {
            fatalError("index out of range")
        }
    }
    
    private mutating func simpleCopy() { // COW Mechanism
        guard !isKnownUniquelyReferenced(&_head) else { return }
        guard var oldNode = _head else { return }
        
        _head = Node(with: oldNode.value)
        var newNode = _head
        while let nextOldNode = oldNode.next {
            newNode!.next = Node(with: nextOldNode.value)
            newNode = newNode!.next
            oldNode = nextOldNode
        }
    }
    
    private func get(by index: Int) -> Node<T>? {
        var node = _head
        for _ in 0..<index {
            node = node?.next
        }
        return node
    }
    
    private mutating func append(_ currentNode: Node<T>,_ value: T) {
        guard let nextNode = currentNode.next else {
            currentNode.next = Node<T>(with: value)
            return
        }
        
        append(nextNode, value)
    }
}

struct Queue<T>: QueueProtocol {
    private var _head: Node<T>?
    private var _tail: Node<T>?
    private var referenceFlag: Flag // необходим для проверка на isUnqiueReferenced при использовании COW
    public private(set) var count: Int
    private class Flag {}
    
    init() {
        _head = nil
        _tail = nil
        referenceFlag = Flag()
        count = 0
    }
    
    func isEmpty() -> Bool {
        return count == 0
    }
    
    mutating func append(_ element: T) {
        copy() // COW
        if _head == nil {
            _head = Node<T>(with: element)
            _tail = _head
        } else {
            let oldTail = _tail
            let newTail = Node(with: element, previous: oldTail)
            oldTail?.next = newTail
            _tail = newTail
        }
        count += 1
        //O(1)
    }
    
    
    mutating func append(_ array: [T]) {
        for i in array {
            append(i)
        }
    }
    
    mutating func dequeue() -> T? {
        copy() // COW
        let oldHead = _head
        _head = _head?.next
        _head?.previous = nil
        count -= 1
        return oldHead?.value
        //O(1)
    }
    
    mutating func peek() -> T? {
        return _head?.value
    }
    
    func printQueue() {
        if isEmpty() {
            print("Queue is empty")
            return
        }
        var node: Node<T>? = _head
        
        while node != nil {
            print(node?.value ?? "No value")
            node = node?.next
        }
    }
}

extension Queue {
    private mutating func copy() {
        guard !isKnownUniquelyReferenced(&referenceFlag) else { return }
        guard var oldNode = _head else { return }
        
        referenceFlag = Flag()
        _head = Node(with: oldNode.value)
        var newNode = _head
        while let nextOldNode = oldNode.next {
            newNode!.next = Node(with: nextOldNode.value, previous: newNode?.previous)
            newNode = newNode!.next
            oldNode = nextOldNode
            _tail = newNode
        }
    }
}


var list1 = LinkedList<Int>()
list1.append([1,2,3])
print("--List1--")
list1.printList()

print("\nlist2 = list1\n")
var list2 = LinkedList<Int>()
list2 = list1

print("--List2--")
list2.printList()

print("\nchange values of list1 to [11, 22, 33]\n")
list1[0] = 11
list1[1] = 22
list1[2] = 33

print("append to list1 value 9 and push to list2 value 99\n")

list1.append(9)
list2.append(99)

print("--List1--")
list1.printList()

print("--List2--")
list2.printList()

print("\nremove form list1 firts value and remove from list2 last value\n")
list1.remove(at: 0)
list2.remove(at: list2.count - 1)

print("--List1--")
list1.printList()

print("--List2--")
list2.printList()

print("\ninsert into list1 at index 1 value 9999 - insert into list2 at index 2 and at last index values 0 and 444\n")
list1.insert(in: 0, value: 9999)
list2.insert(in: 2, value: 0)
list2.insert(in: list2.count - 1, value: 444)

print("--List1--")
list1.printList()

print("--List2--")
list2.printList()

print("\n-----------Queue-------------")

var q1 = Queue<Int>()
q1.append([1,2,3])
print("\nqueue1 values after adding [1, 2, 3]\n")
print("--queue1--")
q1.printQueue()

print("\nq2 = q1")
var q2 = q1
print("--queue2--")
q2.printQueue()

q2.append(999)
q1.dequeue()
q1.dequeue()
print("\nadding 999 to q2 and dequeue q1 twice\n")

print("---queue2---")
q2.printQueue()
print("---queue1---")
q1.printQueue()

print("\nadding to q1 values [2222,3333,4444]]\nadding 99999999 to q2")
q1.append([2222,3333,4444])
q2.append(99999999)

print("---queue1---")
q1.printQueue()
print("---queue2---")
q2.printQueue()
