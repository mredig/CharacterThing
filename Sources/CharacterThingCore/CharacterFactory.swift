import Foundation

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

	private static func confirm(_ userPrompt: String, defaultAnswer: Bool = true) -> Bool {
		let defaultAnswerStr = defaultAnswer ? "Y/n" : "y/N"
		let input = prompt(userPrompt, defaultAnswer: defaultAnswerStr)
		if input.isEmpty {
			return defaultAnswer
		} else {
			if input.lowercased() == "y" {
				return true
			} else if input.lowercased() == "n" {
				return false
			}
			print("Invalid input. Try again.\n")
			return confirm(userPrompt, defaultAnswer: defaultAnswer)
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
