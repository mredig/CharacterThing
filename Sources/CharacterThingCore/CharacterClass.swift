import Foundation

public protocol CharacterClass: AnyObject {
	static var name: String { get }
	var name: String { get }

	init()
}

public extension CharacterClass {
	var name: String {
		Self.name
	}
}

class CharacterClasses {
	private(set) var allClasses: [CharacterClass.Type] = []

	static let shared = CharacterClasses()
	private init() {
		register(characterClass: Warrior.self)
		register(characterClass: Rogue.self)
		register(characterClass: Mage.self)
		register(characterClass: Druid.self)
		register(characterClass: Shaman.self)
	}

	func register(characterClass: CharacterClass.Type) {
		guard !allClasses.contains(where: { $0 == characterClass }) else { return }
		allClasses.append(characterClass)
	}
}

public class Warrior: CharacterClass {
	static public var name = "Warrior"
	public required init() {}
}

public class Rogue: CharacterClass {
	static public var name = "Rogue"
	public required init() {}
}

public class Mage: CharacterClass {
	static public var name = "Mage"
	public required init() {}
}

public class Druid: CharacterClass {
	static public var name = "Druid"
	public required init() {}
}

public class Shaman: CharacterClass {
	static public var name = "Shaman"
	public required init() {}
}
