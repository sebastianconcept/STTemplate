Extension { #name : #String }

{ #category : #'*STTemplate' }
String >> asSTTemplate [

	"Answers a new instance of STTemplate based on the receiver."

	^ STTemplate on: self
]

{ #category : #'*STTemplate' }
String >> sttRenderOn: anObject [

	"Answers the result of rendering an STTemplate
	 created from the receiver and rendered using the given object."

	^ self asSTTemplate renderOn: anObject
]
