Class {
	#name : 'BPatternSearchRule',
	#superclass : 'OCSearchRule',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'accessing' }
BPatternSearchRule >> answerBlock [

	^ answerBlock
]

{ #category : 'accessing' }
BPatternSearchRule >> answerBlock: anObject [

	answerBlock := anObject
]

{ #category : 'matching' }
BPatternSearchRule >> performOn: aProgramNode [

	self context empty.
	^((searchTree match: aProgramNode inContext: self context)
		and: [self canMatch: aProgramNode])
			ifTrue:
				[owner recusivelySearchInContextExcept: aProgramNode.
				self foundMatchFor: aProgramNode]
			ifFalse: [nil]
]

{ #category : 'accessing' }
BPatternSearchRule >> searchTree: anObject [

	searchTree := anObject
]
