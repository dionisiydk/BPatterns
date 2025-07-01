Class {
	#name : 'BPatternMessageNode',
	#superclass : 'OCPatternMessageNode',
	#instVars : [
		'patternKeywords'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'initialization' }
BPatternMessageNode >> beList [
	isList := true
]

{ #category : 'initialization' }
BPatternMessageNode >> initialize [ 
	super initialize.
	
	patternKeywords := #()
]

{ #category : 'matching' }
BPatternMessageNode >> isPatternKeyword: aString [ 
	^patternKeywords includes: aString
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

{ #category : 'accessing' }
BPatternMessageNode >> patternKeywords [

	^ patternKeywords
]

{ #category : 'accessing' }
BPatternMessageNode >> patternKeywords: anObject [

	patternKeywords := anObject
]
