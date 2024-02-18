"
I help in the context when rendering `STTemplate`.
"
Class {
	#name : #STT,
	#superclass : #Object,
	#category : #'STTemplate-Core'
}

{ #category : #public }
STT class >> getTemplateFrom: aNamedPartialToYield in: templatesDictionaryish [

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
			  in: (templatesDictionaryish at: selector ifAbsent: missing) ].

	^ templatesDictionaryish at: parts first ifAbsent: missing
]

{ #category : #public }
STT class >> yield: aNamedPartialToYield [

	| renderingContext |
	self deprecated: ' use yield:using:'.
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
	self deprecated: ' use yield:using:'.	
	renderingContext := STTCurrentRenderingContext value.
	template := self
		            getTemplateFrom: aNamedPartialToYield
		            in: renderingContext templates.
	outStream := STTCurrentRenderingStream value.
	result := template
		          renderOn: aContext
		          partials: renderingContext templates.
	outStream nextPutAll: result
]

{ #category : #public }
STT class >> yield: aContext template: anSTTemplate on: writeStream [

	writeStream nextPutAll: (anSTTemplate renderOn: aContext)
]

{ #category : #public }
STT class >> yield: aContext using: aNamedTemplateToYield [

	| renderingContext template |
	renderingContext := STTCurrentRenderingContext value.
	template := self
		            getTemplateFrom: aNamedTemplateToYield
		            in: renderingContext templates.

	self
		yield: aContext
		template: template
		on: STTCurrentRenderingStream value
]

{ #category : #public }
STT class >> yieldPartial: anSTTemplate on: aContext [

	| renderingContext outStream result |
	self deprecated: ' use yield:using:'.	
	renderingContext := STTCurrentRenderingContext value.
	outStream := STTCurrentRenderingStream value.
	result := anSTTemplate renderOn: aContext.
	outStream nextPutAll: result
]

{ #category : #public }
STT class >> yieldUsing: aNamedPartialToYield [

	| renderingContext |
	renderingContext := STTCurrentRenderingContext value.
	renderingContext ifNil: [ 
		STTError signal:
			('Template context unreacheable while trying to yield {1}' format:
				 { aNamedPartialToYield asString }) ].
	self
		yield: renderingContext templateContext
		using: aNamedPartialToYield
]
