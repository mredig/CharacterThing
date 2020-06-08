import Foundation

public struct CharacterFactory {
	public enum CharacterGenerationError: Error {
		case invalidChoice
		case stdinAborted
	}

	public init() {}

	public func createCharacter() throws -> PlayerCharacter {
		let name = chooseOptionConfirmed(chooseNameHelper)
		let race = chooseOptionConfirmed(chooseRaceHelper)
		let classChoice = chooseOptionConfirmed(chooseClassHelper)

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
		} while confirm("Continue creating another character?", defaultAnswer: false)
	}

	private func chooseNameHelper() throws -> String {
		let name = prompt("Character Name")
		guard PlayerCharacter.nameValidator(name) else {
			throw PlayerCharacter.CharacterGenerationError.invalidName
		}
		return name
	}

	private func chooseRaceHelper() throws -> Race {
		let allRacesString = Race.allCases
			.listed(by: \.rawValue)

		let choice = prompt("Choose a race from the following:\n\(allRacesString)\n")

		guard let race = createRawType(from: choice, sourcedFrom: Race.allCases, rawCreation: Race.init) else {
			throw CharacterGenerationError.invalidChoice
		}
		return race
	}

	private func chooseClassHelper() throws -> CharacterClass {
		let classes = CharacterClasses.shared.allClasses.map { $0.init() }

		let allClassesString = classes
			.listed(by: \.name)

		let choice = prompt("Choose a class from the following:\n\(allClassesString)\n")

		guard let theClass = createRawType(from: choice, sourcedFrom: classes, rawCreation: createClass) else {
			throw CharacterGenerationError.invalidChoice
		}
		return theClass
	}

	private func createRawType<T>(from rawString: String, sourcedFrom source: Array<T>, rawCreation: (String) -> T?) -> T? {
		if let index = Int(rawString), (0..<source.count).contains(index - 1) {
			return source[index - 1]
		} else {
			return rawCreation(rawString)
		}
	}

	private func createClass(withString string: String) -> CharacterClass? {
		let lc = string.lowercased()

		guard let match = CharacterClasses.shared.allClasses.first(where: {
			$0.name.lowercased() == lc
		}) else { return nil }

		return match.init()
	}

	// MARK: - Utilities
	private func chooseOptionConfirmed<T>(_ choiceFunction: () throws -> T) -> T {
		var choice: T
		repeat {
			choice = chooseOption(choiceFunction)
		} while !confirm("Is \(choice) correct?")
		return choice
	}

	private func chooseOption<T>(_ choiceFunction: () throws -> T) -> T {
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
