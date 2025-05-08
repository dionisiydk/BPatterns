Class {
	#name : 'BPatternMessageNode',
	#superclass : 'OCPatternMessageNode',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'matching' }
BPatternMessageNode >> isPatternKeyword: aString [ 
	^true
]

{ #category : 'matching' }
BPatternMessageNode >> matchSelectorAgainst: aNode inContext: aDictionary [
	self selectorParts with: aNode selectorParts do: [ :first :second |
		| keyword |
		keyword := aDictionary
			at: first
			ifAbsentPut: [
				(self isPatternKeyword: first)
					ifTrue: [ second ]
					ifFalse: [ first ] ].
		keyword = second
			ifFalse: [ ^ false ] ].
	^ true
]
