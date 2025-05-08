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
	| fullAST |
	fullAST := aBlock sourceNode.
	^(fullAST statements size == 1 and: [ fullAST temporaries isEmpty ])
		  ifTrue: [ fullAST statements first ]
		  ifFalse: [ fullAST body ].
]

{ #category : 'helpers' }
BPatternRewriteTest >> rewriteAST: originalASTBlock by: aBPatternRewriteBlock compareTo: expectedASTBlock [

	| originalAST |
	brewrite := aBPatternRewriteBlock brewrite.
	originalAST := self expressionASTFrom: originalASTBlock.
	originalAST := OCSequenceNode statements: (Array with: originalAST).
	rewrittenAST := brewrite rewriteAST: originalAST.
	rewrittenCode := rewrittenAST formattedCode.
	expectedCode := (self expressionASTFrom: expectedASTBlock) formattedCode.
	self assert: rewrittenCode equals: expectedCode
]

{ #category : 'tests' }
BPatternRewriteTest >> testCreationFromBlock [ 

	| block searchBlock rewriteBlock |
	block := [:a | [ a isNil ifFalse: [ a printString ]] -> [ a ifNotNil: [ a printString ]]].
	searchBlock := (block value: nil) key.
	rewriteBlock := (block value: nil) value.
	brewrite := block brewrite.
	
	self assert: brewrite class equals: BPatternRewrite.
	self assert: brewrite definitionBlock identicalTo: block.
	self assert: brewrite searchPattern definitionBlock sourceNode equals: searchBlock sourceNode.
	self assert: brewrite rewritePattern definitionBlock sourceNode equals: rewriteBlock sourceNode.
	self assert: brewrite searchPattern patternAST variableNodes first isPatternNode.
	self assert: brewrite rewritePattern patternAST variableNodes first isPatternNode.
	self deny: block sourceNode variableNodes first isPatternNode "original AST was not modified"
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForConstantChange [

	self 
		rewriteAST: [ 3 + 4]
		by: [[ 3  ] -> [ 4 ]]
		compareTo: [ 4 + 4 ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForDuplicatesReplace [
	self 
		rewriteAST: [ self first; second. self first; second. self a. self b ]
		by: [:any :any2 | 
			[ any. any. any2  ] -> [ 2 timesRepeat: [ any ]. any2 ] 
				bpattern: {
					[ any ] -> [:var | var beStatement ].
					[ any2 ] -> [:var | var beStatement; beList ]
				}
		]
		compareTo: [ 2 timesRepeat: [ self first; second ]. self a. self b ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForIfNilRule [
	self 
		rewriteAST: [:someVar | someVar isNil ifFalse: [ someVar printString ]]
		by:  [:a | 
			[ a isNil ifFalse: [ a printString ]] -> [ a ifNotNil: [ a printString ]]
		]
		compareTo: [:someVar | someVar ifNotNil: [ someVar printString ]]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForInstVarRename [

	self 
		rewriteAST: [  instVar printString  ]
		by: [ 	[  instVar  ] -> [ instVarNewName  ] ]
		compareTo: [ instVarNewName printString ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForKeywordReplace [
	self 
		rewriteAST: [ ^self foo: 1 put: 2 ]
		by: [:rcvr :arg1 :arg2 | 
			[ ^rcvr any: arg1 put: arg2 ] -> [ ^rcvr put: arg1 put: arg2 ]
				bpattern: #any:
		]
		compareTo: [ ^self put: 1 put: 2 ] 
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForMessageReceiverAndArgSwap [
	self 
		rewriteAST: [ 1 + 2 + 3. 3 foo: 4 ]
		by: [:rcvr :arg | 
			[ rcvr message: arg ] -> [ arg message: rcvr ]
				bpattern: {#message: . [ rcvr. arg. ] -> [:p | p beList; beRecursive] }
				
		]
		compareTo: [ 3 + (2 + 1). 4 foo: 3 ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForMessageReplace [
	self 
		rewriteAST: [ self a: 1 c: 2; b ]
		by: [:rcvr :arg1 :arg2 | 
			[ rcvr any1: arg1 any2: arg2; any3 ] -> [ rcvr d: arg2 e: arg1; f. self halt ]
				bpattern: #(any1:any2: any3)
		]
		compareTo: [ self d: 2 e: 1; f. self halt ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForReturnReplace [

	self 
		rewriteAST: [ ^self foo value: 1  ]
		by: [:anything | 	[ ^anything  ] -> [ self return: anything  ] ]
		compareTo: [ self return: (self foo value: 1) ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForTempRenameOfAssignment [

	| a b |
	self 
		rewriteAST: [ a := self a  ]
		by: [ 	[ a  ] -> [ b  ] ]
		compareTo: [ b := self a ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteForTempRenameOfMessageReceiver [

	| a b |
	self 
		rewriteAST: [ a printString  ]
		by: [ 	[ a  ] -> [ b  ] ]
		compareTo: [ b printString ]
]

{ #category : 'tests' }
BPatternRewriteTest >> testRewriteMultipleExpressions [

	| bar a b c |
	self 
		rewriteAST: [ self foo: 1. bar foo1 foo: 2. (self foo: a) foo: (b foo: c)]
		by: [:rcv :arg | 	[ rcv foo: arg  ] -> [ rcv bar: arg ] ]
		compareTo: [self bar: 1. bar foo1 bar: 2. (self bar: a) bar: (b bar: c)]
]
