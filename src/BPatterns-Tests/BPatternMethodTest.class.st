Class {
	#name : 'BPatternMethodTest',
	#superclass : 'TestCase',
	#category : 'BPatterns-Tests',
	#package : 'BPatterns-Tests'
}

{ #category : 'tests' }
BPatternMethodTest >> testCreationFromBlockWithMultipleStatements [
	| actual block |
	block := [ :arg :stmps | [ self someMessage: arg ] -> [ stmps.  ^arg printString ]].
	actual := block bmethod.
	
	self assert: actual class equals: BPatternMethod.
	self assert: actual definitionBlock identicalTo: block.
	self assert: actual patternAST body class equals: OCSequenceNode.
	self assert: actual patternAST body statements size equals: 2.
]

{ #category : 'tests' }
BPatternMethodTest >> testCreationFromBlockWithSelectorPatterns [
	| actual block allVarNodes patternVarNodes |
	block := [ :arg :arg2 | [ self anyMessage: arg nonPatternPart: arg2 ] -> [ ^arg printString ]].
	actual := block bmethod bpattern: #(anyMessage:).
	
	self assert: actual class equals: BPatternMethod.
	self assert: actual definitionBlock identicalTo: block.
	self assert: actual patternAST class equals: BPatternMethodNode.
	self assert: actual patternAST patternKeywords equals: #(#anyMessage:).
	self assert: actual patternAST selector equals: #anyMessage:nonPatternPart:.
	self assert: actual patternAST argumentNames equals: #('arg' 'arg2').
	self assert: actual patternAST body class equals: OCSequenceNode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | each name = block argumentNames first ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
	].	 
	block sourceNode variableNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	]
]

{ #category : 'tests' }
BPatternMethodTest >> testCreationFromBlockWithoutSelectorPatterns [
	| actual block allVarNodes patternVarNodes |
	block := [ :arg | [ self someMessage: arg ] -> [ ^arg printString ]].
	actual := block bmethod.
	
	self assert: actual class equals: BPatternMethod.
	self assert: actual definitionBlock identicalTo: block.
	self assert: actual patternAST class equals: BPatternMethodNode.
	self assert: actual patternAST patternKeywords isEmpty.
	self assert: actual patternAST selector equals: #someMessage:.
	self assert: actual patternAST argumentNames equals: #('arg').
	self assert: actual patternAST body temporaries size equals: 1.
	self assert: actual patternAST body temporaries first isPatternNode.
	self assert: actual patternAST body temporaries first isList.
	self assert: actual patternAST body class equals: OCSequenceNode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | each name = block argumentNames first ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
	].	 
	block sourceNode variableNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	]
]
