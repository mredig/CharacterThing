import Foundation

public protocol CharacterClass: AnyObject {
	static var name: String { get }
	var name: String { get }
}

public extension CharacterClass {
	var name: String {
		Self.name
	}
}

public class Warrior: CharacterClass {
	static public var name = "Warrior"
}

public class Rogue: CharacterClass {
	static public var name = "Rogue"
}

public class Mage: CharacterClass {
	static public var name = "Mage"
}

public class Druid: CharacterClass {
	static public var name = "Druid"
}

public class Shaman: CharacterClass {
	static public var name = "Shaman"
}
