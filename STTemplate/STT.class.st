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

	^ self yield: aNamedPartialToYield on: nil
]

{ #category : #public }
STT class >> yield: aNamedPartialToYield on: aContext [
	self halt
]
