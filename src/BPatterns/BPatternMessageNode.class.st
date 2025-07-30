Class {
	#name : 'BPatternMessageNode',
	#superclass : 'OCPatternMessageNode',
	#instVars : [
		'patternKeywords'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'converting' }
BPatternMessageNode >> beCascadeList [ 
	isCascadeList := true
]

{ #category : 'initialization' }
BPatternMessageNode >> beList [
	isList := true
]

{ #category : 'converting' }
BPatternMessageNode >> bePatternNode [
]

{ #category : 'matching' }
BPatternMessageNode >> copyInContext: aDictionary [
	| keywordSelector args |
	self isList
		ifTrue: [ ^ aDictionary at: self ].
	keywordSelector := self isSelectorList
		ifTrue: [ aDictionary at: self selector ]
		ifFalse: [ '' join: (self selectorParts collect: [ :each | aDictionary at: each ])].
	args := self isSelectorList
		ifTrue: [ (aDictionary at: self selector, '_args') copy ]
		ifFalse: [ self copyList: self arguments inContext: aDictionary ].
	^ OCMessageNode
		receiver: (self receiver copyInContext: aDictionary)
		selector: keywordSelector
		arguments: args
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
BPatternMessageNode >> match: aNode inContext: aDictionary [
	aNode class == self matchingClass ifFalse: [^false].
	(receiver match: aNode receiver inContext: aDictionary) ifFalse: [^false].
	self isSelectorList
		ifTrue:
			[^(aDictionary at: self selector ifAbsentPut: [aNode selector])
				== aNode selector and:
						[(aDictionary at: self selector, '_args' ifAbsentPut: [ aNode arguments ]) = aNode arguments]].
	^self matchArgumentsAgainst: aNode inContext: aDictionary
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
