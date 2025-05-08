Class {
	#name : 'BPatternMessageConfig',
	#superclass : 'BPatternConfig',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'testing' }
BPatternMessageConfig >> isForNode: anASTNode [

	^anASTNode isMessage and: [ anASTNode keywords includesAny: self patternKeywords ]
]

{ #category : 'accessing' }
BPatternMessageConfig >> patternKeywords [
	^patternNames flatCollect: [ :each | each keywords ]
]
