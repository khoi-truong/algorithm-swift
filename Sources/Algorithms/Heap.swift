import Foundation

/// Heap data structure is a complete binary tree that satisfies the heap property.
/// It is also called as a binary heap.
///
/// A complete binary tree is a special binary tree in which
/// - every level, except possibly the last, is filled
/// - all the nodes are as far left as possible
///
/// Heap Property is the property of a node in which
/// - *(for max heap)* key of each node is always greater than its child node/s
/// and the key of the root node is the largest among all other nodes;
/// - *(for min heap)* key of each node is always smaller than the child node/s
/// and the key of the root node is the smallest among all other nodes.
public struct Heap<Node> {

    private var nodes: [Node]
    private let areInParentToChildrenOrder: (Node, Node) -> Bool

    /// Creates a new empty heap.
    /// The nodes are inserted into the heap in the order determined by the
    /// sort predicate.
    ///
    /// - Parameter sort: A predicate that returns `true` if its
    ///   first argument should not be child of its second argument;
    ///   otherwise, `false`.
    ///   For comparable data types, `>` makes a max-heap, `<` makes a min-heap.
    public init(sort: @escaping (Node, Node) -> Bool) {
        self.init(nodes: [Node](), sort: sort)
    }

    /// Creates a new heap containing the nodes of a sequence.
    /// The order of the array does not matter;
    /// the nodes are inserted into the heap in the order determined by the
    /// sort predicate.
    /// 
    /// Here's an example of creating a max-heap initialized with five integers.
    ///
    ///     let heap = Heap(nodes: [9, 7, 3, 21, 4], sort: >)
    ///     print(heap.peak)
    ///     // Prints "21"
    ///
    /// - Parameter nodes: The sequence of nodes for the new collection.
    ///
    /// - Parameter sort: A predicate that returns `true` if its
    ///   first argument should not be child of its second argument;
    ///   otherwise, `false`.
    ///   For comparable data types, `>` makes a max-heap, `<` makes a min-heap.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the heap.
    public init<S>(nodes: S,
                   sort: @escaping (Node, Node) -> Bool) where S: Sequence, S.Element == Node {

        self.nodes = Array<Node>(nodes)
        self.areInParentToChildrenOrder = sort
        self.buildHeap()
    }

    /// A Boolean value indicating whether the heap is empty.
    ///
    /// When you need to check whether your heap is empty, use the
    /// `isEmpty` property instead of checking that the `count` property is
    /// equal to zero.
    ///
    /// - Complexity: O(1)
    public var isEmpty: Bool { nodes.isEmpty }

    /// The number of nodes in the heap.
    public var count: Int { nodes.count }

    /// Returns the maximum value in the heap (for a max-heap) or the minimum
    /// value (for a min-heap).
    ///
    /// If the heap is empty, the value of this property is `nil`.
    public var peek: Node? { nodes.first }


    /// Adds a new value to the heap. This reorders the heap so that the max-heap
    /// or min-heap property still holds.
    ///
    /// - Parameter node: The node to insert to the heap.
    ///
    /// - Complexity: O(log *n*), where *n* is the length of the heap.
    public mutating func insert(_ node: Node) {
        nodes.append(node)
        shiftUp(index: nodes.count - 1)
    }

    /// Adds a sequence of values to the heap. This reorders the heap so that
    /// the max-heap or min-heap property still holds.
    ///
    /// - Parameter nodes: The nodes to insert to the heap.
    ///
    /// - Complexity: O(log *n*), where *n* is the length of the heap.
    public mutating func insert<S>(contentOf nodes: S) where S: Sequence, S.Element == Node {
        nodes.forEach { insert($0) }
    }

    /// Allows you to change a node. This reorders the heap so that
    /// the max-heap or min-heap property still holds.
    ///
    /// - Parameter index: The index of the node to replace. `index`
    ///   must be a valid index of the heap.
    ///
    /// - Parameter newNode: The new node to replace the old one at `index`.
    ///
    /// - Complexity: O(log *n*), where *n* is the length of the heap.
    public mutating func replace(at index: Int, with newNode: Node) {
        guard index < nodes.count else { return }
        remove(at: index)
        insert(newNode)
    }

    /// Removes and returns the root node from the heap.
    /// For a max-heap, this is the maximum value;
    /// for a min-heap it is the minimum value.
    ///
    /// - Returns: The root node of the heap.
    ///
    /// - Complexity: O(log *n*), where *n* is the length of the heap.
    @discardableResult
    public mutating func remove() -> Node? {
        guard !nodes.isEmpty else { return nil }
        guard nodes.count > 1 else { return nodes.removeLast() }

        // Use the last node to replace the first one, then fix the heap by
        // shifting this new first node into its proper position.
        let value = nodes[0]
        nodes[0] = nodes.removeLast()
        shiftDown(index: 0)
        return value
    }

    /// Removes and returns the node at specified index from the heap.
    /// For a max-heap, this is the maximum value;
    /// for a min-heap it is the minimum value.
    ///
    /// - Returns: The removed node.
    /// - Parameter index: The index of the node to remove. `index`
    ///   must be a valid index of the heap.
    ///
    /// - Complexity: O(log *n*), where *n* is the length of the heap.
    @discardableResult
    public mutating func remove(at index: Int) -> Node? {
        guard index < nodes.count else { return nil }

        let size = nodes.count - 1
        if index != size {
            nodes.swapAt(index, size)
            shiftDown(from: index, until: size)
            shiftUp(index: index)
        }
        return nodes.removeLast()
    }

