Extension { #name : 'BPattern' }

{ #category : '*BPatterns-Calypso' }
BPattern >> asMethodQuery [

	^(BPatternMethodQuery withPattern: self from: ClyNavigationEnvironment currentImageScope)
]

{ #category : '*BPatterns-Calypso' }
BPattern >> asMethodQueryInClass: aClass [

	^self asMethodQueryInScope: (ClyBothMetaLevelClassScope of: aClass)
]

{ #category : '*BPatterns-Calypso' }
BPattern >> asMethodQueryInScope: aScope [

	^self asMethodQuery withScope: (aScope bindTo: ClyNavigationEnvironment currentImage)
]

{ #category : '*BPatterns-Calypso' }
BPattern >> browseUsers [

	^ClyQueryBrowserMorph openOn: self asMethodQuery
]

{ #category : '*BPatterns-Calypso' }
BPattern >> browseUsersInClass: aClass [

	^self browseUsersInScope: (ClyBothMetaLevelClassScope of: aClass)
]

{ #category : '*BPatterns-Calypso' }
BPattern >> browseUsersInScope: aScope [

	^ClyQueryBrowserMorph openOn: (self asMethodQueryInScope: aScope)
]

{ #category : '*BPatterns-Calypso' }
BPattern >> users [

	^self asMethodQuery execute rawItems
]

{ #category : '*BPatterns-Calypso' }
BPattern >> usersInClass: aClass [

	^(self asMethodQueryInClass: aClass) execute rawItems
]
