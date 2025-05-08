Class {
	#name : 'BPatternASTBuilder',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'patternConfigs'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternASTBuilder class >> configuredBy: configs [
	^self new 
		patternConfigs: configs
]

{ #category : 'visiting' }
BPatternASTBuilder >> initialize [
	super initialize.
	
	patternConfigs := #()
]

{ #category : 'accessing' }
BPatternASTBuilder >> patternConfigs [

	^ patternConfigs
]

{ #category : 'accessing' }
BPatternASTBuilder >> patternConfigs: anObject [

	patternConfigs := anObject
]

{ #category : 'visiting' }
BPatternASTBuilder >> visitMessageNode: aMessageNode [
	self visitNode: aMessageNode receiver.
	self visitNode: aMessageNode selectorNode.
	aMessageNode arguments do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
BPatternASTBuilder >> visitNode: aNode [
	patternConfigs 
		select: [ :each | each isForNode: aNode ] 
		thenDo: [ :each | each applyForNode: aNode ].
	^ super visitNode: aNode
]
