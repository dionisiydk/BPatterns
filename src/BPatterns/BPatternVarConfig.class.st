Class {
	#name : 'BPatternVarConfig',
	#superclass : 'BPatternConfig',
	#instVars : [
		'targetVariableClass'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'testing' }
BPatternVarConfig class >> isAbstract [ 
	^self = BPatternVarConfig
]

{ #category : 'initialization' }
BPatternVarConfig >> initialize [ 
	super initialize.
	
	targetVariableClass := Variable
]

{ #category : 'testing' }
BPatternVarConfig >> isForNode: anASTNode [
	anASTNode isVariable ifFalse: [ ^false ].
	^anASTNode variable originalVar isKindOf: targetVariableClass
]

{ #category : 'accessing' }
BPatternVarConfig >> targetVariableClass [

	^ targetVariableClass
]

{ #category : 'accessing' }
BPatternVarConfig >> targetVariableClass: anObject [

	targetVariableClass := anObject
]
