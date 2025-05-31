Class {
	#name : 'BPatternMethodNode',
	#superclass : 'OCPatternMethodNode',
	#instVars : [
		'patternKeywords'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternMethodNode class >> selector: aSymbol keywordsPositions: positionList arguments: valueNodes [
	^self new
		selector: aSymbol
		keywordsPositions: positionList
		arguments: valueNodes;
		yourself
]

{ #category : 'converting' }
BPatternMethodNode >> bePatternNode [
	^self
]

{ #category : 'initialization' }
BPatternMethodNode >> initialize [ 
	super initialize.
	
	patternKeywords := #()
]

{ #category : 'testing' }
BPatternMethodNode >> isPatternKeyword: aString [ 
	^patternKeywords includes: aString
]

{ #category : 'matching' }
BPatternMethodNode >> matchSelectorAgainst: aNode inContext: aDictionary [
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
BPatternMethodNode >> patternKeywords [

	^ patternKeywords
]

{ #category : 'accessing' }
BPatternMethodNode >> patternKeywords: anObject [

	patternKeywords := anObject
]
