Class {
	#name : 'BPattern',
	#superclass : 'Object',
	#instVars : [
		'definitionBlock',
		'patternAST',
		'configs',
		'isConfigured'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPattern class >> fromBlock: aBlockClosure [ 
	^self new 
		definitionBlock: aBlockClosure 
]

{ #category : 'converting' }
BPattern >> adoptToSequenceNode [ 
	patternAST isSequence ifFalse: [ 
		patternAST := OCSequenceNode statements: (Array with: patternAST)]
]

{ #category : 'private' }
BPattern >> applyConfigs [
	| astBuilder |
	astBuilder := BPatternASTBuilder configuredBy: configs.
	astBuilder visitNode: patternAST.
	isConfigured := true
]

{ #category : 'converting' }
BPattern >> beMethod: headerBlock [
	| anyTemps messageAST methodAST |
	self adoptToSequenceNode.
	patternAST hasTemporaries ifFalse: [ 
		anyTemps := patternAST addTemporaryNamed: 'anyTemps'.
		anyTemps bePatternNode.
		anyTemps beList.
	]. 
	messageAST := headerBlock bmethodHeaderAST.	
	methodAST := BPatternMethodNode 
		selector: messageAST selector
		keywordsPositions: messageAST keywordsPositions 
		arguments: messageAST arguments.
	methodAST body: patternAST.
	patternAST := methodAST.
	configs add: (BPatternMessageConfig forPatternNames: {messageAST selector})
]

{ #category : 'converting' }
BPattern >> bpattern [
	^self
]

{ #category : 'converting' }
BPattern >> bpattern: varSpecs [
	^self configureBy: varSpecs
]

{ #category : 'private' }
BPattern >> buildPatternAST [
	
	| definitionAST |
	definitionAST := definitionBlock sourceNode.
	patternAST := (definitionAST statements size == 1 and: [ definitionAST temporaries isEmpty ])
		  ifTrue: [ definitionAST statements first ]
		  ifFalse: [ definitionAST body ].
	patternAST := patternAST copy
]

{ #category : 'accessing' }
BPattern >> configureBy: configSpecs [
	
	| patternConfigs |
	patternConfigs := BPatternConfig readFromSpecs: configSpecs.
	configs addAll: patternConfigs
]

{ #category : 'accessing' }
BPattern >> definitionBlock [

	^ definitionBlock
]

{ #category : 'accessing' }
BPattern >> definitionBlock: anObject [

	definitionBlock := anObject.
	self buildPatternAST.
	configs add: BPatternVarConfig forArguments
]

{ #category : 'accessing' }
BPattern >> initialize [ 
	super initialize.
	
	configs := OrderedCollection new.
	isConfigured := false
]

{ #category : 'testing' }
BPattern >> isSequenceNode [ 
	^patternAST isSequence
]

{ #category : 'accessing' }
BPattern >> patternAST [
	isConfigured ifFalse: [ self applyConfigs ].
	^ patternAST 
]

{ #category : 'accessing' }
BPattern >> patternAST: anObject [

	patternAST := anObject
]

{ #category : 'scanning' }
BPattern >> rewriteAST: originalAST with: rewritePattern [

	| rewriter |
	rewriter := BPatternASTRewriter new.
	rewriter addRule: (BPatternReplaceRule new 
			searchTree: self patternAST;
			replaceTree: rewritePattern patternAST).
	rewriter executeTree: originalAST.
	^rewriter tree
	
]

{ #category : 'scanning' }
BPattern >> scanAST: anAST [
	| searcher result |
	
	searcher := OCParseTreeSearcher new.
	searcher addRule: (OCSearchRule new 
			searchTree: self patternAST;
			answerBlock: [ :aNode :answer | result := searcher context ]).
	searcher executeTree: anAST.
	^result
	
]
