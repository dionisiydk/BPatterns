Extension { #name : 'OCVariableNode' }

{ #category : '*BPatterns' }
OCVariableNode >> bePatternNode [
	| patternNode |
	patternNode := BPatternVariableNode named: name start: start.
	patternNode 
		parent: parent; 
		variable: variable.
	patternNode become: self
]
