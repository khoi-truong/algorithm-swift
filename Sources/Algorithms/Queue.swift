import Foundation

public struct Queue<Element> {

    private var elements: [Element?]
    private var head: Int

    public var isEmpty: Bool { count == 0 }

    public var count: Int { elements.count - head }

    public mutating func enqueue(_ element: Element) {
        elements.append(element)
    }

    @discardableResult
    public mutating func dequeue() -> Element? {
        guard head < elements.count, let element = elements[head] else { return nil }
        elements[head] = nil
        head += 1
        trim()
        return element
    }

    private mutating func trim() {
        let percentage = Double(head) / Double(elements.count)
        if elements.count > 50 && percentage > 0.25 {
            elements.removeFirst(head)
            head = 0
        }
    }

    public var front: Element? { isEmpty ? nil : elements[head] }

    public init() {
        self.elements = [Element?]()
        self.head = 0
    }
}

extension Queue: Equatable where Element: Equatable {}

extension Queue: Hashable where Element: Hashable {}

extension Queue: Encodable where Element: Encodable {}

extension Queue: Decodable where Element: Decodable {}

public struct SlowQueue<Element> {

    private var elements: [Element]

    public var isEmpty: Bool { elements.isEmpty }

    public var count: Int { elements.count }

    public mutating func enqueue(_ element: Element) {
        elements.append(element)
    }

    @discardableResult
    public mutating func dequeue() -> Element? {
        isEmpty ? nil : elements.removeFirst()
    }

    public var front: Element? { elements.first }

    public init() {
        self.elements = [Element]()
    }
}
