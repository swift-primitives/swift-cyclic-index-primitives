// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Cyclic_Primitives

// MARK: - Dynamic Modular Index Operations

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {
    /// Namespace for dynamic modular index operations.
    ///
    /// Provides cyclic/modular arithmetic operations for indices with runtime capacity.
    /// Use these operations for ring buffers and circular data structures where
    /// capacity is not known at compile time.
    ///
    /// For compile-time capacity, use `Index<Tag>.Cyclic<N>` instead.
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let capacity: Index<Element>.Count = ...
    /// var head: Index<Element> = .zero
    ///
    /// // Advance with wrapping
    /// head = Index<Element>.Modular.successor(of: head, capacity: capacity)
    ///
    /// // Convert logical to physical index
    /// let physical = Index<Element>.Modular.physical(
    ///     forLogical: logicalIndex,
    ///     head: head,
    ///     capacity: capacity
    /// )
    /// ```
    public enum Modular {}
}

extension Tagged.Modular where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {
    /// Advances an index by one position, wrapping at capacity.
    ///
    /// - Parameters:
    ///   - index: The current index.
    ///   - capacity: The buffer capacity (must be positive).
    /// - Returns: The successor index wrapped to `0..<capacity`.
    /// - Complexity: O(1)
    @inlinable
    public static func successor(
        of index: Index<Tag>,
        capacity: Index<Tag>.Count
    ) -> Index<Tag> {
        let modulus = Cyclic_Primitives.Cyclic.Group.Modulus(__unchecked: capacity)
        let element = Cyclic_Primitives.Cyclic.Group.Element(__unchecked: index)
        let result = Cyclic_Primitives.Cyclic.Group.successor(element, modulus: modulus)
        return Index<Tag>(result.residue)
    }

    /// Retreats an index by one position, wrapping at capacity.
    ///
    /// - Parameters:
    ///   - index: The current index.
    ///   - capacity: The buffer capacity (must be positive).
    /// - Returns: The predecessor index wrapped to `0..<capacity`.
    /// - Complexity: O(1)
    @inlinable
    public static func predecessor(
        of index: Index<Tag>,
        capacity: Index<Tag>.Count
    ) -> Index<Tag> {
        let modulus = Cyclic_Primitives.Cyclic.Group.Modulus(__unchecked: capacity)
        let element = Cyclic_Primitives.Cyclic.Group.Element(__unchecked: index)
        let result = Cyclic_Primitives.Cyclic.Group.predecessor(element, modulus: modulus)
        return Index<Tag>(result.residue)
    }

    /// Advances an index by an offset, wrapping at capacity.
    ///
    /// - Parameters:
    ///   - index: The starting index.
    ///   - offset: The offset to advance by (can be negative).
    ///   - capacity: The buffer capacity (must be positive).
    /// - Returns: The resulting index wrapped to `0..<capacity`.
    /// - Complexity: O(1)
    @inlinable
    public static func advanced(
        _ index: Index<Tag>,
        by offset: Index<Tag>.Offset,
        capacity: Index<Tag>.Count
    ) -> Index<Tag> {
        let modulus = Cyclic_Primitives.Cyclic.Group.Modulus(__unchecked: capacity)
        let element = Cyclic_Primitives.Cyclic.Group.Element(__unchecked: index)
        let result = Cyclic_Primitives.Cyclic.Group.advanced(element, by: offset, modulus: modulus)
        return Index<Tag>(result.residue)
    }

    /// Calculates the physical index from a logical index in a ring buffer.
    ///
    /// Converts a logical index (0 = front of queue) to a physical storage position
    /// given the current head position.
    ///
    /// - Parameters:
    ///   - logicalIndex: The logical index (0..<count).
    ///   - head: The physical position of the first element.
    ///   - capacity: The buffer capacity.
    /// - Returns: The physical storage index.
    /// - Complexity: O(1)
    @inlinable
    public static func physical(
        forLogical logicalIndex: Index<Tag>,
        head: Index<Tag>,
        capacity: Index<Tag>.Count
    ) -> Index<Tag> {
        let modulus = Cyclic_Primitives.Cyclic.Group.Modulus(__unchecked: capacity)
        let headElement = Cyclic_Primitives.Cyclic.Group.Element(__unchecked: head)
        let logicalElement = Cyclic_Primitives.Cyclic.Group.Element(__unchecked: logicalIndex)
        let result = Cyclic_Primitives.Cyclic.Group.add(headElement, logicalElement, modulus: modulus)
        return Index<Tag>(result.residue)
    }
}
