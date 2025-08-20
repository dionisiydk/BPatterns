Class {
	#name : 'BPatternConfigTest',
	#superclass : 'TestCase',
	#category : 'BPatterns-Tests',
	#package : 'BPatterns-Tests'
}

{ #category : 'tests' }
BPatternConfigTest >> testPrinting [
	
	| configs patternVar |
	configs := BPatternConfig readFromSpecs: [ patternVar ].
	
	self assert: configs first printString equals: 'a BPatternPluggableVarConfig(patternVar)'
]

{ #category : 'tests' }
BPatternConfigTest >> testReadingFromSpecsAsArrayOfBlockVars [
	
	| configs patternVar patternVar2 |
	configs := BPatternConfig readFromSpecs: { [ patternVar ] . [ patternVar2 ] }.
	
	self assert: configs size equals: 2.
	self assert: configs first class equals: BPatternPluggableVarConfig.
	self assert: configs first patternVars asArray equals: #('patternVar').
	self assert: configs first definitionBlock isNil.
	self assert: configs first class equals: BPatternPluggableVarConfig.
	self assert: configs second patternVars asArray equals: #('patternVar2').
	self assert: configs second definitionBlock isNil
]

{ #category : 'tests' }
BPatternConfigTest >> testReadingFromSpecsAsArrayWithBlockVarAssoc [
	
	| configBlock configs patternVar |
	configBlock := [ :pattern |  ].
	configs := BPatternConfig readFromSpecs: { [ patternVar ] -> configBlock }.
	
	self assert: configs size equals: 1.
	self assert: configs first class equals: BPatternPluggableVarConfig.
	self assert: configs first patternVars asArray equals: #('patternVar').
	self assert: configs first definitionBlock identicalTo: configBlock
]

{ #category : 'tests' }
BPatternConfigTest >> testReadingFromSpecsAsBlockWithMultipleVars [
	
	| configs patternVar patternVar2 |
	configs := BPatternConfig readFromSpecs: [ patternVar. patternVar2 ].
	
	self assert: configs size equals: 1.
	self assert: configs first class equals: BPatternPluggableVarConfig.
	self assert: configs first patternVars asArray equals: #('patternVar' 'patternVar2').

]

{ #category : 'tests' }
BPatternConfigTest >> testReadingFromSpecsAsKeywordSelectors [
	
	| configs |
	configs := BPatternConfig readFromSpecs: #(someMessage:part2: some2:part2:).
	
	self assert: configs size equals: 2.
	self assert: configs first class equals: BPatternPluggableSelectorConfig.
	self assert: configs first patternKeywords asArray equals: #(someMessage: part2:).
	self assert: configs first class equals: BPatternPluggableSelectorConfig.
	self assert: configs second patternKeywords asArray equals: #(some2: part2:).

]

{ #category : 'tests' }
BPatternConfigTest >> testReadingFromSpecsAsSelectors [
	
	| configs |
	configs := BPatternConfig readFromSpecs: #(selector1 selector2).
	
	self assert: configs size equals: 2.
	self assert: configs first class equals: BPatternPluggableSelectorConfig.
	self assert: configs first patternKeywords asArray equals: #(selector1).
	self assert: configs first class equals: BPatternPluggableSelectorConfig.
	self assert: configs second patternKeywords asArray equals: #(selector2).

]

{ #category : 'tests' }
BPatternConfigTest >> testReadingFromSpecsAsSingleAssocForBlockVar [
	
	| configBlock configs patternVar |
	configBlock := [ :pattern |  ].
	configs := BPatternConfig readFromSpecs: [ patternVar ] -> configBlock.
	
	self assert: configs size equals: 1.
	self assert: configs first class equals: BPatternPluggableVarConfig.
	self assert: configs first patternVars asArray equals: #('patternVar').
	self assert: configs first definitionBlock identicalTo: configBlock
]

{ #category : 'tests' }
BPatternConfigTest >> testReadingFromSpecsAsSingleAssocForSelector [
	
	| configs configBlock |
	configBlock := [ :pattern |  ].
	configs := BPatternConfig readFromSpecs: #selector1 -> configBlock.
	
	self assert: configs size equals: 1.
	self assert: configs first class equals: BPatternPluggableSelectorConfig.
	self assert: configs first patternKeywords asArray equals: #(selector1).
	self assert: configs first definitionBlock identicalTo: configBlock
]

{ #category : 'tests' }
BPatternConfigTest >> testReadingFromSpecsAsSingleAssocForSelectors [
	
	| configs configBlock |
	configBlock := [ :pattern |  ].
	configs := BPatternConfig readFromSpecs: #(selector1 selector2) -> configBlock.
	
	self assert: configs size equals: 1.
	self assert: configs first class equals: BPatternPluggableSelectorConfig.
	self assert: configs first patternKeywords asArray equals: #(selector1 selector2).
	self assert: configs first definitionBlock identicalTo: configBlock
]
