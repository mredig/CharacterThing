import Foundation

public struct CharacterFactory {
	public enum CharacterGenerationError: Error {
		case invalidChoice
		case stdinAborted
	}

	public init() {}

	public func createCharacter() throws -> PlayerCharacter {
		var name: String
		repeat {
			name = chooseOption(chooseNameHelper)
		} while !confirm("Is \(name) correct?")

		var race: Race
		repeat {
			race = chooseOption(chooseRaceHelper)
		} while !confirm("Is \(race) correct?")

		var classChoice: CharacterClass
		repeat {
			classChoice = chooseOption(chooseClassHelper)
		} while !confirm("Is \(classChoice) correct?")

		let newCharacter = try PlayerCharacter(name: name, race: race, playerClass: classChoice)
		return newCharacter
	}

	public func createCharacters() {
		repeat {
			do {
				let character = try createCharacter()
				print(character, terminator: "\n\n")
			} catch {
				print("Error creating character: \(error)")
			}
		} while confirm("Continue creating another character?")
	}

	public func chooseNameHelper() throws -> String {
		let name = prompt("Character Name")
		guard PlayerCharacter.nameValidator(name) else {
			throw PlayerCharacter.CharacterGenerationError.invalidName
		}
		return name
	}

	private func chooseRaceHelper() throws -> Race {
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

	private func chooseClassHelper() throws -> CharacterClass {
		let classes = CharacterClasses.shared.allClasses

		let allClassesString = CharacterClasses.shared.allClasses
			.enumerated()
			.map { "\($0.offset + 1). \($0.element.name.capitalized)" }
			.joined(separator: "\n")

		print("Choose a class from the following:\n\(allClassesString)\n[]:", terminator: "")
		guard let choice = readLine(strippingNewline: true) else {
			throw CharacterGenerationError.stdinAborted
		}
		if let index = Int(choice), (0..<classes.count).contains(index - 1) {
			return classes[index - 1].init()
		} else if let newClass = createClass(withString: choice) {
			return newClass
		}
		throw CharacterGenerationError.invalidChoice
	}

	private func createClass(withString string: String) -> CharacterClass? {
		let lc = string.lowercased()

		guard let match = CharacterClasses.shared.allClasses.first(where: {
			$0.name.lowercased() == lc
		}) else { return nil }

		return match.init()
	}

	// MARK: - Utilities
	public func chooseOption<T>(_ choiceFunction: () throws -> T) -> T {
		do {
			let choice = try choiceFunction()
			return choice
		} catch {
			print("Error: \(error)\n")
			return chooseOption(choiceFunction)
		}
	}

	private func confirm(_ userPrompt: String, defaultAnswer: Bool = true) -> Bool {
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

	private func prompt(_ userPrompt: String, defaultAnswer: String? = nil) -> String {
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
