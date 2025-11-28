Class {
	#name : 'BPatternMethodExamples',
	#superclass : 'Object',
	#instVars : [
		'instVar'
	],
	#category : 'BPatterns-Tests',
	#package : 'BPatterns-Tests'
}

{ #category : 'examples' }
BPatternMethodExamples >> isNilIfFalseWith: arg [
	^arg isNil ifFalse: [ arg printString ]
]

{ #category : 'as yet unclassified' }
BPatternMethodExamples >> methodForInstVarToArgSwapInsideMessage: arg [

	self someMessage: instVar
]

{ #category : 'as yet unclassified' }
BPatternMethodExamples >> methodWithArgSwapInsideMessage: arg1 arg2: arg2 [
	self someMessage: arg1 arg2: arg2
]

{ #category : 'as yet unclassified' }
BPatternMethodExamples >> methodWithInstVarToArgSwapInsideMessage: arg1 arg2: arg2 [

	self someMessage: arg1 arg2: instVar
]

{ #category : 'as yet unclassified' }
BPatternMethodExamples >> methodWithManyStatements [
	| someTemp arg someTemp2 |
	instVar printString. 
	someTemp someMessage: arg part2: 10. 
	someTemp2 printString
]

{ #category : 'as yet unclassified' }
BPatternMethodExamples >> methodWithManyStatementsForInstVarToArgSwapInsideMessage: arg [
	self printString.
	self someMessage: instVar.
	^self asArray
]

{ #category : 'examples' }
BPatternMethodExamples >> methodWithPragmaKeywordSwap: arg [
	<somePragma: 'test' part2: 123>
	<somePragma2: 'test2' part3: 567>
	^arg printString
]

{ #category : 'examples' }
BPatternMethodExamples >> methodWithRenamedArg: arg [
	^arg printString
]

{ #category : 'examples' }
BPatternMethodExamples >> methodWithRenamedPragma: arg [
	<somePragma: 'test' part2: 123>
	<somePragma2: 'test2' part3: 567>
	^arg printString
]

{ #category : 'examples' }
BPatternMethodExamples >> recursionMethod: arg1 with: arg2 [
	arg1 printOn: arg2.
	self recursionMethod: arg1 with: arg2
]

{ #category : 'examples' }
BPatternMethodExamples >> recursionMethodByRenamedTemp: arg1 with: arg2 [
	| tempA tempB |
	^tempA + tempB
]

{ #category : 'examples' }
BPatternMethodExamples >> recursionMethodWithTemps: arg1 with: arg2 [
	| tempA tempB |
	arg1 printOn: arg2.
	{arg2. arg2} printString.
	self recursionMethodWithTemps: arg1 with: arg2
]
