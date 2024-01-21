"
I help in the context when rendering `STTemplate`.
"
Class {
	#name : #STT,
	#superclass : #Object,
	#category : #'STTemplate-Core'
}

{ #category : #public }
STT class >> getTemplateFrom: aNamedPartialToYield in: partialsDictionaryish [

	| parts selector reminder missing |
	parts := aNamedPartialToYield substrings: '/'.
	missing := [ 
	           STTError signal:
		           ('Partial missing at: {1}' format:
			            { aNamedPartialToYield asString }) ].
	parts size > 1 ifTrue: [ 
		selector := parts first.
		reminder := '/' join: parts allButFirst.
		^ self
			  getTemplateFrom: reminder
			  in: (partialsDictionaryish at: selector ifAbsent: missing) ].

	^ partialsDictionaryish at: parts first ifAbsent: missing
]

{ #category : #public }
STT class >> yield: aNamedPartialToYield [

	| renderingContext |
	renderingContext := STTCurrentRenderingContext value.
	renderingContext ifNil: [ 
		STTError signal:
			('Template context unreacheable while trying to yield {1}' format:
				 { aNamedPartialToYield asString }) ].
	self yield: aNamedPartialToYield on: renderingContext templateContext
]

{ #category : #public }
STT class >> yield: aNamedPartialToYield on: aContext [

	| renderingContext template outStream result |
	renderingContext := STTCurrentRenderingContext value.
	template := self
		            getTemplateFrom: aNamedPartialToYield
		            in: renderingContext partials.
	outStream := STTCurrentRenderingStream value.
	result := template
		          renderOn: aContext
		          partials: renderingContext partials.
	outStream nextPutAll: result
]

{ #category : #public }
STT class >> yieldPartial: anSTTemplate on: aContext [

	| renderingContext outStream result |
	renderingContext := STTCurrentRenderingContext value.
	outStream := STTCurrentRenderingStream value.
	result := anSTTemplate renderOn: aContext.
	outStream nextPutAll: result
]
