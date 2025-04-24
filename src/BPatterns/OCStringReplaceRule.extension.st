Extension { #name : 'OCStringReplaceRule' }

{ #category : '*BPatterns' }
OCStringReplaceRule >> replaceTree: anAST [
	replaceTree := anAST.
	searchTree isSequence = replaceTree isSequence
		ifFalse: [ searchTree isSequence
				ifTrue: [ replaceTree := OCSequenceNode statements: (Array with: replaceTree) ]
				ifFalse: [ searchTree := OCSequenceNode statements: (Array with: searchTree) ] ]
]
