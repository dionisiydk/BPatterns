Extension { #name : 'Association' }

{ #category : '*BPatterns' }
Association >> bpattern: varSpecs [
	^(key bpattern: varSpecs) -> (value bpattern: varSpecs) 
]
