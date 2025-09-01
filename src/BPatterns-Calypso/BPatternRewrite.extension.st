Extension { #name : 'BPatternRewrite' }

{ #category : '*BPatterns-Calypso' }
BPatternRewrite >> changeForMethod: aMethod [
	| rewrittenAST rbClass |
	rewrittenAST := self rewriteMethod: aMethod.
	rbClass := RBClass existingNamed: aMethod methodClass name model: RBNamespace new.
	^rbClass compileTree: rewrittenAST
]

{ #category : '*BPatterns-Calypso' }
BPatternRewrite >> changeForMethods: methods [
	| changes |
	changes := OrderedCollection new.
	methods do: [:each | changes add: (self changeForMethod: each) ].
	^RBCompositeRefactoryChange new 
		changes: changes; 
		yourself
]
