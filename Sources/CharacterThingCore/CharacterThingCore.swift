
import Foundation

public enum Race: String, CaseIterable {
	case human
	case dwarf
	case elf
	case drow
}

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


public protocol GameCharacter: AnyObject {

	var name: String { get }
	var race: Race { get }
	var playerClass: CharacterClass { get }

	var strength: Int { get set }
	var dexterity: Int { get set }
	var intellect: Int { get set }
	var wisdom: Int { get set }
	var charisma: Int { get set }
}

public class PlayerCharacter: GameCharacter {
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

public enum CharacterFactory {
	public enum CharacterGenerationError: Error {
		case invalidChoice
		case stdinAborted
	}

	public static func createCharacter() throws -> PlayerCharacter {
		var name: String
		repeat {
			name = chooseName()
		} while !confirm("Is \(name) correct?")

		var race: Race
		repeat {
			race = chooseRace()
		} while !confirm("Is \(race) correct?")

		var classChoice: CharacterClass
		repeat {
			classChoice = chooseClass()
		} while !confirm("Is \(classChoice.name) correct?")

		let newCharacter = try PlayerCharacter(name: name, race: race, playerClass: classChoice)
		return newCharacter
	}

	public static func createCharacters() {
		repeat {
			do {
				let character = try createCharacter()
				print(character, terminator: "\n\n")
			} catch {
				print("Error creating character: \(error)")
			}
		} while confirm("Continue creating another character?")
	}

	public static func chooseName() -> String {
		do {
			let choice = try chooseNameHelper()
			return choice
		} catch {
			print("Error: \(error)\n")
			return chooseName()
		}
	}

	public static func chooseNameHelper() throws -> String {
		let name = prompt("Character Name")
		guard PlayerCharacter.nameValidator(name) else {
			throw PlayerCharacter.CharacterGenerationError.invalidName
		}
		return name
	}

	public static func chooseRace() -> Race {
		do {
			let choice = try chooseRaceHelper()
			return choice
		} catch {
			print("Error: \(error)\n")
			return chooseRace()
		}
	}

	private static func chooseRaceHelper() throws -> Race {
		let allRacesString = Race.allCases
			.enumerated()
			.map { "\($0.offset + 1). \($0.element.rawValue.capitalized)" }
			.joined(separator: "\n")

		print("Choose a race from the following:\n\(allRacesString)\n[]: ", terminator: "")
		guard let choice = readLine(strippingNewline: true) else {
			throw CharacterGenerationError.stdinAborted
		}

		if let index = Int(choice), (0..<Race.allCases.count).contains(index - 1) {
			return Race.allCases[index - 1]
		} else if let race = Race(rawValue: choice.lowercased()) {
			return race
		}
		throw CharacterGenerationError.invalidChoice
	}

	public static func chooseClass() -> CharacterClass {
		do {
			let choice = try chooseClassHelper()
			return choice
		} catch {
			print("Error: \(error)\n")
			return chooseClass()
		}
	}

	private static func chooseClassHelper() throws -> CharacterClass {
		let classes: [CharacterClass] = [Warrior(), Rogue(), Mage(), Druid(), Shaman()]

		let allClassesString = classes
			.enumerated()
			.map { "\($0.offset + 1). \($0.element.name.capitalized)" }
			.joined(separator: "\n")

		print("Choose a class from the following:\n\(allClassesString)\n[]:", terminator: "")
		guard let choice = readLine(strippingNewline: true) else {
			throw CharacterGenerationError.stdinAborted
		}
		if let index = Int(choice), (0..<classes.count).contains(index - 1) {
			return classes[index - 1]
		} else if let newClass = createClass(withString: choice) {
			return newClass
		}
		throw CharacterGenerationError.invalidChoice
	}

	private static func createClass(withString string: String) -> CharacterClass? {
		switch string.lowercased() {
		case "warrior":
			return Warrior()
		case "rogue":
			return Rogue()
		case "mage":
			return Mage()
		case "druid":
			return Druid()
		case "shaman":
			return Shaman()
		default:
			return nil
		}
	}

	private static func confirm(_ prompt: String, defaultAnswer: Bool = true) -> Bool {
		let defaultAnswerStr = defaultAnswer ? "[Y/n]" : "[y/N]"
		print("\(prompt): \(defaultAnswerStr):", terminator: "")
		guard let input = readLine(strippingNewline: true) else {
			print("Invalid input. Try again.\n")
			return confirm(prompt, defaultAnswer: defaultAnswer)
		}
		if input.isEmpty {
			return defaultAnswer
		} else {
			if input.lowercased() == "y" {
				return true
			} else if input.lowercased() == "n" {
				return false
			}
			print("Invalid input. Try again.\n")
			return confirm(prompt, defaultAnswer: defaultAnswer)
		}
	}

	private static func prompt(_ userPrompt: String, defaultAnswer: String? = nil) -> String {
		let totalPrompt: String
		if let defaultAnswer = defaultAnswer {
			totalPrompt = "\(userPrompt): [\(defaultAnswer)] "
		} else {
			totalPrompt = "\(userPrompt): "
		}
		print("\(totalPrompt)", terminator: "")
		guard let input = readLine(strippingNewline: true) else {
			return prompt(userPrompt, defaultAnswer: defaultAnswer)
		}
		return input
	}
}
