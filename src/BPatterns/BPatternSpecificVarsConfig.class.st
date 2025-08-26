Class {
	#name : 'BPatternSpecificVarsConfig',
	#superclass : 'BPatternVarConfig',
	#instVars : [
		'patternVars'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternSpecificVarsConfig class >> forVars: varNames configuredBy: nodeBlock [
	varNames ifEmpty: [ self error: 'Pattern var names should not be empty!' ].
	^self new 
		patternVars: varNames;
		nodeConfigBlock: nodeBlock
]

{ #category : 'testing' }
BPatternSpecificVarsConfig >> isForNode: anASTNode [
	(super isForNode: anASTNode) ifFalse: [ ^false ].

	^patternVars includes: anASTNode name
]

{ #category : 'accessing' }
BPatternSpecificVarsConfig >> patternVars [

	^ patternVars
]

{ #category : 'accessing' }
BPatternSpecificVarsConfig >> patternVars: anObject [

	patternVars := anObject
]

{ #category : 'printing' }
BPatternSpecificVarsConfig >> printOn: aStream [
	super printOn: aStream.
	
	aStream nextPut: $(.
	patternVars 
		do: [:each | aStream nextPutAll: each ] 
		separatedBy: [ aStream nextPut: ', ' ].
	aStream nextPut: $).
]
