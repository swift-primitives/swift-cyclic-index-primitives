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

// MARK: - Static Typealias

extension Tagged where Underlying == Ordinal, Tag: ~Copyable & ~Escapable {
    /// A cyclic index where arithmetic wraps modulo N (compile-time modulus).
    ///
    /// `Index<Tag>.Cyclic<N>` aliases `Tagged<Tag, Cyclic.Group.Static<N>.Element>`.
    /// Use this for ring buffer indices, circular navigation, and other
    /// bounded cyclic access patterns with known capacity.
    ///
    /// ## Example
    ///
    /// ```swift
    /// var idx = try Index<MyTag>.Cyclic<5>.init(Ordinal(4))
    /// idx += .one  // Wraps to 0
    /// idx -= .one  // Wraps to 4
    /// ```
    public typealias Cyclic<let N: Int> = Tagged<Tag, Cyclic_Primitives.Cyclic.Group.Static<N>.Element>
}

// MARK: - Operators (Tagged + Tagged)
//
// These operators are provided by Cyclic_Primitives (Tagged+Cyclic.Group.Static.Element.swift).
// Re-exported via this module's exports.swift.

// MARK: - Operators (Tagged + Element) — enables .zero/.one syntax

/// Adds a cyclic group element to a tagged cyclic index, wrapping modulo N.
public func + <Tag: ~Copyable & ~Escapable, let N: Int>(
    lhs: Tagged<Tag, Cyclic.Group.Static<N>.Element>,
    rhs: Cyclic.Group.Static<N>.Element
) -> Tagged<Tag, Cyclic.Group.Static<N>.Element> {
    Tagged(_unchecked: lhs.underlying + rhs)
}

/// Subtracts a cyclic group element from a tagged cyclic index, wrapping modulo N.
public func - <Tag: ~Copyable & ~Escapable, let N: Int>(
    lhs: Tagged<Tag, Cyclic.Group.Static<N>.Element>,
    rhs: Cyclic.Group.Static<N>.Element
) -> Tagged<Tag, Cyclic.Group.Static<N>.Element> {
    Tagged(_unchecked: lhs.underlying - rhs)
}

/// Adds a cyclic group element into a tagged cyclic index in place, wrapping modulo N.
public func += <Tag: ~Copyable & ~Escapable, let N: Int>(
    lhs: inout Tagged<Tag, Cyclic.Group.Static<N>.Element>,
    rhs: Cyclic.Group.Static<N>.Element
) { lhs = Tagged(_unchecked: lhs.underlying + rhs) }

/// Subtracts a cyclic group element from a tagged cyclic index in place, wrapping modulo N.
public func -= <Tag: ~Copyable & ~Escapable, let N: Int>(
    lhs: inout Tagged<Tag, Cyclic.Group.Static<N>.Element>,
    rhs: Cyclic.Group.Static<N>.Element
) { lhs = Tagged(_unchecked: lhs.underlying - rhs) }

// MARK: - Construction from Ordinal

extension Tagged where Tag: ~Copyable & ~Escapable {
    /// Creates a cyclic index from an ordinal position.
    ///
    /// - Parameter position: The ordinal position (must be in `0..<N`).
    /// - Throws: `Cyclic.Group.Static<N>.Element.Error.outOfBounds` if position is invalid.
    public init<let N: Int>(_ position: Ordinal) throws(Cyclic_Primitives.Cyclic.Group.Static<N>.Element.Error)
    where Underlying == Cyclic_Primitives.Cyclic.Group.Static<N>.Element {
        self.init(_unchecked: try Cyclic_Primitives.Cyclic.Group.Static<N>.Element(position))
    }

    /// Creates a cyclic index without bounds checking.
    ///
    /// - Parameter position: Must be in `0..<N`.
    /// - Warning: No validation is performed. Use only when the value
    ///   is known to be in bounds.
    public init<let N: Int>(__unchecked position: Ordinal)
    where Underlying == Cyclic_Primitives.Cyclic.Group.Static<N>.Element {
        self.init(_unchecked: Cyclic_Primitives.Cyclic.Group.Static<N>.Element(__unchecked: position))
    }
}

// MARK: - Construction from Int (convenience)

extension Tagged where Tag: ~Copyable & ~Escapable {
    /// Creates a cyclic index from an integer position.
    ///
    /// - Parameter position: The position value (must be in `0..<N`).
    /// - Throws: `Cyclic.Group.Static<N>.Element.Error.outOfBounds` if position is invalid.
    public init<let N: Int>(_ position: Int) throws(Cyclic_Primitives.Cyclic.Group.Static<N>.Element.Error)
    where Underlying == Cyclic_Primitives.Cyclic.Group.Static<N>.Element {
        guard position >= 0 else {
            throw .outOfBounds(position)
        }
        self.init(_unchecked: try Cyclic_Primitives.Cyclic.Group.Static<N>.Element(Ordinal(UInt(position))))
    }

    /// Creates a cyclic index without bounds checking.
    ///
    /// - Parameter position: Must be in `0..<N`.
    /// - Warning: No validation is performed. Use only when the value
    ///   is known to be in bounds.
    public init<let N: Int>(__unchecked position: Int)
    where Underlying == Cyclic_Primitives.Cyclic.Group.Static<N>.Element {
        self.init(_unchecked: Cyclic_Primitives.Cyclic.Group.Static<N>.Element(__unchecked: Ordinal(UInt(position))))
    }
}
