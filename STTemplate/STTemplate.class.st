"
I'm the Smalltalk template class.

I can run Smalltalk code found between the opening (`<st`) and closing (`>`) tags when present in my content.

There are two ways to have Smalltalk running from my instances:
### 1. Displayed
Analogous to a `printIt`
```
'<p><st= ''Hello '', self ></p>' sttRenderOn: 'STT'.
""'<p>Hello STT</p>'""
```.
### 2. Evaluated
Analogous to a `doIt`
```
'<p>Hello STT<st 40+2 ></p>' sttRenderOn: 'STT'.
""'<p>Hello STT</p>'""

'<p>Hello STT<st self crShow: ''Greetings from a STT closure!'' ></p>' sttRenderOn: Transcript.
""'<p>Hello STT</p>'""
""And in the Transcript you'll see:""
'Greetings from a STT closure!'
````

### More examples:

```
""Displays the 42 as content of the span element:""
'<p>The Answer: <span><st= 42></span></p>' sttRenderOn: nil.
""'<p>The Answer: <span>42</span></p>'""
```

```
""Displays the 42 as content of the span element because 
adds 2 to the context sent with `sttRenderOn: 40`""
'<p>The Answer: <span><st= self + 2></span></p>' sttRenderOn: 40. 
""'<p>The Answer: <span>42</span></p>'""
```

```
""Displays `Answer:` and 42 after transforming them:""
'<p>The <span><st= self key capitalized, '': ''></span><span><st= self value + 2></span></p>' sttRenderOn: (#answer -> 40).
""'<p>The <span>Answer: </span><span>42</span></p>'""
```

```
""Creates a closure that does not display but iterates an interval from 1 to 3.
In each iteration, it has another Smalltalk closure that has access 
to self as expected and uses that to display its content:""
'<st 1 to: 3 do: [ :i | ><p>The Answer is <span><st= self value + 2>!</span></p><st ] >' sttRenderOn: (#answer -> 40).
""'<p>The Answer is <span>42!</span></p><p>The Answer is <span>42!</span></p><p>The Answer is <span>42!</span></p>'""
```

"
Class {
	#name : #STTemplate,
	#superclass : #Object,
	#instVars : [
		'source',
		'compiledMethod'
	],
	#classInstVars : [
		'options',
		'exceptionalTerminationSymbols'
	],
	#category : #'STTemplate-Core'
}

{ #category : #actions }
STTemplate class >> beLegacy [

	"Compatible with:
	https://wiki.squeak.org/squeak/2604"

	^ options := Dictionary new
		             at: #openingTag put: '{%';
		             at: #closingTag put: '%}';
		             at: #displayToken put: '=';
		             yourself
]

{ #category : #actions }
STTemplate class >> beLegacy2 [

	"Compatible with:
	https://live.exept.de/stt/default.stt"

	^ options := Dictionary new
		             at: #openingTag put: '<?stt';
		             at: #closingTag put: '?>';
		             at: #displayToken put: '=';
		             yourself
]

{ #category : #actions }
STTemplate class >> beLikeERB [

	"Follows roughly the same tag convention that Ruby on Rails uses in .erb template files"

	^ options := Dictionary new
		             at: #openingTag put: '<%';
		             at: #closingTag put: '%>';
		             at: #displayToken put: '=';
		             yourself
]

{ #category : #actions }
STTemplate class >> beSST [

	"We adopt this clean convention:
	
	context := 42.
	'<p>Answer: </p><span><st= self ></span>' sttRenderOn: context ->  '<p>Answer: </p><span>42</span>'

	'<ul>
		<st 1 to: self do: [ :i |> 
			<li><st= i ></li> 
		<st ] >
	</ul>' sttRenderOn: 3 ->

	'<ul>
		<li>1</li>
		<li>2</li>
		<li>3</li>
	</ul>'	
	"

	^ options := Dictionary new
		             at: #openingTag put: '<st';
		             at: #closingTag put: '>';
		             at: #displayToken put: '=';
		             yourself
]

{ #category : #accessing }
STTemplate class >> exceptionalTerminationSymbols [

	^ exceptionalTerminationSymbols ifNil: [ 
		  self initializeExceptionalTerminationSymbols ]
]

{ #category : #initialization }
STTemplate class >> initializeExceptionalTerminationSymbols [

	^ exceptionalTerminationSymbols := #( $| $[ $( ${ $. ) collect:
		                                   #asString
]

{ #category : #initialization }
STTemplate class >> initializeOptions [

	self beSST.
	^ options
]

{ #category : #'instance creation' }
STTemplate class >> on: aString [

	^ self new initializeOn: aString
]

{ #category : #accessing }
STTemplate class >> options [

	^ options ifNil: [ self initializeOptions ]
]

{ #category : #accessing }
STTemplate class >> options: anObject [

	options := anObject
]

{ #category : #actions }
STTemplate class >> reset [

	options := nil.
	exceptionalTerminationSymbols := nil
]

{ #category : #actions }
STTemplate >> addLineTerminationFor: smalltalkExpression on: rendered [

	"Adds a dot and a line termination character if the given 
	Smalltalk expression does not end with one of the exceptional symbols."

	(smalltalkExpression endsWithAnyOf:
		 self class exceptionalTerminationSymbols) ifFalse: [ 
		rendered
			nextPut: $.;
			cr ]
]

{ #category : #converting }
STTemplate >> asSmalltalkCode [

	"Returns the Smalltalk source code corresponding to the receiver."

	| rendered src openingTag closingTag displayToken |
	openingTag := self class options at: #openingTag.
	closingTag := self class options at: #closingTag.
	displayToken := self class options at: #displayToken.

	rendered := self newOutStream.
	src := source readStream.
	
	"Process every block writing the output 
	in the rendered stream until all the source gets read."
	[ src atEnd ] whileFalse: [ 
		self
			renderOutputFor: src
			on: rendered
			openingTag: openingTag
			closingTag: closingTag
			displayToken: displayToken ].

	^ rendered
		  cr;
		  nextPutAll: '^ out contents';
		  cr;
		  contents
]

{ #category : #actions }
STTemplate >> basicCompile [

	^ Smalltalk compiler
		  source: self asSmalltalkCode;
		  context: nil;
		  failBlock: [ ^ nil ];
		  noPattern: true;
		  options: #( + optionParseErrors - optionSkipSemanticWarnings );
		  compile
]

{ #category : #actions }
STTemplate >> compile [

	"Answers the compiled method resulting for this template.
	Catches syntax error notifications to signal STTemplateCompilationError 
	so applications can define how to handle."

	^ [ self basicCompile ]
		  on: SyntaxErrorNotification
		  do: [ :x | STTemplateCompilationError signal: x messageText ]
]

{ #category : #accessing }
STTemplate >> compiledMethod [

	^ compiledMethod ifNil: [ self initializeCompiledMethod ]
]

{ #category : #testing }
STTemplate >> hasDisplayToken: token at: anInteger [

	"Answers true if the source of the receiver
	contains a display token starting at the given position, anInteger."

	| extracted |
	extracted := source readStream
		             position: anInteger - 1;
		             next: token size.
	^ extracted = token
]

{ #category : #initialization }
STTemplate >> initializeCompiledMethod [

	^ compiledMethod := self compile
]

{ #category : #initialization }
STTemplate >> initializeOn: aString [

	source := aString
]

{ #category : #testing }
STTemplate >> isToBeDisplayed: sourceStream displayToken: displayToken [

	"Answers true if the source has the display token 
	immediately ahead of the current position in the sourceStream."

	^ ((sourceStream contents
		    copyFrom: sourceStream position
		    to: sourceStream position + displayToken size + 1)
		   indexOfSubCollection: displayToken
		   startingAt: 1) > 0
]

{ #category : #actions }
STTemplate >> newOutStream [

	^ String new writeStream
		  nextPutAll: '| out result |';
		  cr;
		  nextPutAll: 'out := String new writeStream.';
		  cr
]

{ #category : #actions }
STTemplate >> nextSmalltalkExpressionIn: src using: closingTag [

	^ src upToAll: closingTag
]

{ #category : #actions }
STTemplate >> renderOn: anObject [

	^ self compiledMethod valueWithReceiver: anObject arguments: #(  )
]

{ #category : #actions }
STTemplate >> renderOutputFor: src on: rendered openingTag: openingTag closingTag: closingTag displayToken: displayToken [

	| prelude smalltalkExpression |
	prelude := (src upToAll: openingTag) trimmed.
	prelude ifNotEmpty: [ 
		"Adds any unrelated content previous to any block."
		rendered
			nextPutAll: 'out nextPutAll: ';
			nextPut: $';
			nextPutAll: prelude;
			nextPut: $'.
		self addLineTerminationFor: '' on: rendered.
		rendered cr ].
	src atEnd ifFalse: [ 
		(self isToBeDisplayed: src displayToken: displayToken)
			ifTrue: [ 
				"Consume the display token."
				src upToAll: displayToken.
				"And get the Smalltalk expression."
				smalltalkExpression := self
					                       nextSmalltalkExpressionIn: src
					                       using: closingTag.
				rendered
					cr;
					nextPutAll: 'result := [ ';
					nextPutAll: smalltalkExpression;
					nextPutAll: ' ] value'.
				"Keep the result of evaluating the expression in result."
				self addLineTerminationFor: smalltalkExpression on: rendered.

				"Add its string representation to the out stream."
				rendered
					nextPutAll: 'out nextPutAll: result asString.';
					cr ]
			ifFalse: [ 
				smalltalkExpression := self
					                       nextSmalltalkExpressionIn: src
					                       using: closingTag.
				rendered nextPutAll: smalltalkExpression.
				"Ensure a line delimiter for it."
				self addLineTerminationFor: smalltalkExpression on: rendered ] ]
]

{ #category : #actions }
STTemplate >> reset [

	compiledMethod := nil
]
