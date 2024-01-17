Extension { #name : #String }

{ #category : #'*STTemplate' }
String >> asSTTemplate [

	"Answers a new instance of `STTemplate` based on the receiver."

	^ STTemplate on: self
]

{ #category : #'*STTemplate' }
String >> sttRenderOn: anObject [

	"Answers the result of rendering an `STTemplate`
	 created from the receiver and rendered using the given object."

	^ self asSTTemplate renderOn: anObject
]

{ #category : #'*STTemplate' }
String >> sttRenderOn: anObject partial: partial [

	"Answers the result of rendering an `STTemplate`
	created from the receiver and rendered using 
	the given object as template context and the given 
	partial template to yield within."

	^ self asSTTemplate renderOn: anObject partial: partial
]

{ #category : #'*STTemplate' }
String >> sttRenderOn: anObject partials: partialsDictionarish [

	"Answers the result of rendering an `STTemplate`
	 created from the receiver and rendered using the given object."

	^ self asSTTemplate renderOn: anObject partials: partialsDictionarish
]
