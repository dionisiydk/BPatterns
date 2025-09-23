Extension { #name : 'OCParseTreeSearcher' }

{ #category : '*BPatterns' }
OCParseTreeSearcher >> recusivelySearchInContextExcept: aNode [
	"We need to save the matched context since the other searches might overwrite it."

	| oldContext |
	oldContext := context.
	context := SmallDictionary new.
	oldContext keysAndValuesDo: [:key :value |
		(value ~~ aNode and: [key isString not and: [key recurseInto]])
			ifTrue:
				[oldContext at: key put: (value collect: [:each | self visitNode: each])]].
	context := oldContext
]
