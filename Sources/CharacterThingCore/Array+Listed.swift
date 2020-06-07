//
//  File.swift
//  
//
//  Created by Michael Redig on 6/7/20.
//

import Foundation

extension Sequence {
	func listed<T>(by keyPath: KeyPath<Element, T>, separator: String = "\n", capitalized: Bool = true) -> String {
		self.enumerated()
			.map {
				let elementValue = "\($0.element[keyPath: keyPath])"
				return "\($0.offset + 1). \(capitalized ? elementValue.capitalized : elementValue)"
			}
			.joined(separator: separator)
	}
}
