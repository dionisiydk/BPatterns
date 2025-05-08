Extension { #name : 'OCPatternVariableNode' }

{ #category : '*BPatterns' }
OCPatternVariableNode >> beList [ 
	isList := true
]

{ #category : '*BPatterns' }
OCPatternVariableNode >> bePatternNode [
]

{ #category : '*BPatterns' }
OCPatternVariableNode >> beRecursive [
	recurseInto := true
]

{ #category : '*BPatterns' }
OCPatternVariableNode >> beSingle [ 
	isList := false
]

{ #category : '*BPatterns' }
OCPatternVariableNode >> beStatement [ 
	isAnything := false.
	isStatement := true
]

{ #category : '*BPatterns' }
OCPatternVariableNode >> isAnything: aBoolean [
	isAnything := aBoolean
]
