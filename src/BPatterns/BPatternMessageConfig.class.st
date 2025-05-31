Class {
	#name : 'BPatternMessageConfig',
	#superclass : 'BPatternConfig',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'applying' }
BPatternMessageConfig >> applyForNode: anASTNode [
	anASTNode bePatternNode.
	anASTNode patternKeywords: self patternKeywords.
	definitionBlock ifNotNil: [ definitionBlock value: anASTNode ]
]

{ #category : 'testing' }
BPatternMessageConfig >> isForNode: anASTNode [

	^(anASTNode isMessage or: [ anASTNode isMethod ]) 
		and: [ anASTNode keywords includesAny: self patternKeywords ]
]

{ #category : 'accessing' }
BPatternMessageConfig >> patternKeywords [
	^patternNames flatCollect: [ :each | each keywords ]
]
