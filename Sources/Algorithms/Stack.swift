import Foundation

public struct Stack<Element> {

    private var elements: [Element]

    public var isEmpty: Bool { elements.isEmpty }

    public var count: Int { elements.count }

    public mutating func push(_ element: Element) {
        elements.append(element)
    }

    @discardableResult
    public mutating func pop() -> Element? {
        elements.popLast()
    }

    public var top: Element? { elements.last }

    public init() {
        self.elements = [Element]()
    }
}

extension Stack: Equatable where Element: Equatable {}

extension Stack: Hashable where Element: Hashable {}

extension Stack: Encodable where Element: Encodable {}

extension Stack: Decodable where Element: Decodable {}

extension Stack: Sequence {

    public func makeIterator() -> AnyIterator<Element> {
        var current = self
        return AnyIterator { current.pop() }
    }
}
