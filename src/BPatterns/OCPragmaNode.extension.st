Extension { #name : 'OCPragmaNode' }

{ #category : '*BPatterns' }
OCPragmaNode >> bePatternNode [
	| patternNode |
	patternNode := BPatternPragmaNode new
			selector: self selector 
			keywordsPositions: self keywordsPositions
			arguments: self arguments.
	patternNode parent: parent.
	patternNode become: self
]
