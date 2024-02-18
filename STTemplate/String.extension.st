Extension { #name : #String }

{ #category : #'*STTemplate' }
String >> asSTTemplate [

	"Answers a new instance of `STTemplate` based on the receiver."

	^ STTemplate on: self
]

{ #category : #'*STTemplate' }
String >> asSingleQuoteEscaped [

	"Answer a copy of the receiver that has an extra 
	single quote for every one found in the origial."

	| current |
	^ self class streamContents: [ :out | 
		  self readStreamDo: [ :in | 
			  [ in atEnd ] whileFalse: [ 
				  current := in next.
				  current = $'
					  ifTrue: [ out nextPutAll: '''''' ]
					  ifFalse: [ out nextPut: current ] ] ] ]
]

{ #category : #'*STTemplate' }
String >> sttRenderOn: anObject [

	"Answers the result of rendering an `STTemplate`
	 created from the receiver and rendered using the given object."

	^ self asSTTemplate renderOn: anObject
]

{ #category : #'*STTemplate' }
String >> sttRenderOn: anObject partial: aSTTemplate [
	"Answers the result of rendering an `STTemplate`
	created from the receiver and rendered using 
	the given object as context for the template and the given 
	aSTTemplate to yield within."

	^ self asSTTemplate renderOn: anObject partial: aSTTemplate
]

{ #category : #'*STTemplate' }
String >> sttRenderOn: anObject partials: templatesDictionarish [

	"Answers the result of rendering an `STTemplate`
	 created from the receiver and rendered using the given object and (sub)templates."

	^ self asSTTemplate renderOn: anObject partials: templatesDictionarish
]
