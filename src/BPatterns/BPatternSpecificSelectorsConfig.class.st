Class {
	#name : 'BPatternSpecificSelectorsConfig',
	#superclass : 'BPatternSelectorConfig',
	#instVars : [
		'patternKeywords'
	],
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'instance creation' }
BPatternSpecificSelectorsConfig class >> forSelectors: selectors configuredBy: nodeBlock [
	selectors ifEmpty: [ self error: 'Pattern selectors should not be empty!' ].
	^self new 
		patternSelectors: selectors;
		nodeConfigBlock: nodeBlock
]

{ #category : 'testing' }
BPatternSpecificSelectorsConfig >> isForKeyword: aSymbol [
	^patternKeywords includes: aSymbol
]

{ #category : 'accessing' }
BPatternSpecificSelectorsConfig >> patternKeywords [
	^patternKeywords
]

{ #category : 'accessing' }
BPatternSpecificSelectorsConfig >> patternKeywords: symbols [
	^patternKeywords := symbols
]

{ #category : 'accessing' }
BPatternSpecificSelectorsConfig >> patternSelectors: symbols [
	^patternKeywords := symbols flatCollect: [:each | each keywords ]
]

{ #category : 'printing' }
BPatternSpecificSelectorsConfig >> printOn: aStream [
	super printOn: aStream.
	
	aStream nextPut: $(.
	patternKeywords
		do: [:each | aStream nextPutAll: each ] 
		separatedBy: [ aStream nextPut: ', ' ].
	aStream nextPut: $).
]
