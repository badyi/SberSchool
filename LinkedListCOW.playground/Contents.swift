import Foundation

class Node<T> {
    var value: T
    var next: Node<T>?
    
    init(with value: T, next: Node<T>? = nil) {
        self.value = value
        self.next = next
    }
}

struct LinkedList<T> {
    var head: Node<T>?
    public private(set) var count: Int
    
    init() {
        head = nil
        count = 0
    }
    
    //MARK: - is empty
    func isEmpty() -> Bool {
        return head == nil
    }
    
    //MARK: - push, subscript, remove, insert
    mutating func push(_ value: T) {
        count = count + 1
        if head == nil {
            self.head = Node<T>(with: value)
        } else {
            simpleCopy()
            push(head!, value)
        }
    }
        
    subscript (_ index: Int) -> T {
        get {
            if isEmpty() || index < 0 || index >= count {
                fatalError("index out of range")
            }
        
            return get(by: index)!.value
        }
        
        set {
            if isEmpty() || index < 0 || index >= count {
                fatalError("index out of range")
            }
            simpleCopy()
            get(by: index)?.value = newValue
            //O(n+n)
        }
    }
    
    mutating func remove(at index: Int) {
        if isEmpty() || index < 0 || index >= count {
            fatalError("index out of range")
        }
        simpleCopy()
        if index == 0 {
            self.head = self.head?.next
        } else {
            let prevNode = get(by: index - 1)
            let nextNode = get(by: index + 1)
            prevNode?.next = nextNode
        }
        count -= 1
        //O(3n)
    }
    
    mutating func insert(in index: Int, value: T) {
        if isEmpty() || index < 0 || index >= count {
            fatalError("index out of range")
        }
        simpleCopy()
        
        if index == 0 {
            let node = Node(with: value, next: head)
            head = node
        } else {
            let newNode = Node(with: value)
            let prevNode = get(by: index - 1)
            let currentNode = get(by: index)
            prevNode?.next = newNode
            newNode.next = currentNode
        }
        count += 1
    }
    
    //MARK: - print
    func printList() {
        if isEmpty() {
            print("List is empty")
            return
        }
        var node: Node<T>? = head
        
        while node != nil {
            print(node?.value ?? "No value")
            node = node?.next
        }
    }

}

extension LinkedList {
    private mutating func simpleCopy() {
        guard !isKnownUniquelyReferenced(&head) else { return }
        guard var oldNode = head else { return }
        
        head = Node(with: oldNode.value)
        var newNode = head
        while let nextOldNode = oldNode.next {
            newNode!.next = Node(with: nextOldNode.value)
            newNode = newNode!.next
            oldNode = nextOldNode
        }
    }

    /*private mutating func copy(of node: Node<T>) -> Node<T>? {
        guard !isKnownUniquelyReferenced(&head) else {
            return nil }
        guard var oldNode = head else { return nil }
        
        head = Node(with: oldNode.value)
        
        var newNode = head
        var nodeCopy: Node<T>?
        while let oldNextNode = oldNode.next {
            if oldNode === node {
                nodeCopy = oldNode
            }
            newNode?.next = Node<T>(with: oldNextNode.value)
            newNode = newNode?.next
            oldNode = oldNextNode
        }
        return nodeCopy
    } */
    
    private func get(by index: Int) -> Node<T>? {
        var node = head
        for _ in 0..<index {
            node = node?.next
        }
        return node
    }
    
    private mutating func push(_ currentNode: Node<T>,_ value: T) {
        guard let nextNode = currentNode.next else {
            currentNode.next = Node<T>(with: value)
            return
        }
        
        push(nextNode, value)
    }
}

//MARK: - Example
var list1 = LinkedList<Int>()
list1.push(1)
list1.push(2)
list1.push(3)

print("--List1--")
list1.printList()

print("\nlist2 = list1\n")
var list2 = LinkedList<Int>()
list2 = list1

print(" list1 head addres - \(Unmanaged.passUnretained(list1.head!).toOpaque())\n list2 head addres - \(Unmanaged.passUnretained(list2.head!).toOpaque()) \n")
print("--List2--")
list2.printList()

print("\nchange values of list1 to [11, 22, 33]\n")
list1[0] = 11
list1[1] = 22
list1[2] = 33

print("push to list1 value 9 and push to list2 value 99\n")

list1.push(9)
list2.push(99)


print("--List1--")
list1.printList()

print("--List2--")
list2.printList()

print("remove form list1 firts value and remove from list2 last value\n")
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

print("\n list1 - head addres - \(Unmanaged.passUnretained(list1.head!).toOpaque())\n list2 - head address - \(Unmanaged.passUnretained(list2.head!).toOpaque()) \n")
