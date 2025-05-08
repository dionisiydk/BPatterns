Extension { #name : 'OCMessageNode' }

{ #category : '*BPatterns' }
OCMessageNode >> bePatternNode [
	| patternNode |
	patternNode := BPatternMessageNode new
		receiver: receiver 
		selector: selector 
		keywordsPositions: keywordsPositions 
		arguments: arguments.
	patternNode parent: parent.
	patternNode become: self
]
