Class {
	#name : 'BPatternPluggableVarConfig',
	#superclass : 'BPatternVarConfig',
	#instVars : [
		'definitionBlock',
		'patternVars'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternPluggableVarConfig class >> forVarNames: names definedBy: nodeBlock [

	^self new 
		patternVars: names;
		definitionBlock: nodeBlock
]

{ #category : 'applying' }
BPatternPluggableVarConfig >> applyForNode: anASTNode [
	super applyForNode: anASTNode.
	
	definitionBlock ifNotNil: [ definitionBlock value: anASTNode ]
]

{ #category : 'accessing' }
BPatternPluggableVarConfig >> definitionBlock [

	^ definitionBlock
]

{ #category : 'accessing' }
BPatternPluggableVarConfig >> definitionBlock: anObject [

	definitionBlock := anObject
]

{ #category : 'testing' }
BPatternPluggableVarConfig >> isForNode: anASTNode [
	(super isForNode: anASTNode) ifFalse: [ ^false ].

	^patternVars includes: anASTNode name
]

{ #category : 'accessing' }
BPatternPluggableVarConfig >> patternVars [

	^ patternVars
]

{ #category : 'accessing' }
BPatternPluggableVarConfig >> patternVars: anObject [

	patternVars := anObject
]

{ #category : 'printing' }
BPatternPluggableVarConfig >> printOn: aStream [
	super printOn: aStream.
	
	aStream nextPut: $(.
	patternVars 
		do: [:each | aStream nextPutAll: each ] 
		separatedBy: [ aStream nextPut: ', ' ].
	aStream nextPut: $).
]
