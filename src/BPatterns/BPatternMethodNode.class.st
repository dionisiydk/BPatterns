Class {
	#name : 'BPatternMethodNode',
	#superclass : 'OCPatternMethodNode',
	#instVars : [
		'patternKeywords'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternMethodNode class >> selector: aSymbol keywordsPositions: positionList arguments: valueNodes [
	^self new
		selector: aSymbol
		keywordsPositions: positionList
		arguments: valueNodes;
		yourself
]

{ #category : 'as yet unclassified' }
BPatternMethodNode >> anySelectorSymbol [
	^#anySelector
]

{ #category : 'initialization' }
BPatternMethodNode >> beList [
	
	isList := true
]

{ #category : 'converting' }
BPatternMethodNode >> bePatternNode [
	^self
]

{ #category : 'matching' }
BPatternMethodNode >> copyInContext: aDictionary [
	| keywordSelector args |
	keywordSelector := self isSelectorList
		ifTrue: [ aDictionary at: self selector ]
		ifFalse: [ ('' join:(self selectorParts collect: [ :each | aDictionary at: each ])) asSymbol  ].
	args := self isSelectorList
		ifTrue: [ (aDictionary at: self selector, '_args') copy ]
		ifFalse: [ self copyList: self arguments inContext: aDictionary ].
			
	^ OCMethodNode new
		selector: keywordSelector;
		arguments: args;
		pragmas: (self pragmas isEmpty
			ifTrue: [ aDictionary at: '-pragmas-' ifAbsent: [ #() ] ]
			ifFalse: [ self copyList: self pragmas inContext: aDictionary ]);
		body: (self body copyInContext: aDictionary);
		source: (aDictionary at: '-source-');
		yourself
]

{ #category : 'initialization' }
BPatternMethodNode >> initialize [ 
	super initialize.
	
	self beList.
	patternKeywords := #()
]

{ #category : 'testing' }
BPatternMethodNode >> isPatternKeyword: aString [ 
	^patternKeywords includes: aString
]

{ #category : 'matching' }
BPatternMethodNode >> match: aNode inContext: aDictionary [
	aNode class = self matchingClass
		ifFalse: [ ^ false ].
	aDictionary at: '-source-' put: aNode source.
	self isSelectorList ifTrue: [
		^ (aDictionary at: self selector ifAbsentPut: [ aNode selector ]) = aNode selector
			and: [ ((aDictionary at: self selector, '_args' ifAbsentPut: [ aNode arguments ]) = aNode arguments)
			and: [ (self matchPragmas: self pragmas against: aNode pragmas inContext: aDictionary)
			and: [ body match: aNode body inContext: aDictionary ] ] ] ].
	^(self matchArgumentsAgainst: aNode inContext: aDictionary)
		and: [ (self matchPragmas: self pragmas against: aNode pragmas inContext: aDictionary)
		and: [ body match: aNode body inContext: aDictionary ] ]
]

{ #category : 'matching' }
BPatternMethodNode >> matchSelectorAgainst: aNode inContext: aDictionary [
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
BPatternMethodNode >> patternKeywords [

	^ patternKeywords
]

{ #category : 'accessing' }
BPatternMethodNode >> patternKeywords: anObject [

	patternKeywords := anObject
]

{ #category : 'initialization' }
BPatternMethodNode >> selector: aSymbol keywordsPositions: positionList arguments: valueNodes [
	super selector: aSymbol keywordsPositions: positionList arguments: valueNodes.
	self beList.
]
