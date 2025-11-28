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
BPatternASTBuilder >> applyConfigsFor: aNode [
	patternConfigs 
		select: [ :each | each isForNode: aNode ] 
		thenDo: [ :each | 	each applyForNode: aNode ]
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
	self applyConfigsFor: aMessageNode.
	
	self visitNode: aMessageNode receiver.
	self visitNode: aMessageNode selectorNode.
	aMessageNode arguments do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
BPatternASTBuilder >> visitMethodNode: aMethodNode [
	self applyConfigsFor: aMethodNode.
	super visitMethodNode: aMethodNode
]

{ #category : 'visiting' }
BPatternASTBuilder >> visitPragmaNode: aNode [
	self applyConfigsFor: aNode.

	super visitPragmaNode: aNode
]

{ #category : 'visiting' }
BPatternASTBuilder >> visitVariableNode: aNode [
	self applyConfigsFor: aNode 
]
