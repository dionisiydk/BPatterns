Class {
	#name : 'BPatternVarConfig',
	#superclass : 'BPatternConfig',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'testing' }
BPatternVarConfig class >> isAbstract [ 
	^self = BPatternVarConfig
]

{ #category : 'testing' }
BPatternVarConfig >> isForNode: anASTNode [
	^anASTNode isVariable
]
