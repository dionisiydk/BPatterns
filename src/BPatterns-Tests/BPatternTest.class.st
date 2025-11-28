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
BPatternTest >> testComparisonForBMethodWithFilters [
	
	| bpattern anyRcv anyArg bpattern2 |
	bpattern := [[self someMethod: anyArg] -> [ anyRcv anyMessage: anyArg ]] bmethod 
		with: [ anyArg ] -> [ :pattern | pattern beArg where: [:var | var name beginsWith: 'a' ]];
		with: #someMethod: -> [:pattern | pattern beKeyword ].
	self assert: bpattern = bpattern.
	self assert: bpattern copy = bpattern.
	self assert: bpattern copy hash equals: bpattern hash.
	
	bpattern2 := [[self someMethod: anyArg] -> [ anyRcv anyMessage: anyArg ]] bmethod 
		with: [ anyArg ] -> [ :pattern | pattern beArg where: [:var | var name beginsWith: 'a' ]];
		with: #someMethod: -> [:pattern | pattern beKeyword ].
	self assert: bpattern = bpattern2.
	self assert: bpattern hash = bpattern2 hash.
	
	bpattern2 := [[self someMethod: anyArg] -> [ anyRcv anyMessage: anyArg ]] bmethod 
		with: [ anyArg ] -> [ :pattern | pattern beArg where: [:var | var name beginsWith: 'a' ]].
	self deny: bpattern = bpattern2.
	
	bpattern2 := [[self someMethod: anyArg] -> [ anyRcv anyMessage: anyArg ]] bmethod 
		with: [ anyArg ] -> [ :pattern | pattern beArg where: [:var | var name beginsWith: 'some' ]];
		with: #someMethod: -> [:pattern | pattern beKeyword ].
	self deny: bpattern = bpattern2.
	
	bpattern2 := [[self someMethod: anyArg] -> [ anyRcv anyMessage: anyArg ]] bmethod 
		with: [ anyArg ] -> [ :pattern | pattern beArg where: [:var | var name beginsWith: 'a' ]];
		with: #someMethod: -> [:pattern | pattern beBinary ].
	self deny: bpattern = bpattern2.
	
	bpattern2 := [[self someMethod: anyArg] -> [ anyRcv anyMessage: anyArg ]] bmethod 
		with: #someMethod: -> [:pattern | pattern beKeyword ].
	self deny: bpattern = bpattern2
]

