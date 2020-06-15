import Foundation

public struct RingBuffer<Element> {

    private var elements: [Element?]
    private var writeIndex: Int = 0
    private var readIndex: Int = 0

    public init(capacity: Int) {
        self.elements = Array<Element?>(repeating: nil, count: capacity)
        self.elements.reserveCapacity(capacity)
    }

    @discardableResult
    public mutating func write(_ element: Element) -> Bool {
        guard !isFull else { return false }
        elements[writeIndex % elements.count] = element
        writeIndex += 1
        return true
    }

    @discardableResult
    public mutating func read() -> Element? {
        guard !isEmpty else { return nil }
        let element = elements[readIndex % elements.count]
        readIndex += 1
        return element
    }

    public var isEmpty: Bool { writeIndex == readIndex }

    public var isFull: Bool { elements.count == (writeIndex - readIndex) }
}

extension RingBuffer: Equatable where Element: Equatable {}

extension RingBuffer: Hashable where Element: Hashable {}

extension RingBuffer: Encodable where Element: Encodable {}

extension RingBuffer: Decodable where Element: Decodable {}
