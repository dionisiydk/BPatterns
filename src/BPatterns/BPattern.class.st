Class {
	#name : 'BPattern',
	#superclass : 'Object',
	#instVars : [
		'patternAST',
		'configs',
		'isConfigured'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPattern class >> fromAST: anASTNode [ 
	^self new 
		patternAST: anASTNode
]

{ #category : 'instance creation' }
BPattern class >> fromBlock: definitionBlock [ 
	| definitionAST patternAST |
	definitionAST := definitionBlock sourceNode.
	patternAST := (definitionAST statements size == 1 and: [ definitionAST temporaries isEmpty ])
		  ifTrue: [ definitionAST statements first ]
		  ifFalse: [ definitionAST body ].
	^self fromAST: patternAST
	
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
	self adoptToSequenceNode.
	patternAST := BPatternMethodNode 
						fromHeaderBlock: headerBlock 
						body: patternAST.

]

{ #category : 'converting' }
BPattern >> bpattern [
	^self
]

{ #category : 'converting' }
BPattern >> bpattern: varSpecs [
	^self configureBy: varSpecs
]

{ #category : 'initialization' }
BPattern >> configureBy: configSpecs [
	
	| patternConfigs |
	patternConfigs := BPatternConfig readFromSpecs: configSpecs.
	configs addAll: patternConfigs
]

{ #category : 'printing' }
BPattern >> displayStringOn: aStream [
	
	aStream nextPutAll: patternAST formattedCode
]

{ #category : 'initialization' }
BPattern >> initialize [ 
	super initialize.

	configs := OrderedCollection new.
	isConfigured := false.
	self useDefaultConfigs
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
BPattern >> patternAST: anASTNode [
	patternAST := anASTNode copy
]

{ #category : 'printing' }
BPattern >> printOn: aStream [
	super printOn: aStream.
	
	aStream nextPut: $(.
	self displayStringOn: aStream.
	aStream nextPut: $)
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
	searcher addRule: (BPatternSearchRule new 
			searchTree: self patternAST;
			answerBlock: [ :aNode :answer | result := searcher context ]).
	searcher executeTree: anAST.
	^result
	
]

{ #category : 'initialization' }
BPattern >> useDefaultConfigs [
	configs add: BPatternDefaultVarConfig new.
	configs add: BPatternDefaultSelectorConfig new
]
