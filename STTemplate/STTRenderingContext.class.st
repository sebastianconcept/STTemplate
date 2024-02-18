"
I provide access to the partials and template context that helps to render an `STTemplate`.

When rendering an `STTemplate` that incorporates partials, an `STTRenderingContext` provides the access to both the template context and the required partials. This is eventually needed by an `STTemplate` for a complete rendering.

"
Class {
	#name : #STTRenderingContext,
	#superclass : #Object,
	#instVars : [
		'templateContext',
		'templates'
	],
	#category : #'STTemplate-Core'
}

{ #category : #'instance creation' }
STTRenderingContext class >> on: aTemplateContext templates: templatesDictionarish [

	^ self new
		  initializeOn: aTemplateContext
		  templates: templatesDictionarish
]

{ #category : #initialization }
STTRenderingContext >> initializeOn: aTemplateContext templates: templatesDictionarish [

	templateContext := aTemplateContext.
	templates := templatesDictionarish
]

{ #category : #accessing }
STTRenderingContext >> templateContext [

	^ templateContext
]

{ #category : #accessing }
STTRenderingContext >> templates [

	^ templates
]
