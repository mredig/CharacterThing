import Foundation

public protocol CharacterProtocol: AnyObject {

	var name: String { get }
	var race: Race { get }
	var playerClass: CharacterClass { get }

	var strength: Int { get set }
	var dexterity: Int { get set }
	var intellect: Int { get set }
	var wisdom: Int { get set }
	var charisma: Int { get set }
}
