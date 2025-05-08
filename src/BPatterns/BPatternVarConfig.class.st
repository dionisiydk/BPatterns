Class {
	#name : 'BPatternVarConfig',
	#superclass : 'BPatternConfig',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'testing' }
BPatternVarConfig >> isForNode: anASTNode [
	^anASTNode isVariable and: [ patternNames includes: anASTNode name ]
]
