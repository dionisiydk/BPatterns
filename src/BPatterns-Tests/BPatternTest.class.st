Class {
	#name : 'BPatternTest',
	#superclass : 'TestCase',
	#category : 'BPatterns-Tests',
	#package : 'BPatterns-Tests'
}

{ #category : 'tests' }
BPatternTest >> testComparison [

	| bpattern anotherPattern |
	bpattern := [ #someBlock1 ] bpattern.
	self assert: bpattern = bpattern.
	self assert: bpattern copy = bpattern.
	self assert: bpattern copy hash equals: bpattern hash.
	
	anotherPattern := [ #anotherBlock ] bpattern.
	self deny: bpattern = anotherPattern
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlock [ 

	| actual block allVarNodes patternVarNodes |
	block := [:a | | nonPatternTemp | nonPatternTemp := a isNil ifFalse: [ a printString ]].
	actual := block bpattern.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST sourceCode equals: block sourceNode body sourceCode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | each name = block argumentNames first ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
		self assert: each isAnything.
	].	 
	(allVarNodes copyWithoutAll: patternVarNodes) do: [ :each |
			self deny: each isPatternNode 
	].
	block sourceNode variableNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	]
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlockForCascadeWithExternalPatternReceiver [

	| actual block allVarNodes patternVarNodes patternVar |
	block := [ patternVar printString; asString].
	actual := block bpattern: [patternVar].
	
	self assert: actual patternAST isCascade.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | each name = 'patternVar' ].
	self assert: patternVarNodes size equals: 2.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
	]
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlockUsingDefaultSelectorPattern [

	| actual anyVar varNode |
	actual := [ anyVar anySelector: #arg1 nonPattern: #arg3 ] bpattern.
	
	self assert: actual class equals: BPattern.
	varNode :=  actual patternAST sendNodes first.
	self assert: varNode isPatternNode.
	self deny: varNode isSelectorList.
	self assert: varNode patternKeywords asArray equals: #('anySelector:')
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlockUsingDefaultUnarySelectorPattern [

	| actual anyVar varNode |
	actual := [ anyVar anySelector ] bpattern.
	
	self assert: actual class equals: BPattern.
	varNode :=  actual patternAST sendNodes first.
	self assert: varNode isPatternNode.
	self assert: varNode isSelectorList.
	self assert: varNode patternKeywords asArray equals: #('anySelector')
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlockUsingDefaultVarPattern [

	| actual anyVar varNode |
	actual := [ anyVar printString ] bpattern.
	
	self assert: actual class equals: BPattern.
	varNode :=  actual patternAST variableNodes first.
	self assert: varNode isPatternNode.
	self assert: varNode isAnything.
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlockWithDefaultSelectorPattern [

	| actual block allMessages patternMessage |
	block := [:a :b| self nonPatternPart: a anySuffix: b. a printString ].
	actual := block bpattern.
	
	self assert: actual class equals: BPattern.
	allMessages := actual patternAST sendNodes.
	patternMessage := allMessages first.
	self assert: patternMessage isPatternNode.
	self assert: patternMessage patternKeywords asArray equals: #('anySuffix:').
	self deny: allMessages second isPatternNode.
	block sourceNode sendNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	].
	block sourceNode variableNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	]
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlockWithExternalPatternVar [

	| actual block allVarNodes patternVarNodes patternTemp |
	block := [ | nonPatternVar | patternTemp isNil ifFalse: [ patternTemp printString. nonPatternVar ]].
	actual := block bpattern: [ patternTemp ].
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST sourceCode equals: block sourceNode body sourceCode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | each name = 'patternTemp' ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
		self assert: each isAnything.	
	].	 
	(allVarNodes copyWithoutAll: patternVarNodes) do: [ :each |
			self deny: each isPatternNode 
	].
	block sourceNode variableNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	]
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlockWithSelectorPattern [

	| actual block allMessages patternMessage |
	block := [:a :b| self nonPatternPart: a patternSuffix: b. a printString ].
	actual := block bpattern: #patternSuffix:.
	
	self assert: actual class equals: BPattern.
	allMessages := actual patternAST sendNodes.
	patternMessage := allMessages first.
	self assert: patternMessage isPatternNode.
	self assert: patternMessage patternKeywords asArray equals: #('patternSuffix:').
	self deny: allMessages second isPatternNode.
	block sourceNode sendNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	].
	block sourceNode variableNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	]
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlockWithStringPatternVar [

	| actual block allVarNodes patternVarNodes nonPatternVar |
	block := [ | patternVar | nonPatternVar isNil ifFalse: [ patternVar printString. nonPatternVar ]].
	actual := block bpattern: 'patternVar'.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST sourceCode equals: block sourceNode body sourceCode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | each name = 'patternVar' ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
		self assert: each isAnything.	
	].	 
	(allVarNodes copyWithoutAll: patternVarNodes) do: [ :each |
			self deny: each isPatternNode 
	].
	block sourceNode variableNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	]
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlockWithVarDefinitionBlock [

	| actual block allVarNodes patternVarNodes patternTemp |
	block := [ | nonPatternVar | patternTemp isNil ifFalse: [ patternTemp printString. nonPatternVar ]].
	actual := block bpattern: [ patternTemp ] -> [:pattern | pattern beStatement ].
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST sourceCode equals: block sourceNode body sourceCode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | each name = 'patternTemp' ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
		self assert: each isAnything.
		self assert: each isStatement.
	].	 
	(allVarNodes copyWithoutAll: patternVarNodes) do: [ :each |
			self deny: each isPatternNode 
	].
	block sourceNode variableNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	]
]

