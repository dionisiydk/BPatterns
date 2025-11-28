Class {
	#name : 'BPatternASTRewriter',
	#superclass : 'OCParseTreeRewriter',
	#category : 'BPatterns',
	#package : 'BPatterns'
}

{ #category : 'nil' }
BPatternASTRewriter >> performSearches: aSearchCollection on: aNode [
	| value result |
	result := nil.
	aSearchCollection do: [ :aSearchRule|
		value := aSearchRule performOn: aNode.
		value ifNotNil:
				[self foundMatch.
				result ifNil: [ result := value]]].
	^result
]

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

{ #category : 'private' }
BPatternASTRewriter >> visitNode: aNode [
	| value |
	value := self performSearches: searches on: aNode.
	^ value
		ifNil: [
			aNode acceptVisitor: self.
			aNode ]
		ifNotNil: [ value ]
]
