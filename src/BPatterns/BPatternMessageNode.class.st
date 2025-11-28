Class {
	#name : 'BPatternMessageNode',
	#superclass : 'OCPatternMessageNode',
	#instVars : [
		'patternKeywords',
		'filters'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'comparing' }
BPatternMessageNode >> = anObject [
	super = anObject ifFalse: [ ^false ].
	
	filters size = anObject filters size ifFalse: [^false ].
	filters with: anObject filters do: [:my :their |
		my compiledBlock = their compiledBlock ifFalse: [^false ]
	].
	^true
]

{ #category : 'accessing' }
BPatternMessageNode >> addPatternKeyword: aSymbol [
	patternKeywords add: aSymbol
]

{ #category : 'initialization' }
BPatternMessageNode >> beBinary [ 
	self where: [ :node | node selector isBinary ]
]

{ #category : 'initialization' }
BPatternMessageNode >> beCascadeList [ 
	isCascadeList := true
]

{ #category : 'initialization' }
BPatternMessageNode >> beKeyword [ 
	self where: [ :node | node selector isKeyword ]
]

{ #category : 'converting' }
BPatternMessageNode >> bePatternNode [
]

{ #category : 'initialization' }
BPatternMessageNode >> beSelectorList [
	isList := true
]

{ #category : 'initialization' }
BPatternMessageNode >> beUnary [ 
	isList := false.
	self where: [ :node | node selector isUnary ]
]

{ #category : 'matching' }
BPatternMessageNode >> copyInContext: aDictionary [
	| keywordSelector args |
	self isList
		ifTrue: [ ^aDictionary at: self ].
	keywordSelector := self isSelectorList
		ifTrue: [ aDictionary at: self selector ]
		ifFalse: [ '' join: (self selectorParts collect: [ :each | aDictionary at: each ])].
	args := self isSelectorList
		ifTrue: [ (aDictionary at: self selector, '_args') ]
		ifFalse: [ self arguments ].
	^ OCMessageNode
		receiver: (self receiver copyInContext: aDictionary)
		selector: keywordSelector
		arguments: (self copyList: args inContext: aDictionary)
]

{ #category : 'accessing' }
BPatternMessageNode >> filters [

	^ filters
]

{ #category : 'comparing' }
BPatternMessageNode >> hash [
	^filters inject: super hash into: [:result :each | 
		each compiledBlock hash bitXor: result hash ]
]

{ #category : 'initialization' }
BPatternMessageNode >> initialize [ 
	super initialize.

	filters := #().
	patternKeywords := Set new
]

{ #category : 'matching' }
BPatternMessageNode >> isPatternKeyword: aString [ 
	^patternKeywords includes: aString
]

{ #category : 'matching' }
BPatternMessageNode >> match: aNode inContext: aDictionary [
	aNode class == self matchingClass ifFalse: [ ^false ].
	(self matchFiltersFor: aNode) ifFalse: [ ^false ].
	(receiver match: aNode receiver inContext: aDictionary) ifFalse: [ ^false ].
	
	self isSelectorList ifTrue:	[
		^(aDictionary at: self selector ifAbsentPut: [aNode selector]) == aNode selector 
			and: [(aDictionary at: self selector, '_args' ifAbsentPut: [ aNode arguments ]) = aNode arguments]].
	^self matchArgumentsAgainst: aNode inContext: aDictionary
]

{ #category : 'matching' }
BPatternMessageNode >> matchFiltersFor: anObject [

	^filters allSatisfy: [ :each | each value: anObject ]

]

{ #category : 'matching' }
BPatternMessageNode >> matchSelectorAgainst: aNode inContext: aDictionary [
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
BPatternMessageNode >> patternKeywords [

	^ patternKeywords
]

{ #category : 'accessing' }
BPatternMessageNode >> patternKeywords: anObject [

	patternKeywords := anObject
]

{ #category : 'accessing' }
BPatternMessageNode >> selector: aSelectorNode [ 
	super selector: aSelectorNode.
	
	aSelectorNode value isBinary ifTrue: [ self beBinary ]
]

{ #category : 'initialization' }
BPatternMessageNode >> where: aBlock [
	filters := filters copyWith: aBlock.
]
