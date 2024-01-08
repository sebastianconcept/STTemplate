"
I'm the BaselineOf for STTemplate
"
Class {
	#name : #BaselineOfSTTemplate,
	#superclass : #BaselineOf,
	#category : #BaselineOfSTTemplate
}

{ #category : #actions }
BaselineOfSTTemplate >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		self setUpDependencies: spec.
		self setUpPackages: spec.
		spec
			group: 'Core' with: #( 'STTemplate' );
			group: 'Tests' with: #( 'STTemplate-Tests' );
			group: 'default' with: #( 'Core' ) ]
]

{ #category : #actions }
BaselineOfSTTemplate >> setUpDependencies: spec [


]

{ #category : #actions }
BaselineOfSTTemplate >> setUpPackages: spec [

	spec
		package: 'STTemplate'
		with: [ "No dependencies." spec requires: #(  ) ].

	spec
		package: 'STTemplate-Tests'
		with: [ spec requires: #( 'STTemplate' ) ]
]