{ #category : 'tests' }
BPatternTest >> testMethodCreationFromBlockWithDefaultSelectorPatterns [
	| actual block allVarNodes patternVarNodes |
	block := [ :arg :arg2 | [ self anyMessage: arg nonPatternPart: arg2 ] -> [ ^arg printString ]].
	actual := block bmethod.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST class equals: BPatternMethodNode.
	self assert: actual patternAST patternKeywords asArray equals: #('anyMessage:').
	self assert: actual patternAST selector equals: #anyMessage:nonPatternPart:.
	self assert: actual patternAST argumentNames equals: #('arg' 'arg2').
	self assert: actual patternAST body class equals: OCSequenceNode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | block argumentNames includes: each name ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
	].	 
	block sourceNode variableNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	]
]

{ #category : 'tests' }
BPatternTest >> testMethodCreationFromBlockWithDefaultUnarySelectorPattern [
	| actual block |
	block := [ :arg | [ self anyMessage ] -> [ super anyMessage ]]. 
	actual := block bmethod.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST class equals: BPatternMethodNode.
	self assert: actual patternAST patternKeywords asArray equals: #('anyMessage').
	self assert: actual patternAST selector equals: #anyMessage.
	self assert: actual patternAST isSelectorList.
	self assert: actual patternAST body sendNodes first selector equals: #anyMessage.
	self assert: actual patternAST body sendNodes first isPatternNode.
	self assert: actual patternAST patternKeywords asArray equals: #('anyMessage').
	self assert: actual patternAST body sendNodes first isSelectorList.	
]

{ #category : 'tests' }
BPatternTest >> testMethodCreationFromBlockWithMultipleStatements [
	| actual block |
	block := [ :arg :stmps | [ self someMessage: arg ] -> [ stmps.  ^arg printString ]].
	actual :=  block bmethod.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST body class equals: OCSequenceNode.
	self assert: actual patternAST body statements size equals: 2.
]

{ #category : 'tests' }
BPatternTest >> testMethodCreationFromBlockWithSelectorPatterns [
	| actual block allVarNodes patternVarNodes |
	block := [ :arg :arg2 | [ self patternPart: arg nonPatternPart: arg2 ] -> [ ^arg printString ]].
	actual := block bmethod bpattern: #patternPart:.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST class equals: BPatternMethodNode.
	self assert: actual patternAST patternKeywords asArray equals: #(#patternPart:).
	self assert: actual patternAST selector equals: #patternPart:nonPatternPart:.
	self assert: actual patternAST argumentNames equals: #('arg' 'arg2').
	self assert: actual patternAST body class equals: OCSequenceNode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | block argumentNames includes: each name ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
	].	 
	block sourceNode variableNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	]
]

{ #category : 'tests' }
BPatternTest >> testMethodCreationFromBlockWithUnarySelectorPattern [
	| actual block |
	block := [ :arg | [ self someMessage ] -> [ super someMessage ]]. 
	actual := block bmethod bpattern: #someMessage.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST class equals: BPatternMethodNode.
	self assert: actual patternAST patternKeywords asArray equals: #('someMessage').
	self assert: actual patternAST selector equals: #someMessage.
	self deny: actual patternAST isSelectorList.
	self assert: actual patternAST body sendNodes first selector equals: #someMessage.
	self assert: actual patternAST body sendNodes first isPatternNode.
	self assert: actual patternAST patternKeywords asArray equals: #('someMessage').
	self deny: actual patternAST body sendNodes first isSelectorList.	
]

{ #category : 'tests' }
BPatternTest >> testMethodCreationFromBlockWithoutSelectorPatterns [
	| actual block allVarNodes patternVarNodes |
	block := [ :arg | [ self someMessage: arg ] -> [ ^arg printString ]]. 
	actual := block bmethod.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST class equals: BPatternMethodNode.
	self deny: actual patternAST isSelectorList.
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

{ #category : 'tests' }
BPatternTest >> testPrinting [

	| actual pattern|
	pattern := [:a :b| a someMessage: b ] bpattern.
	actual := pattern printString.
	
	self assert: actual equals: 'a BPattern(a someMessage: b)'
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
BPatternTest >> testRewriteASTExternalPatternVar [
	| searchBlock rewriteBlock searchPattern rewritePattern originalBlock rewrittenAST rewrittenCode expectedResult a |
	searchBlock := [a isNil ifFalse: [ a printString ]].
	rewriteBlock := [a ifNotNil: [ a printString ]].
	searchPattern := searchBlock bpattern: { [ a ] }.
	rewritePattern := rewriteBlock bpattern: { [ a ] }.
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
