"
I'm a dummy model used in tests and benchmarks.
"
Class {
	#name : #STTDummyJobModel,
	#superclass : #Object,
	#instVars : [
		'jobs',
		'description',
		'thing',
		'jobId',
		'answer',
		'firstName',
		'effect',
		'waitingFor'
	],
	#category : #'STTemplate-Tests'
}

{ #category : #accessing }
STTDummyJobModel >> answer [

	^ answer
]

{ #category : #accessing }
STTDummyJobModel >> answer: aValue [

	answer := aValue
]

{ #category : #accessing }
STTDummyJobModel >> description [

	^ description
]

{ #category : #accessing }
STTDummyJobModel >> description: anObject [

	description := anObject
]

{ #category : #accessing }
STTDummyJobModel >> effect [

	^ effect
]

{ #category : #accessing }
STTDummyJobModel >> effect: aString [

	effect := aString
]

{ #category : #accessing }
STTDummyJobModel >> firstName [

	^ firstName
]

{ #category : #accessing }
STTDummyJobModel >> firstName: aString [

	firstName := aString
]

{ #category : #initialization }
STTDummyJobModel >> initialize [

	super initialize.
	jobs := OrderedCollection new
]

{ #category : #accessing }
STTDummyJobModel >> jobId [

	^ jobId
]

{ #category : #accessing }
STTDummyJobModel >> jobId: aString [

	jobId := aString
]

{ #category : #accessing }
STTDummyJobModel >> jobs [

	^ jobs
]

{ #category : #accessing }
STTDummyJobModel >> jobs: someJobs [

	jobs := someJobs
]

{ #category : #accessing }
STTDummyJobModel >> thing [

	^ thing
]

{ #category : #accessing }
STTDummyJobModel >> thing: aDictionary [

	thing := aDictionary
]

{ #category : #accessing }
STTDummyJobModel >> waitingFor [

	^ waitingFor
]

{ #category : #accessing }
STTDummyJobModel >> waitingFor: aString [

	waitingFor := aString
]
