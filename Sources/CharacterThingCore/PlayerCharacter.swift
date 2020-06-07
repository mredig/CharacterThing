import Foundation

public class PlayerCharacter: CharacterProtocol {
	public enum CharacterGenerationError: Error {
		case invalidName
	}

	public let name: String
	public let race: Race
	public let playerClass: CharacterClass

	public var strength: Int
	public var dexterity: Int
	public var intellect: Int
	public var wisdom: Int
	public var charisma: Int

	private static func randomStatValueGen() -> Int {
		Int.random(in: 7...13)
	}

	public static func nameValidator(_ name: String) -> Bool {
		name.unicodeScalars.allSatisfy { CharacterSet.letters.contains($0) }
	}

	public init(name: String, race: Race, playerClass: CharacterClass, strength: Int? = nil, dexterity: Int? = nil, intellect: Int? = nil, wisdom: Int? = nil, charisma: Int? = nil) throws {
		guard Self.nameValidator(name) else {
			throw CharacterGenerationError.invalidName
		}
		self.name = name
		self.race = race
		self.playerClass = playerClass

		self.strength = strength ?? Self.randomStatValueGen()
		self.dexterity = dexterity ?? Self.randomStatValueGen()
		self.intellect = intellect ?? Self.randomStatValueGen()
		self.wisdom = wisdom ?? Self.randomStatValueGen()
		self.charisma = charisma ?? Self.randomStatValueGen()
	}
}

extension PlayerCharacter: CustomStringConvertible {
	public var description: String {
		let stats = """
		Strength: \(strength)
		Dexterity: \(dexterity)
		Intellect: \(intellect)
		Wisdom: \(wisdom)
		Charisma: \(charisma)
		"""
		return "\(name), the \(race.rawValue.lowercased()) \(playerClass.name.lowercased()) has the following stats:\n\(stats)"
	}
}
