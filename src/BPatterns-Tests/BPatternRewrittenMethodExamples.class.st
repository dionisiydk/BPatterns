Class {
	#name : 'BPatternRewrittenMethodExamples',
	#superclass : 'BPatternMethodExamples',
	#category : 'BPatterns-Tests',
	#package : 'BPatterns-Tests'
}

{ #category : 'examples' }
BPatternRewrittenMethodExamples >> isNilIfFalseWith: arg [
	^arg ifNotNil: [ arg printString ]
]

{ #category : 'as yet unclassified' }
BPatternRewrittenMethodExamples >> methodForInstVarToArgSwapInsideMessage: arg [

	self someMessage: arg
]

{ #category : 'as yet unclassified' }
BPatternRewrittenMethodExamples >> methodWithArgSwapInsideMessage: arg1 arg2: arg2 [
	self someMessage: arg2 arg2: arg1
]

{ #category : 'as yet unclassified' }
BPatternRewrittenMethodExamples >> methodWithInstVarToArgSwapInsideMessage: arg1 arg2: arg2 [

	self someMessage: arg1 arg2: arg2
]

{ #category : 'as yet unclassified' }
BPatternRewrittenMethodExamples >> methodWithManyStatements [
	| someTemp arg someTemp2 |
	instVar printString. 
	someTemp part2: 10 someMessage: arg. 
	someTemp2 printString
]

{ #category : 'as yet unclassified' }
BPatternRewrittenMethodExamples >> methodWithManyStatementsForInstVarToArgSwapInsideMessage: arg [
	self printString.
	self someMessage: arg.
	^self asArray
]

{ #category : 'examples' }
BPatternRewrittenMethodExamples >> methodWithPragmaKeywordSwap: arg [
	<part2: 123 somePragma: 'test'>
	<somePragma2: 'test2' part3: 567>
	^arg printString
]

{ #category : 'examples' }
BPatternRewrittenMethodExamples >> methodWithRenamedArg: renamedArg [
	^renamedArg printString
]

{ #category : 'examples' }
BPatternRewrittenMethodExamples >> methodWithRenamedPragma: arg [
	<renamedPragma: 'test' part2: 123>
	<somePragma2: 'test2' part3: 567>
	^arg printString
]

{ #category : 'examples' }
BPatternRewrittenMethodExamples >> recursionMethod: arg1 with: arg2 [
	[ arg1 printOn: arg2 ] repeat
]

{ #category : 'examples' }
BPatternRewrittenMethodExamples >> recursionMethodByRenamedTemp: arg1 with: arg2 [
	| tempC tempB |
	^tempC + tempB
]

{ #category : 'examples' }
BPatternRewrittenMethodExamples >> recursionMethodWithTemps: arg1 with: arg2 [
	| tempA tempB |
	[ arg1 printOn: arg2.
	{arg2. arg2} printString ] repeat
]
