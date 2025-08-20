Class {
	#name : 'BPatternDefaultVarConfig',
	#superclass : 'BPatternVarConfig',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'testing' }
BPatternDefaultVarConfig >> isForNode: aVariableNode [
	(super isForNode: aVariableNode) ifFalse: [ ^false ].
	
	aVariableNode isArgumentVariable ifTrue: [ ^true ].
	aVariableNode isWorkspaceVariable ifTrue: [ ^true ].
	^aVariableNode name beginsWith: 'any'
]
