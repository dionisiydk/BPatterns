Class {
	#name : 'BPatternTest',
	#superclass : 'TestCase',
	#category : 'BPatterns-Tests',
	#package : 'BPatterns-Tests'
}

{ #category : 'tests' }
BPatternTest >> testCreationFromBlock [ 

	| actual block allVarNodes patternVarNodes |
	block := [:a | | nonPatternTemp | nonPatternTemp := a isNil ifFalse: [ a printString ]].
	actual := block bpattern.
	
	self assert: actual class equals: BPattern.
	self assert: actual definitionBlock identicalTo: block.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | each name = block argumentNames first ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
		self assert: each isAnything
	].	 
	(allVarNodes copyWithoutAll: patternVarNodes) do: [ :each |
			self deny: each isPatternNode 
	].
	block sourceNode variableNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	]
]

{ #category : 'tests' }
BPatternTest >> testRewriteAST [
	| searchBlock rewriteBlock searchPattern rewritePattern originalBlock rewrittenAST rewrittenCode expectedResult |
	searchBlock := [:a | a isNil ifFalse: [ a printString ]].
	rewriteBlock := [ :a | a ifNotNil: [ a printString ]].
	searchPattern := searchBlock bpattern.
	rewritePattern := rewriteBlock bpattern.
	originalBlock := [:someVar | someVar isNil ifFalse: [ someVar printString ]].
	rewrittenAST := searchPattern rewriteAST: originalBlock sourceNode with: rewritePattern.
	rewrittenCode := rewrittenAST formattedCode.
	expectedResult := [:someVar | someVar ifNotNil: [ someVar printString ]] sourceNode formattedCode.
	self assert: rewrittenCode equals: expectedResult

]

{ #category : 'tests' }
BPatternTest >> testScanAST [
	| patternBlock pattern searchScopeBlock result matchVar |
	patternBlock := [:a | a isNil ifFalse: [ a printString ]].
	pattern := patternBlock bpattern.
	searchScopeBlock := [:someVar | someVar isNil ifFalse: [ someVar printString ]].

	result := pattern scanAST: searchScopeBlock sourceNode.
	
	matchVar := pattern patternAST variableNodes first.
	self assert: matchVar name equals: 'a'.
	self assert: (result at: matchVar) equals: searchScopeBlock sourceNode variableNodes first.
]
