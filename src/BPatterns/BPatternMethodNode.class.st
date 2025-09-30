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
BPatternMethodNode class >> fromHeaderBlock: aBlockWithMessageSend body: aSequenceAST [
	| messageAST |
	messageAST := aBlockWithMessageSend sourceNode sendNodes first.	
	^self fromMessageNode: messageAST body: aSequenceAST
]

{ #category : 'instance creation' }
BPatternMethodNode class >> fromMessageNode: headerMessageNode body: bodySequenceNode [
	| methodNode |
	methodNode := self 
		selector: headerMessageNode selector
		keywordsPositions: headerMessageNode keywordsPositions
		arguments: (headerMessageNode arguments collect: [:each | each copy ]).
	methodNode body: bodySequenceNode.
	methodNode adoptTemps.
	^methodNode
]

{ #category : 'instance creation' }
BPatternMethodNode class >> selector: aSymbol keywordsPositions: positionList arguments: valueNodes [
	^self new
		selector: aSymbol
		keywordsPositions: positionList
		arguments: valueNodes;
		yourself
]

{ #category : 'accessing' }
BPatternMethodNode >> addPatternKeyword: aSymbol [ 
	patternKeywords add: aSymbol
]

{ #category : 'accessing' }
BPatternMethodNode >> addPatternKeywords: symbols [ 
	patternKeywords addAll: symbols
]

{ #category : 'initialization' }
BPatternMethodNode >> adoptTemps [
	| anyTemps |
	body hasTemporaries ifTrue: [ ^self ].
	"By default if the pattern does not explicitly define temps it will match any number of temps"
	anyTemps := body addTemporaryNamed: 'anyTemps'.
	anyTemps bePatternNode.
	anyTemps beList.
]

{ #category : 'converting' }
BPatternMethodNode >> bePatternNode [
	^self
]

{ #category : 'initialization' }
BPatternMethodNode >> beSelectorList [
	
	isList := true
]

{ #category : 'matching' }
BPatternMethodNode >> copyInContext: aDictionary [
	| keywordSelector args |
	keywordSelector := self isSelectorList
		ifTrue: [ aDictionary at: self selector ]
		ifFalse: [ ('' join:(self selectorParts collect: [ :each | aDictionary at: each ])) asSymbol  ].
	args := self isSelectorList
		ifTrue: [ (aDictionary at: self selector, '_args') ]
		ifFalse: [ self arguments ].			
	^ OCMethodNode new
		selector: keywordSelector;
		arguments: (self copyList: args inContext: aDictionary );
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

	patternKeywords := Set new
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
