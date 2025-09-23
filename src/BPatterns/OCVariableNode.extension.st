Extension { #name : 'OCVariableNode' }

{ #category : '*BPatterns' }
OCVariableNode >> bePatternNode [
	| patternNode |
	patternNode := OCPatternVariableNode named: name start: start.
	patternNode 
		parent: parent; 
		variable: variable;
		prepareForBPattern.
	patternNode become: self
]
