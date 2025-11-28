Class {
	#name : 'BPatternPragmaNode',
	#superclass : 'OCPatternPragmaNode',
	#instVars : [
		'patternKeywords',
		'filters'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'comparing' }
BPatternPragmaNode >> = anObject [
	super = anObject ifFalse: [ ^false ].
	
	filters size = anObject filters size ifFalse: [^false ].
	filters with: anObject filters do: [:my :their |
		my compiledBlock = their compiledBlock ifFalse: [^false ]
	].
	^true
]

{ #category : 'adding' }
BPatternPragmaNode >> addPatternKeyword: aSymbol [
	patternKeywords add: aSymbol
]

{ #category : 'converting' }
BPatternPragmaNode >> bePatternNode [
]

{ #category : 'initialization' }
BPatternPragmaNode >> beSelectorList [
	isList := true
]

{ #category : 'matching' }
BPatternPragmaNode >> copyInContext: aDictionary [
	| keywordSelector args |
	keywordSelector := self isSelectorList
		ifTrue: [ aDictionary at: self selector ]
		ifFalse: [ '' join: (self selectorParts collect: [ :each | aDictionary at: each ])].
	args := self isSelectorList
		ifTrue: [ (aDictionary at: self selector, '_args') ]
		ifFalse: [ self arguments ].
	^ OCPragmaNode
		selector: keywordSelector
		arguments: (self copyList: args inContext: aDictionary)
]

{ #category : 'accessing' }
BPatternPragmaNode >> filters [

	^ filters
]

{ #category : 'accessing' }
BPatternPragmaNode >> filters: anObject [

	filters := anObject
]

{ #category : 'comparing' }
BPatternPragmaNode >> hash [
	^filters inject: super hash into: [:result :each | 
		each compiledBlock hash bitXor: result hash ]
]

{ #category : 'initialization' }
BPatternPragmaNode >> initialize [ 
	super initialize.

	filters := #().
	patternKeywords := Set new
]

{ #category : 'testing' }
BPatternPragmaNode >> isPatternKeyword: aString [ 
	^patternKeywords includes: aString
]

{ #category : 'matching' }
BPatternPragmaNode >> match: aNode inContext: aDictionary [
	aNode class == self matchingClass ifFalse: [ ^false ].
	(self matchFiltersFor: aNode) ifFalse: [ ^false ].
	self isSelectorList ifTrue:	[
		^(aDictionary at: self selector ifAbsentPut: [aNode selector]) == aNode selector 
			and: [(aDictionary at: self selector, '_args' ifAbsentPut: [ aNode arguments ]) = aNode arguments]].
	^self matchArgumentsAgainst: aNode inContext: aDictionary
]

{ #category : 'matching' }
BPatternPragmaNode >> matchFiltersFor: anObject [

	^filters allSatisfy: [ :each | each value: anObject ]
]

{ #category : 'matching' }
BPatternPragmaNode >> matchSelectorAgainst: aNode inContext: aDictionary [
	self selectorParts with: aNode selectorParts do: [ :first :second |
		| keyword |
		keyword := aDictionary
			at: first
			ifAbsentPut: [
				(self isPatternKeyword: first)
					ifTrue: [ second ]
					ifFalse: [ first ] ].
		keyword = second
			ifFalse: [ ^ false ] ].
	^ true
]

{ #category : 'accessing' }
BPatternPragmaNode >> patternKeywords [

	^ patternKeywords
]

{ #category : 'initialization' }
BPatternPragmaNode >> where: aBlock [
	filters := filters copyWith: aBlock.
]