    /// Removes and returns the first node of the heap that satisfies the given predicate.
    ///
    /// - Parameter shouldBeRemoved: A closure that takes a node of the
    ///   heap as its argument and returns a Boolean value indicating
    ///   whether the node should be removed from the heap.
    /// - Returns: The removed node.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the heap.
    @discardableResult
    public mutating func removeFirst(where shouldBeRemoved: (Node) throws -> Bool) rethrows -> Node? {
        try firstIndex(where: shouldBeRemoved).flatMap { remove(at: $0) }
    }

    /// Returns the first index in which a node of the heap satisfies
    /// the given predicate.
    ///
    /// - Parameter predicate: A closure that takes a node as its argument
    ///   and returns a Boolean value that indicates whether the passed node
    ///   represents a match.
    /// - Returns: The index of the first node for which `predicate` returns
    ///   `true`. If no nodes in the heap satisfy the given predicate,
    ///   returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the heap.
    public func firstIndex(where predicate: (Node) throws -> Bool) rethrows -> Int? {
        try nodes.firstIndex(where: predicate)
    }

    // MARK: - Private

    /// Build the max-heap or min-heap from an array, in a bottom-up manner.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the heap.
    private mutating func buildHeap() {
        stride(from: (nodes.count / 2 - 1), through: 0, by: -1).forEach { shiftDown(index: $0) }
    }

    /// Takes a child node and looks at its parents; if a parent is not larger
    /// (max-heap) or not smaller (min-heap) than the child, we exchange them.
    private mutating func shiftUp(index: Int) {
        var newIndex = index
        let child = nodes[newIndex]
        var parentIndex = HeapHelper.parentIndex(ofIndex: newIndex)

        while newIndex > 0 && !areInParentToChildrenOrder(nodes[parentIndex], child) {
            nodes[newIndex] = nodes[parentIndex]
            newIndex = parentIndex
            parentIndex = HeapHelper.parentIndex(ofIndex: newIndex)
        }
        nodes[newIndex] = child
    }

    /// Looks at a parent node and makes sure it is still larger (max-heap) or
    /// smaller (min-heap) than its childeren.
    private mutating func shiftDown(index: Int) {
        shiftDown(from: index, until: nodes.count)
    }

    /// Looks at a parent node and makes sure it is still larger (max-heap) or
    /// smaller (min-heap) than its childeren.
    ///
    /// Figure out which comes first if we order them by the sort function:
    /// the parent, the left child, or the right child. If the parent comes
    /// first, we're done. If not, that node is out-of-place and we make
    /// it "float down" the tree until the heap property is restored.
    private mutating func shiftDown(from index: Int, until endIndex: Int) {
        var leftChildIndex: Int = 0
        var rightChildIndex: Int = 0

        var previous = index
        var current = index
        while current < endIndex {
            previous = current
            leftChildIndex = HeapHelper.leftChildIndex(ofIndex: previous)
            rightChildIndex = leftChildIndex + 1
            if leftChildIndex < endIndex,
                !areInParentToChildrenOrder(nodes[current], nodes[leftChildIndex]) {
                current = leftChildIndex
            }
            if rightChildIndex < endIndex,
                !areInParentToChildrenOrder(nodes[current], nodes[rightChildIndex]) {
                current = rightChildIndex
            }
            if current == previous { return }
            nodes.swapAt(previous, current)
        }
    }
}

extension Heap: Sequence {

    public func makeIterator() -> AnyIterator<Node> {
        var current = self
        return AnyIterator { current.remove() }
    }
}

extension Heap where Node: Equatable {

    /// Returns the first index where the specified node appears in the heap.
    ///
    /// - Parameter node: A node to search for in the heap.
    /// - Returns: The first index where `node` is found. If `node` is not
    ///   found in the heap, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the heap.
    public func firstIndex(of node: Node) -> Int? {
        firstIndex(where: { $0 == node })
    }

    /// Removes and returns the first occurence of the specified node appears
    /// in the heap.
    ///
    /// - Parameter node: A node to search for in the heap.
    /// - Returns: The removed node. If `node` is not
    ///   found in the heap, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the heap.
    @discardableResult
    public mutating func removeFirst(node: Node) -> Node? {
        firstIndex(of: node).flatMap { remove(at: $0) }
     }
}

extension Heap: CustomStringConvertible, CustomDebugStringConvertible {

    /// A textual representation of the heap and its nodes.
    public var description: String { nodes.description }

    /// A textual representation of the heap and its nodes, suitable for
    /// debugging.
    public var debugDescription: String { nodes.debugDescription }
}

extension Heap: CustomReflectable {

    public var customMirror: Mirror {
        Mirror(self, children: nodes.customMirror.children)
    }
}

enum HeapHelper {
    /// Returns the index of the parent of the node at index i.
    /// The node at index 0 is the root of the tree and has no parent.
    static func parentIndex(ofIndex index: Int) -> Int { (index - 1) / 2 }

    /// Returns the index of the left child of the node at index i.
    /// Note that this index can be greater than the heap size, in which case
    /// there is no left child.
    static func leftChildIndex(ofIndex index: Int) -> Int { 2 * index + 1 }

    /// Returns the index of the right child of the node at index i.
    /// Note that this index can be greater than the heap size, in which case
    /// there is no right child.
    static func rightChildIndex(ofIndex index: Int) -> Int { 2 * index + 2 }
}
