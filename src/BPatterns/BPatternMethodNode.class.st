Class {
	#name : 'BPatternMethodNode',
	#superclass : 'OCPatternMethodNode',
	#instVars : [
		'patternKeywords',
		'filters'
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

{ #category : 'comparing' }
BPatternMethodNode >> = anObject [
	super = anObject ifFalse: [ ^false ].
	
	filters size = anObject filters size ifFalse: [ ^false ].
	filters with: anObject filters do: [:my :their |
		my compiledBlock = their compiledBlock ifFalse: [ ^false ]
	].
	^true
]

{ #category : 'accessing' }
BPatternMethodNode >> addPatternKeyword: aSymbol [ 
	patternKeywords add: aSymbol
]

{ #category : 'initialization' }
BPatternMethodNode >> adoptTemps [
	| anyTemps |
	body hasTemporaries ifTrue: [ ^self ].
	"By default if the pattern does not explicitly define temps it will match any number of temps"
	anyTemps := body addTemporaryNamed: 'anyTemps'.
	anyTemps bePatternNode.
	anyTemps beMultiStatements. "Under the temps declaration multiple statements  means any number of temps"
]

{ #category : 'initialization' }
BPatternMethodNode >> beBinary [ 
	self where: [:node | node selector isBinary ]
]

{ #category : 'initialization' }
BPatternMethodNode >> beKeyword [ 
	self where: [:node | node selector isKeyword ]
]

{ #category : 'converting' }
BPatternMethodNode >> bePatternNode [
	^self
]

{ #category : 'initialization' }
BPatternMethodNode >> beSelectorList [
	isList := true
]

{ #category : 'initialization' }
BPatternMethodNode >> beUnary [ 
	isList := false.
	self where: [:node | node selector isUnary ]
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

{ #category : 'accessing' }
BPatternMethodNode >> filters [

	^ filters
]

{ #category : 'comparing' }
BPatternMethodNode >> hash [
	^filters inject: super hash into: [:result :each | 
		each compiledBlock hash bitXor: result hash ]
]

{ #category : 'initialization' }
BPatternMethodNode >> initialize [ 
	super initialize.

	filters := #().
	patternKeywords := Set new
]

{ #category : 'testing' }
BPatternMethodNode >> isPatternKeyword: aString [ 
	^patternKeywords includes: aString
]

{ #category : 'matching' }
BPatternMethodNode >> match: aNode inContext: aDictionary [
	aNode class = self matchingClass ifFalse: [ ^ false ].
	(self matchFiltersFor: aNode) ifFalse: [ ^false ].
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
BPatternMethodNode >> matchFiltersFor: anObject [

	^filters allSatisfy: [ :each | each value: anObject ]
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

{ #category : 'accessing' }
BPatternMethodNode >> selector: aSelectorNode [ 
	super selector: aSelectorNode.
	
	aSelectorNode value isBinary ifTrue: [ self beBinary ]
]

{ #category : 'initialization' }
BPatternMethodNode >> where: aBlock [
	filters := filters copyWith: aBlock.
]
