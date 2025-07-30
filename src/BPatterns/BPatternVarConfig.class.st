Class {
	#name : 'BPatternVarConfig',
	#superclass : 'BPatternConfig',
	#instVars : [
		'targetVariableClass'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternVarConfig class >> forArguments [
	^self new 
		targetVariableClass: ArgumentVariable
]

{ #category : 'instance creation' }
BPatternVarConfig class >> forWorkspace [
	^self new 
		targetVariableClass: OCDoItVariable
]

{ #category : 'initialization' }
BPatternVarConfig >> initialize [ 
	super initialize.
	
	targetVariableClass := Variable
]

{ #category : 'testing' }
BPatternVarConfig >> isForNode: anASTNode [
	anASTNode isVariable ifFalse: [ ^false ].
	(anASTNode variable originalVar isKindOf: targetVariableClass) ifFalse: [ ^false ].
	^patternNames isEmpty or: [ patternNames includes: anASTNode name ]
]

{ #category : 'accessing' }
BPatternVarConfig >> targetVariableClass [

	^ targetVariableClass
]

{ #category : 'accessing' }
BPatternVarConfig >> targetVariableClass: anObject [

	targetVariableClass := anObject
]
