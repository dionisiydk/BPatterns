Class {
	#name : 'BPatternDefaultVarConfig',
	#superclass : 'BPatternVarConfig',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'testing' }
BPatternDefaultVarConfig >> isForNode: aVariableNode [
	(super isForNode: aVariableNode) ifFalse: [ ^false ].
	
	^aVariableNode name beginsWith: 'any'
]
