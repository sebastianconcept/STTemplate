"
I provide access to the partials and template context that helps to render an STTemplate.

When rendering an STTemplate that incorporates partials, an STTRenderingContext provides the access to both the template context and the required partials. This is eventually needed by an STTemplate for a complete rendering.

"
Class {
	#name : #STTRenderingContext,
	#superclass : #Object,
	#instVars : [
		'templateContext',
		'partials'
	],
	#category : #'STTemplate-Core'
}

{ #category : #'instance creation' }
STTRenderingContext class >> on: aTemplateContext partials: partialsDictionarish [

	^ self new
		  initializeOn: aTemplateContext
		  partials: partialsDictionarish
]

{ #category : #initialization }
STTRenderingContext >> initializeOn: aTemplateContext partials: partialsDictionarish [

	templateContext := aTemplateContext.
	partials := partialsDictionarish
]

{ #category : #accessing }
STTRenderingContext >> partials [

	^ partials
]

{ #category : #accessing }
STTRenderingContext >> templateContext [

	^ templateContext
]
