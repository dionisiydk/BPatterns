Class {
	#name : 'BPatternRewriteTest',
	#superclass : 'TestCase',
	#instVars : [
		'rewrittenAST',
		'rewrittenCode',
		'expectedCode',
		'instVar',
		'instVarNewName',
		'brewrite'
	],
	#category : 'BPatterns-Tests',
	#package : 'BPatterns-Tests'
}

{ #category : 'helpers' }
BPatternRewriteTest >> expressionASTFrom: aBlock [
	| fullAST expressionAST |
	fullAST := aBlock sourceNode copy.
	expressionAST := (fullAST statements size == 1 and: [ fullAST temporaries isEmpty ])
		  ifTrue: [ fullAST statements first ]
		  ifFalse: [ fullAST body ].
	^OCSequenceNode statements: (Array with: expressionAST)
]

{ #category : 'helpers' }
BPatternRewriteTest >> rewriteAST: originalAST compareTo: expectedAST [

	rewrittenAST := brewrite rewriteAST: originalAST.
	rewrittenCode := rewrittenAST formattedCode.
	expectedCode := expectedAST formattedCode.
	self assert: rewrittenCode equals: expectedCode
]

{ #category : 'helpers' }
BPatternRewriteTest >> rewriteBlock: originalASTBlock by: aBPatternRewriteBlock compareTo: expectedASTBlock [

	self rewriteBlock: originalASTBlock by: aBPatternRewriteBlock with: #() compareTo: expectedASTBlock
]

{ #category : 'helpers' }
BPatternRewriteTest >> rewriteBlock: originalASTBlock by: aBPatternRewriteBlock with: configSpecs compareTo: expectedASTBlock [

	brewrite := aBPatternRewriteBlock brewrite with: configSpecs.
	self 
		rewriteAST: (self expressionASTFrom: originalASTBlock)
		compareTo: (self expressionASTFrom: expectedASTBlock)
]

{ #category : 'helpers' }
BPatternRewriteTest >> rewriteMethod: aSelector by: aBPatternRewriteBlock [

	self 
		rewriteMethod: aSelector 
		by: aBPatternRewriteBlock
		with: #()
]

{ #category : 'helpers' }
BPatternRewriteTest >> rewriteMethod: aSelector by: aBPatternRewriteBlock with: configSpecs [

	brewrite := aBPatternRewriteBlock brewrite with: configSpecs.
	self 
		rewriteAST: (BPatternMethodExamples >> aSelector) ast
		compareTo: (BPatternRewrittenMethodExamples >> aSelector) ast
]

{ #category : 'tests' }
BPatternRewriteTest >> testCreationFromBlock [ 

	| block searchBlock rewriteBlock any |
	block := [[ any isNil ifFalse: [ any printString ]] -> [ any ifNotNil: [ any printString ]]].
	searchBlock := block value key.
	rewriteBlock := block value value.
	brewrite := block brewrite.
	
	self assert: brewrite class equals: BPatternRewrite.
	self assert: brewrite searchPattern patternAST sourceCode equals: searchBlock sourceNode body sourceCode.
	self assert: brewrite rewritePattern patternAST sourceCode equals: rewriteBlock sourceNode body sourceCode.
	self assert: brewrite searchPattern patternAST variableNodes first isPatternNode.
	self assert: brewrite rewritePattern patternAST variableNodes first isPatternNode.
	self deny: block sourceNode variableNodes first isPatternNode "original AST was not modified"
]

{ #category : 'tests' }
BPatternRewriteTest >> testPrinting [

	| actual a b |
	brewrite := [ [ a someMessage: b ]  -> [ b someMessage: a ]] brewrite.
	actual := brewrite printString.
	self assert: actual equals: 'a BPatternRewrite([ a someMessage: b ] -> [ b someMessage: a ])'
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForAnyLiteralReplace [
	| any |
	self 
		rewriteBlock: [ 10 + 30 + instVar ]
		by: [ [ any ] -> [ any * 2 ] ]
		with: [ any ] -> [:pattern | pattern beLiteral ]
		compareTo: [ (10 * 2) + (30 * 2) + instVar ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForAnyVarRename [
	| any |
	self 
		rewriteBlock: [ instVar printString ]
		by: [ [ any ] -> [ instVarNewName ] ] 
		with: [ any ] -> [:pattern | pattern beVariable ]
		compareTo: [ instVarNewName printString ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForBinaryMessageUsingBinaryPattern [
	| anyNum1 anyNum2 |
	self 
		rewriteBlock: [ 3 + 1 raisedTo: 2 - 1]
		by: [ [ anyNum1 + anyNum2] -> [ anyNum1 max: anyNum2 ] ]
		with: #+
		compareTo: [ (3 max: 1) raisedTo: (2 max: 1) ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForBinaryMessageUsingKeywordPattern [
	| anyNum1 anyNum2 |
	self 
		rewriteBlock: [ 3 + 1 raisedTo: 2 - 1]
		by: [ [ anyNum1 anyMessage: anyNum2] -> [ anyNum1 max: anyNum2 ] ]
		with: #anyMessage: -> [:pattern | pattern beBinary ]
		compareTo: [ (3 max: 1) raisedTo: (2 max: 1) ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForCascade [
	self 
		rewriteBlock: [ self foo; printString; foo: 4; bar. self foo: 4 ]
		by: [
			[ self messages1; foo: 4; messages2 ] 
				-> [ self messages2; bar: 4; messages1 ]
		]
		with:  #(messages1 messages2) -> [ :p | p beCascadeList ]
		compareTo: [ self bar; bar: 4; foo; printString. self foo:4 ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForConstantChange [

	self 
		rewriteBlock: [ 3 + 4 ]
		by: [[ 3 ] -> [ 4 ]]
		compareTo: [ 4 + 4 ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForDuplicatesReplace [
	| any any2 |
	self 
		rewriteBlock: [ self first; second. self first; second. self a. self b ]
		by: [ [ any. any. any2  ] -> [ 2 timesRepeat: [ any ]. any2 ] ]
		with: {
			[ any ] -> [:var | var beStatement ].
			[ any2 ] -> [:var | var beStatement; beList ]
		}
		compareTo: [ 2 timesRepeat: [ self first; second ]. self a. self b ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForDynamicArray [
	| any1 any2 any3 |
	self 
		rewriteBlock: [ {(1 @ 255). (Color lightMagenta). 3} ]
		by: [
			[ {any1. any2. any3} ] -> [ Array with: any1 with: any2 with: any3 ]				
		]
		compareTo: [ Array with: 1 @ 255 with: Color lightMagenta with: 3 ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForFullASTReplaceUsingPatternVar [

	| any |
	self 
		rewriteBlock: [ instVar printString ]
		by: [ [ any ] -> [ instVarNewName ] ]
		compareTo: [ instVarNewName  ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForIfNilRule [
	| any |
	self 
		rewriteBlock: [:someVar | someVar isNil ifFalse: [ someVar printString ]]
		by:  [
			[ any isNil ifFalse: [ any printString ]] -> [ any ifNotNil: [ any printString ]]
		]
		compareTo: [:someVar | someVar ifNotNil: [ someVar printString ]]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForInstVarRenameUsingConcreteVarName [

	self 
		rewriteBlock: [ instVar printString ]
		by: [ 	[ instVar ] -> [ instVarNewName ] ]
		compareTo: [ instVarNewName printString ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForKeywordReplace [
	| anyRcv anyArg1 anyArg2 |
	self 
		rewriteBlock: [ ^self foo: 1 put: 2 ]
		by: [
			[ ^anyRcv any: anyArg1 put: anyArg2 ] -> [ ^anyRcv put: anyArg1 put: anyArg2 ]
		] 
		compareTo: [ ^self put: 1 put: 2 ] 
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForKeywordReplaceShouldIgnoreUnmachedSelectors [
	| anyRcv anyArg1 anyArg2 |
	self 
		rewriteBlock: [ ^self foo: 1 some: 2 ]
		by: [
			[ ^anyRcv any: anyArg1 put: anyArg2 ] -> [ ^anyRcv put: anyArg1 put: anyArg2 ]				
		] 
		compareTo: [ ^self foo: 1 some: 2 ] 
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForKeywordSwapWithPattern [
	| anyRcv anyArg1 anyArg2 |
	self 
		rewriteBlock: [ ^self foo: 1 put: 2 ]
		by: [
			[ ^anyRcv any: anyArg1 put: anyArg2 ] -> [ ^anyRcv put: anyArg1 any: anyArg2 ]
		] 
		compareTo: [ ^self put: 1 foo: 2 ] 
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForMessageReceiverAndArgSwap [
	| rcvr arg |
	self 
		rewriteBlock: [ 1 + 2 + 3. 3 foo: 4 ]
		by: [ [ rcvr message: arg ] -> [ arg message: rcvr ] ]
		with: {#message: . [ rcvr. arg. ] -> [:p | p beList; beRecursive] }
		compareTo: [ 3 + (2 + 1). 4 foo: 3 ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForMessageReplace [
	| anyRcv anyArg1 anyArg2 |
	self 
		rewriteBlock: [ self a: 1 c: 2; b ]
		by: [
			[ anyRcv part1: anyArg1 part2: anyArg2; another ] 
				-> [ anyRcv d: anyArg2 e: anyArg1; f. self someMessage ]
		]
		with: #(part1:part2: another)
		compareTo: [ self d: 2 e: 1; f. self someMessage ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForMessageReplaceWithDefaultPatternSeletors [
	| anyRcv anyArg1 anyArg2 |
	self 
		rewriteBlock: [ self a: 1 c: 2; b ]
		by: [
			[ anyRcv any1: anyArg1 any2: anyArg2; any3 ] -> [ anyRcv d: anyArg2 e: anyArg1; f. self someMessage ]
		]
		compareTo: [ self d: 2 e: 1; f. self someMessage ]
]

{ #category : 'tests on methods' }
BPatternRewriteTest >> testRewriteForMethodsUsingNoArgsPattern [

	| anyStmts |
	self 
		rewriteMethod: #recursionMethod:with:
		by: [
			[[ self anyMessage ] -> [ anyStmts. self anyMessage ]] bmethod 
				->
			[[ self anyMessage ] -> [ [ anyStmts ] repeat ]] bmethod
		]
]

{ #category : 'tests on methods' }
BPatternRewriteTest >> testRewriteForMethodsWithTempRename [

	self 
		rewriteMethod: #recursionMethodByRenamedTemp:with:
		by: [
			[[ self anyMessage ] -> [| tempA tempB | ^tempA + tempB ]] bmethod 
				->
			[[ self anyMessage ] -> [| tempC tempB | ^tempC + tempB ]] bmethod
		]
]

{ #category : 'tests on methods' }
BPatternRewriteTest >> testRewriteForMethodsWithTempsWithoutTempsInPattern [

	| anyStmts |
	self 
		rewriteMethod: #recursionMethodWithTemps:with:
		by: [
			[[ self anyMessage ] -> [ anyStmts. self anyMessage ]] bmethod 
				->
			[[ self anyMessage ] -> [ [ anyStmts ] repeat ]] bmethod
		]
		with: [ anyStmts ] -> [:pattern | pattern beList ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForReturnReplace [

	| any |
	self 
		rewriteBlock: [ ^self foo value: 1  ]
		by: [ [ ^any  ] -> [ self return: any ] ]
		compareTo: [ self return: (self foo value: 1) ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForTempRenameInAssignment [

	| a b |
	self 
		rewriteBlock: [ a := self a  ]
		by: [ 	[ a ] -> [ b ] ]
		compareTo: [ b := self a ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForTempRenameInMessageReceiver [

	| a b |
	self 
		rewriteBlock: [ a printString  ]
		by: [ 	[ a ] -> [ b ] ]
		compareTo: [ b printString ]
]

{ #category : 'tests on methods' }
BPatternRewriteTest >> testRewriteMethodForArgRename [

	| arg renamedArg |
	self 
		rewriteMethod: #methodWithRenamedArg:
		by:  [ [ arg ] -> [ renamedArg ] ]
]

{ #category : 'tests on methods' }
BPatternRewriteTest >> testRewriteMethodForIfNilRule [

	| any |
	self 
		rewriteMethod: ##isNilIfFalseWith:
		by:  [
			[ any isNil ifFalse: [ any printString ]] -> [ any ifNotNil: [ any printString ]]
		]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteMultipleExpressions [

	| bar a b c anyRcv anyArg |
	self 
		rewriteBlock: [ self foo: 1. bar foo1 foo: 2. (self foo: a) foo: (b foo: c)]
		by: [ [ anyRcv foo: anyArg ] -> [ anyRcv bar: anyArg ] ]
		compareTo: [self bar: 1. bar foo1 bar: 2. (self bar: a) bar: (b bar: c)]
]
