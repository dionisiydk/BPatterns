Class {
	#name : 'BPattern',
	#superclass : 'Object',
	#instVars : [
		'definitionBlock',
		'patternAST'
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
	patternAST := OCSequenceNode statements: (Array with: patternAST)
]

{ #category : 'converting' }
BPattern >> bpattern [
	^self
]

{ #category : 'private' }
BPattern >> buildPatternAST [
	
	| definitionAST |
	definitionAST := definitionBlock sourceNode.
	patternAST := (definitionAST statements size == 1 and: [ definitionAST temporaries isEmpty ])
		  ifTrue: [ definitionAST statements first ]
		  ifFalse: [ definitionAST body ].
	patternAST := patternAST copy.	
	patternAST variableNodes do: [ :each | 
		each isArgumentVariable ifTrue: [ each bePatternNode ]]
]

{ #category : 'accessing' }
BPattern >> configureBy: configSpecs [
	
	| patternConfigs astBuilder |
	patternConfigs := BPatternConfig readFromSpecs: configSpecs.
	astBuilder := BPatternASTBuilder configuredBy: patternConfigs.
	astBuilder visitNode: patternAST
]

{ #category : 'accessing' }
BPattern >> definitionBlock [

	^ definitionBlock
]

{ #category : 'accessing' }
BPattern >> definitionBlock: anObject [

	definitionBlock := anObject.
	self buildPatternAST
]

{ #category : 'testing' }
BPattern >> isSequenceNode [ 
	^patternAST isSequence
]

{ #category : 'accessing' }
BPattern >> patternAST [

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
			searchTree: patternAST;
			replaceTree: rewritePattern patternAST).
	rewriter executeTree: originalAST.
	^rewriter tree
	
]

{ #category : 'scanning' }
BPattern >> scanAST: anAST [

	| searcher result |
	searcher := OCParseTreeSearcher new.
	searcher addRule: (OCSearchRule new 
			searchTree: patternAST;
			answerBlock: [ :aNode :answer | result := searcher context ]).
	searcher executeTree: anAST.
	^result
	
]
