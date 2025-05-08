Class {
	#name : 'BPatternRewrite',
	#superclass : 'Object',
	#instVars : [
		'definitionBlock',
		'searchPattern',
		'rewritePattern'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternRewrite class >> fromBlock: aBlockClosure [ 
	^self new 
		definitionBlock: aBlockClosure 
]

{ #category : 'initialization' }
BPatternRewrite >> buildPatternAST [
	| ruleAssoc |
	ruleAssoc := definitionBlock valueWithArguments: (Array new: definitionBlock numArgs).
	searchPattern := ruleAssoc key bpattern.
	rewritePattern := ruleAssoc value bpattern.
	searchPattern isSequenceNode = rewritePattern isSequenceNode 
		ifFalse: [ searchPattern isSequenceNode
				ifTrue: [ rewritePattern adoptToSequenceNode ]
				ifFalse: [ searchPattern adoptToSequenceNode ]]
]

{ #category : 'accessing' }
BPatternRewrite >> definitionBlock [

	^ definitionBlock
]

{ #category : 'accessing' }
BPatternRewrite >> definitionBlock: anObject [

	definitionBlock := anObject.
	self buildPatternAST
]

{ #category : 'rewriting' }
BPatternRewrite >> rewriteAST: anAST [
	^searchPattern rewriteAST: anAST with: rewritePattern
]

{ #category : 'accessing' }
BPatternRewrite >> rewritePattern [

	^ rewritePattern
]

{ #category : 'accessing' }
BPatternRewrite >> rewritePattern: anObject [

	rewritePattern := anObject
]

{ #category : 'accessing' }
BPatternRewrite >> searchPattern [

	^ searchPattern
]

{ #category : 'accessing' }
BPatternRewrite >> searchPattern: anObject [

	searchPattern := anObject
]
