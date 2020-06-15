import Foundation

/// Priority Queue is a queue where the most "important" items are at the front
/// of the queue.
/// The heap is a natural data structure for a priority queue, so this object
/// simply wraps the Heap struct.
/// All operations are O(log *n*).
/// Just like a heap can be a max-heap or min-heap, the queue can be a max-priority
/// queue (largest element first) or a min-priority queue (smallest element first).
public struct PriorityQueue<Element> {

    private var heap: Heap<Element>

    /// Creates a new priority queue.
    /// The elements are inserted into the queue in the order determined by the
    /// sort predicate.
    /// To create a max-priority queue, supply a `>` sort function.
    /// For a min-priority queue, use `<`.
    ///
    /// - Parameter sort: A predicate that returns `true` if its
    ///   first argument should not be child of its second argument;
    ///   otherwise, `false`.
    ///   For comparable data types, `>` makes a max-priority queue,
    ///   `<` makes a min-priority queue.
    public init(sort: @escaping (Element, Element) -> Bool) {
        self.heap = Heap(sort: sort)
    }

    /// A Boolean value indicating whether the queue is empty.
    ///
    /// When you need to check whether your queue is empty, use the
    /// `isEmpty` property instead of checking that the `count` property is
    /// equal to zero.
    ///
    /// - Complexity: O(1)
    public var isEmpty: Bool { heap.isEmpty }

    /// The number of elements in the queue.
    public var count: Int { heap.count }

    /// Returns the most-prioritized element in the queue.
    ///
    /// If the queue is empty, the value of this property is `nil`.
    public var peek: Element? { heap.peek }

    /// Adds a new element to the queue. This reorders the queue so that the
    /// max-priority or min-priority property still holds.
    ///
    /// - Parameter element: The element to enqueue to the queue.
    ///
    /// - Complexity: O(log *n*), where *n* is the length of the queue
    public mutating func enqueue(_ element: Element) {
        heap.insert(element)
    }

    /// Removes and returns the top element from the queue.
    /// For a max-priority queue, this is the maximum value;
    /// for a min-priority queue it is the minimum value.
    ///
    /// - Returns: The top element of the queue.
    ///
    /// - Complexity: O(log *n*), where *n* is the length of the queue.
    @discardableResult
    public mutating func dequeue() -> Element? {
        heap.remove()
    }

    /// Allows you to change the priority of an element. In a max-priority queue,
    /// the new priority should be larger than the old one; in a min-priority queue
    /// it should be smaller.
    ///
    /// - Parameter index: The index of the element to replace. `index`
    ///   must be a valid index of the queue.
    /// - Parameter newElement: The new element to replace the old one at `index`.
    ///
    /// - Complexity: O(log *n*), where *n* is the length of the queue.
    public mutating func update(at index: Int, with newElement: Element) {
        heap.replace(at: index, with: newElement)
    }

    /// Allows you to change the priority of the first element of the queue that
    /// satisfies the given predicate. In a max-priority queue, the new priority
    /// should be larger than the old one; in a min-priority queue
    /// it should be smaller.
    ///
    /// - Parameter shouldBeUpdated: A closure that takes a element of the
    ///   queue as its argument and returns a Boolean value indicating
    ///   whether the element should be updated.
    /// - Parameter newElement: The new element to replace the
    ///   predicated-matched one.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the queue.
    public mutating func updateFirst(where shouldBeUpdated: (Element) throws -> Bool,
                                     with newElement: Element) rethrows {
        try heap
            .firstIndex(where: shouldBeUpdated)
            .flatMap { update(at: $0, with: newElement) }
    }

    /// Returns the first index in which an element of the queue satisfies
    /// the given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element as its argument
    ///   and returns a Boolean value that indicates whether the passed element
    ///   represents a match.
    /// - Returns: The index of the first element for which `predicate` returns
    ///   `true`. If no elements in the queue satisfy the given predicate,
    ///   returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the queue.
    public func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        try heap.firstIndex(where: predicate)
    }
}

extension PriorityQueue where Element: Equatable {


    /// Returns the first index where the specified element appears in the queue.
    ///
    /// - Parameter element: An element to search for in the queue.
    /// - Returns: The first index where `element` is found. If `element` is not
    ///   found in the queue, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the queue.
    public func firstIndex(of element: Element) -> Int? {
        heap.firstIndex(of: element)
    }

    /// Allows you to change the priority of the first occurence of the
    /// specified element appears in the queue. In a max-priority queue,
    /// the new priority should be larger than the old one;
    /// in a min-priority queue it should be smaller.
    ///
    /// - Parameter element: An element to search for in the queue.
    /// - Parameter newElement: The new element to replace the found one.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the queue.
    public mutating func updateFirst(element: Element, with newElement: Element) {
        firstIndex(of: element).flatMap { update(at: $0, with: newElement) }
     }
}

extension PriorityQueue: Sequence {

    public func makeIterator() -> AnyIterator<Element> {
        var current = self
        return AnyIterator<Element> { current.dequeue() }
    }
}

extension PriorityQueue: CustomStringConvertible, CustomDebugStringConvertible {

    /// A textual representation of the queue and its elements.
    public var description: String { heap.description }

    /// A textual representation of the queue and its elements, suitable for
    /// debugging.
    public var debugDescription: String { heap.debugDescription }
}

extension PriorityQueue: CustomReflectable {

    public var customMirror: Mirror {
        Mirror(self, children: heap.customMirror.children)
    }
}
