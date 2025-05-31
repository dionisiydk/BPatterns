Class {
	#name : 'BPatternASTRewriter',
	#superclass : 'OCParseTreeRewriter',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'visiting' }
BPatternASTRewriter >> visitArgumentNode: aNode [
	| value |
	value := self performSearches: searches on: aNode.
	^ value
		ifNil: [
			super visitArgumentNode: aNode.
			aNode ]
		ifNotNil: [ value ]
]
