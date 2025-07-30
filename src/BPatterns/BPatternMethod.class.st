Class {
	#name : 'BPatternMethod',
	#superclass : 'Object',
	#instVars : [
		'definitionBlock',
		'patternAST'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternMethod class >> fromBlock: aBlockClosure [ 
	^self new 
		definitionBlock: aBlockClosure 
]

{ #category : 'converting' }
BPatternMethod >> adoptToSequenceNode [
	
]

{ #category : 'converting' }
BPatternMethod >> bpattern [
	^self
]

{ #category : 'converting' }
BPatternMethod >> bpattern: varSpecs [
	^self configureBy: varSpecs
]

{ #category : 'private' }
BPatternMethod >> buildPatternAST [
	| methodAssoc bodyPattern headerPattern messageAST anyTemps |
	methodAssoc := definitionBlock valueWithArguments: (Array new: definitionBlock numArgs).
	bodyPattern := methodAssoc value bpattern adoptToSequenceNode.
	bodyPattern patternAST hasTemporaries ifFalse: [ 
		anyTemps := bodyPattern patternAST addTemporaryNamed: 'anyTemps'.
		anyTemps bePatternNode.
		anyTemps beList.
	 ]. 
	headerPattern := methodAssoc key bpattern adoptToSequenceNode.
	messageAST := headerPattern patternAST sendNodes first.
	
	patternAST := BPatternMethodNode 
		selector: messageAST selector
		keywordsPositions: messageAST keywordsPositions 
		arguments: messageAST arguments.
	patternAST body: bodyPattern patternAST.

]

{ #category : 'converting' }
BPatternMethod >> configureBy: configSpecs [
	
	| patternConfigs astBuilder |
	patternConfigs := BPatternConfig readFromSpecs: configSpecs.
	astBuilder := BPatternASTBuilder configuredBy: patternConfigs.
	astBuilder visitNode: patternAST
]

{ #category : 'accessing' }
BPatternMethod >> definitionBlock [

	^ definitionBlock
]

{ #category : 'accessing' }
BPatternMethod >> definitionBlock: anObject [

	definitionBlock := anObject.
	self buildPatternAST
]

{ #category : 'testing' }
BPatternMethod >> isSequenceNode [ 
	^true
]

{ #category : 'accessing' }
BPatternMethod >> patternAST [

	^ patternAST
]

{ #category : 'accessing' }
BPatternMethod >> patternAST: anObject [

	patternAST := anObject
]

{ #category : 'scanning' }
BPatternMethod >> rewriteAST: originalAST with: rewritePattern [

	| rewriter |
	rewriter := BPatternASTRewriter new.
	rewriter addRule: (BPatternReplaceRule new 
			searchTree: patternAST;
			replaceTree: rewritePattern patternAST).
	rewriter executeTree: originalAST.
	^rewriter tree
]
