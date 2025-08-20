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
BPatternRewrite class >> fromBlock: definitionBlock [
	| ruleAssoc searchPattern rewritePattern |
	ruleAssoc := definitionBlock valueWithArguments: (Array new: definitionBlock numArgs).
	searchPattern := ruleAssoc key bpattern.
	rewritePattern := ruleAssoc value bpattern.
	^self fromPattern: searchPattern to: rewritePattern
]

{ #category : 'instance creation' }
BPatternRewrite class >> fromPattern: searchPattern to: rewritePattern [
	searchPattern isSequenceNode = rewritePattern isSequenceNode 
		ifFalse: [ searchPattern isSequenceNode
				ifTrue: [ rewritePattern adoptToSequenceNode ]
				ifFalse: [ searchPattern adoptToSequenceNode ]].
	^self new 
		searchPattern: searchPattern;
		rewritePattern: rewritePattern 
]

{ #category : 'rewriting' }
BPatternRewrite >> displayStringOn: aStream [ 
	
	aStream nextPutAll: '[ '.
	searchPattern displayStringOn: aStream.
	aStream nextPutAll: ' ] -> [ '.
	rewritePattern displayStringOn: aStream.
	aStream nextPutAll: ' ]'
]

{ #category : 'rewriting' }
BPatternRewrite >> printOn: aStream [
	super printOn: aStream.
	
	aStream nextPut: $(.
	self displayStringOn: aStream.
	aStream nextPut: $)
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
