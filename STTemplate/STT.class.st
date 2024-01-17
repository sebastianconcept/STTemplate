"
I help in the context when rendering STTemplate
"
Class {
	#name : #STT,
	#superclass : #Object,
	#category : #'STTemplate-Core'
}

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

	| renderingContext partial outStream result |
	renderingContext := STTCurrentRenderingContext value.
	partial := renderingContext partials
		           at: aNamedPartialToYield
		           ifAbsent: [ 
			           STTError signal:
				           ('{1} partial is missing' format:
					            { aNamedPartialToYield asString }) ].
	outStream := STTCurrentRenderingStream value.
	result := partial renderOn: aContext partials: renderingContext partials.
	outStream nextPutAll: result
]