{ #category : 'tests' }
BPatternTest >> testComparisonWithFilters [
	
	| bpattern anyRcv anyArg bpattern2 |
	bpattern := [ anyRcv anyMessage: anyArg ] bpattern 
		with: [ anyRcv ] -> [ :pattern | pattern beInstVar where: [:var | var name beginsWith: 'prim' ]];
		with: [ anyArg ] -> [ :pattern | pattern beInstVar where: [:var | var name beginsWith: 'a' ]];
		with: #anyMessage: -> [:pattern | pattern beKeyword ].
	self assert: bpattern = bpattern.
	self assert: bpattern copy = bpattern.
	self assert: bpattern copy hash equals: bpattern hash.
	
	bpattern2 := [ anyRcv anyMessage: anyArg ] bpattern 
		with: [ anyRcv ] -> [ :pattern | pattern beInstVar where: [:var | var name beginsWith: 'prim' ]];
		with: [ anyArg ] -> [ :pattern | pattern beInstVar where: [:var | var name beginsWith: 'a' ]];
		with: #anyMessage: -> [:pattern | pattern beKeyword ].
	self assert: bpattern = bpattern2.
	self assert: bpattern hash = bpattern2 hash.
	
	bpattern2 := [ anyRcv anyMessage: anyArg ] bpattern 
		with: [ anyRcv ] -> [ :pattern | pattern beInstVar where: [:var | var name beginsWith: 'prim' ]];
		with: [ anyArg ] -> [ :pattern | pattern beInstVar where: [:var | var name beginsWith: 'a' ]].
	self deny: bpattern = bpattern2.
	
	bpattern2 := [ anyRcv anyMessage: anyArg ] bpattern 
		with: [ anyRcv ] -> [ :pattern | pattern beInstVar where: [:var | var name beginsWith: 'prim' ]];
		with: #anyMessage: -> [:pattern | pattern beKeyword ].
	self deny: bpattern = bpattern2.
	
	bpattern2 := [ anyRcv anyMessage: anyArg ] bpattern 
		with: [ anyRcv ] -> [ :pattern | pattern beInstVar where: [:var | var name beginsWith: 'prim' ]];
		with: [ anyArg ] -> [ :pattern | pattern beInstVar where: [:var | var name beginsWith: 'abc' ]];
		with: #anyMessage: -> [:pattern | pattern beKeyword ].
	self deny: bpattern = bpattern2.
	
	bpattern2 := [ anyRcv anyMessage: anyArg ] bpattern 
		with: [ anyRcv ] -> [ :pattern | pattern beInstVar where: [:var | var name beginsWith: 'prim' ]];
		with: [ anyArg ] -> [ :pattern | pattern beInstVar where: [:var | var name beginsWith: 'a' ]];
		with: #anyMessage: -> [:pattern | pattern beKeyword ];
		with: #anyMessage: -> [:pattern | pattern where: [ :node | node selector beginsWith: 'some' ]].
	self deny: bpattern = bpattern2
]

{ #category : 'tests' }
BPatternTest >> testConfigurationMultipleTimesAfterApply [
	
	| bpattern rcv arg  pattern |
	bpattern := [ rcv anyMessage: arg ] bpattern with: [ rcv ].
	pattern := bpattern patternAST variableNodes detect: [:node| node name = 'arg' ].
	self deny: pattern isPatternNode.
	
	bpattern with: [ arg ].
	pattern := bpattern patternAST variableNodes detect: [:node| node name = 'arg' ].
	self assert: pattern isPatternNode.
]

{ #category : 'tests' }
BPatternTest >> testCopy [
	
	| bpattern anyRcv anyArg copy |
	bpattern := [ anyRcv anyMessage: anyArg ] bpattern.
	copy := bpattern copy.
	self deny: bpattern patternAST identicalTo: copy patternAST.
	self assert: bpattern patternAST = copy patternAST.
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBMethodShouldNotModifyOriginalMethodAST [
	| block anyBody |
	block := [[ self anyMethod ] -> [ anyBody ]].
	block bmethod.
	
	block sourceNode variableNodes do: [:each | 
		self deny: each  isPatternNode "original AST was not modified"
	]
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBMethodWithAnyKeywordPattern [
	| actual allVarNodes patternVarNodes anyArg anyArg2 |
	actual := [[ self anyMessage: anyArg nonPatternPart: anyArg2 ] -> [ ^anyArg printString ]] bmethod.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST class equals: BPatternMethodNode.
	self assert: actual patternAST patternKeywords asArray equals: #('anyMessage:').
	self assert: actual patternAST selector equals: #anyMessage:nonPatternPart:.
	self assert: actual patternAST argumentNames equals: #('anyArg' 'anyArg2').
	self assert: actual patternAST body class equals: OCSequenceNode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | #('anyArg' 'anyArg2') includes: each name ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
	]
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBMethodWithAnyUnarySelectorPattern [
	| actual |
	actual := [ [ self anyMessage ] -> [ super anyMessage ]] bmethod. 
	
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
BPatternTest >> testCreationFromBMethodWithConfiguredKeywordPatterns [
	| actual allVarNodes patternVarNodes anyArg anyArg2 |
	actual := [[ self patternPart: anyArg nonPatternPart: anyArg2 ] -> [ ^anyArg printString ]] 
					bmethod with: #patternPart:.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST class equals: BPatternMethodNode.
	self assert: actual patternAST patternKeywords asArray equals: #(#patternPart:).
	self assert: actual patternAST selector equals: #patternPart:nonPatternPart:.
	self assert: actual patternAST argumentNames equals: #('anyArg' 'anyArg2').
	self assert: actual patternAST body class equals: OCSequenceNode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | #('anyArg' 'anyArg2') includes: each name ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
	]
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBMethodWithConfiguredUnarySelectorPattern [
	| actual |
	actual := [[ self someMessage ] -> [ super someMessage ]] bmethod with: #someMessage.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST class equals: BPatternMethodNode.
	self assert: actual patternAST patternKeywords asArray equals: #('someMessage').
	self assert: actual patternAST selector equals: #someMessage.
	self assert: actual patternAST isSelectorList.
	self assert: actual patternAST body sendNodes first selector equals: #someMessage.
	self assert: actual patternAST body sendNodes first isPatternNode.
	self assert: actual patternAST patternKeywords asArray equals: #('someMessage').
	self assert: actual patternAST body sendNodes first isSelectorList.	
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBMethodWithConfiguredUnarySelectorPatternInNonListMode [
	| actual |
	actual := [[ self someMessage ] -> [ super someMessage ]] bmethod
					with: #someMessage -> [:pattern | pattern beUnary ].
	
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
BPatternTest >> testCreationFromBMethodWithMultipleStatements [
	| actual arg stmps |
	actual := [[ self someMessage: arg ] -> [ stmps.  ^arg printString ]] bmethod.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST body class equals: OCSequenceNode.
	self assert: actual patternAST body statements size equals: 2.
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBMethodWithoutSelectorPatterns [
	| actual block allVarNodes patternVarNodes anyArg |
	actual := [ [ self someMessage: anyArg ] -> [ ^anyArg printString ]] bmethod. 
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST class equals: BPatternMethodNode.
	self deny: actual patternAST isSelectorList.
	self assert: actual patternAST patternKeywords isEmpty.
	self assert: actual patternAST selector equals: #someMessage:.
	self assert: actual patternAST argumentNames equals: #('anyArg').
	self assert: actual patternAST body temporaries size equals: 1.
	self assert: actual patternAST body temporaries first isPatternNode.
	self assert: actual patternAST body temporaries first isList.
	self assert: actual patternAST body class equals: OCSequenceNode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | each name = 'anyArg' ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
	]
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlock [ 

	| actual block allVarNodes patternVarNodes any |
	block := [| nonPatternTemp | nonPatternTemp := any isNil ifFalse: [ any printString ]].
	actual := block bpattern.
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST sourceCode equals: block sourceNode body sourceCode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | each name = 'any' ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
		self assert: each isAnything.
	].	 
	(allVarNodes copyWithoutAll: patternVarNodes) do: [ :each |
			self deny: each isPatternNode 
	]
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlockForCascadeWithExternalPatternReceiver [

	| actual allVarNodes patternVarNodes patternVar |
	actual := [ patternVar printString; asString] bpattern with: [ patternVar ].
	
	self assert: actual patternAST isCascade.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | each name = 'patternVar' ].
	self assert: patternVarNodes size equals: 2.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
	]
]

{ #category : 'tests' }
BPatternTest >> testCreationFromBlockShouldNotModifyOriginalMethodAST [

	| block any |
	block := [ any ].
	block bpattern.
	
	block sourceNode variableNodes do: [:each | 
		self deny: each isPatternNode "original AST was not modified"
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
	actual := block bpattern with: [ patternTemp ].
	
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
	actual := block bpattern with: #patternSuffix:.
	
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
	actual := block bpattern with: 'patternVar'.
	
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
	actual := block bpattern with: [ patternTemp ] -> [:pattern | pattern beVariable ].
	
	self assert: actual class equals: BPattern.
	self assert: actual patternAST sourceCode equals: block sourceNode body sourceCode.
	allVarNodes :=  actual patternAST variableNodes.
	patternVarNodes := allVarNodes select: [:each | each name = 'patternTemp' ].
	self assert: patternVarNodes notEmpty.
	patternVarNodes do: [:each | 
		self assert: each isPatternNode.
		self deny: each isAnything.
		self deny: each isStatement.
	].	 
	(allVarNodes copyWithoutAll: patternVarNodes) do: [ :each |
			self deny: each isPatternNode 
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
	| searchBlock rewriteBlock searchPattern rewritePattern originalBlock rewrittenAST rewrittenCode expectedResult any |
	searchBlock := [any isNil ifFalse: [ any printString ]].
	rewriteBlock := [any ifNotNil: [ any printString ]].
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
	searchPattern := searchBlock bpattern with: { [ a ] }.
	rewritePattern := rewriteBlock bpattern with: { [ a ] }.
	originalBlock := [:someVar | someVar isNil ifFalse: [ someVar printString ]].
	rewrittenAST := searchPattern rewriteAST: originalBlock sourceNode with: rewritePattern.
	rewrittenCode := rewrittenAST formattedCode.
	expectedResult := [:someVar | someVar ifNotNil: [ someVar printString ]] sourceNode formattedCode.
	self assert: rewrittenCode equals: expectedResult
]

{ #category : 'tests' }
BPatternTest >> testScanAST [
	| patternBlock pattern searchScopeBlock result matchVar any |
	patternBlock := [any isNil ifFalse: [ any printString ]].
	pattern := patternBlock bpattern.
	searchScopeBlock := [:someVar | someVar isNil ifFalse: [ someVar printString ]].

	result := pattern scanAST: searchScopeBlock sourceNode.
	
	matchVar := pattern patternAST variableNodes first.
	self assert: matchVar name equals: 'any'.
	self assert: (result at: matchVar) equals: searchScopeBlock sourceNode variableNodes first.
]
