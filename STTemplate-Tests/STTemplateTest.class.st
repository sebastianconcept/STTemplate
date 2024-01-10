Class {
	#name : #STTemplateTest,
	#superclass : #TestCase,
	#category : #'STTemplate-Tests'
}

{ #category : #accessing }
STTemplateTest class >> jobsTableTemplate [

	"An sst template with a table to display jobs."

	^ '<table>
  <thead>
    <tr>
      <th>Job ID</th>
      <th>First Name</th>
      <th>Effect</th>
      <th>Waiting for</th>
    </tr>
  </thead>
  <tbody>
    <st [ |tableContext|
      tableContext := 42 >
      <st self jobs do: [ :job | >
      <tr
        hx-on:click="showJob("<st= job jobId >")"
      >
        <th>
          <st 4+7 >
          <st= job jobId >
        </th>
        <td><st= job firstName ></td>
        <td><st= tableContext asString,''-'', job effect ></td>
        <td><st= job waitingFor ></td>
      </tr>
      <st ] >
    <st ] value >
  </tbody>
</table>
'
]

{ #category : #accessing }
STTemplateTest class >> jobsTableTemplateModel [

	| templateModel |
	templateModel := STTDummyJobModel new.

	1 to: 10 do: [ :i | 
		| job |
		job := STTDummyJobModel new
			       jobId: ('{1}-id' format: { i asString });
			       answer: 42;
			       firstName: ('{1}-firstName' format: { i asString });
			       effect: ('{1}-effect' format: { i asString });
			       waitingFor: ('{1}-waitingFor' format:
						        { (DateAndTime fromString: '2023-01-07')
							        asLocalStringYMDHM });
			       yourself.
		job thing: { (#value -> (job answer * 2)) } asDictionary.
		templateModel jobs add: job ].
	^ templateModel
]

{ #category : #accessing }
STTemplateTest class >> renderedJobsTableTemplate [

	"The rendering expected for jobsTableTemplate using jobsTemplateModel"

	^ '<table>
  <thead>
    <tr>
      <th>Job ID</th>
      <th>First Name</th>
      <th>Effect</th>
      <th>Waiting for</th>
    </tr>
  </thead>
  <tbody><tr
        hx-on:click="showJob("1-id")"
      >
        <th>1-id</th>
        <td>1-firstName</td>
        <td>42-1-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr><tr
        hx-on:click="showJob("2-id")"
      >
        <th>2-id</th>
        <td>2-firstName</td>
        <td>42-2-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr><tr
        hx-on:click="showJob("3-id")"
      >
        <th>3-id</th>
        <td>3-firstName</td>
        <td>42-3-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr><tr
        hx-on:click="showJob("4-id")"
      >
        <th>4-id</th>
        <td>4-firstName</td>
        <td>42-4-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr><tr
        hx-on:click="showJob("5-id")"
      >
        <th>5-id</th>
        <td>5-firstName</td>
        <td>42-5-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr><tr
        hx-on:click="showJob("6-id")"
      >
        <th>6-id</th>
        <td>6-firstName</td>
        <td>42-6-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr><tr
        hx-on:click="showJob("7-id")"
      >
        <th>7-id</th>
        <td>7-firstName</td>
        <td>42-7-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr><tr
        hx-on:click="showJob("8-id")"
      >
        <th>8-id</th>
        <td>8-firstName</td>
        <td>42-8-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr><tr
        hx-on:click="showJob("9-id")"
      >
        <th>9-id</th>
        <td>9-firstName</td>
        <td>42-9-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr><tr
        hx-on:click="showJob("10-id")"
      >
        <th>10-id</th>
        <td>10-firstName</td>
        <td>42-10-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr></tbody>
</table>'
]

{ #category : #running }
STTemplateTest >> tearDown [

	super tearDown.
	STTemplate reset
]

{ #category : #tests }
STTemplateTest >> testClosureWithChildDisplayingValueUsingCustomTags [

	| stt rendered |
	STTemplate options at: #openingTag put: '<s'.
	STTemplate options at: #closingTag put: '>'.
	STTemplate options at: #displayToken put: '='.
	stt := '<s= >' asSTTemplate.
	self deny: (stt hasDisplayToken: 'whatever' at: 3).
	self assert: (stt hasDisplayToken: '=' at: 3).

	rendered := '<s [ | answer is | 
					answer := 40 ><s=
					is := self. 
					answer + is >
				<s ] value >' sttRenderOn: 2.
	self assert: rendered equals: '42'
]

{ #category : #tests }
STTemplateTest >> testDetectsCustomClosingTag [

	| stt |
	STTemplate options at: #closingTag put: '/!?itEndsHere}}'.
	stt := '<st  ><span>42</span>' asSTTemplate.
	self should: [ stt renderOn: nil ] raise: STTemplateCompilationError.
	stt := '<st  /!?itEndsHere}}<span>41</span>' asSTTemplate.
	self assert: (stt renderOn: nil) equals: '<span>41</span>'.

	STTemplate options at: #closingTag put: '%>'.
	stt := '<st  %><span>42</span>' asSTTemplate.
	self assert: (stt renderOn: nil) equals: '<span>42</span>'.

	STTemplate options at: #closingTag put: '?>'.
	stt := '<span><st= 42 ?></span>' asSTTemplate.
	self assert: (stt renderOn: nil) equals: '<span>42</span>'.

	STTemplate options at: #closingTag put: '-->'.
	stt := '<span><st= self --></span>' asSTTemplate.
	self assert: (stt renderOn: 42) equals: '<span>42</span>'
]

{ #category : #tests }
STTemplateTest >> testDetectsCustomDisplayToken [

	| stt |
	STTemplate options at: #displayToken put: 'printsThis'.
	stt := '{%printsThis  %}' asSTTemplate.
	self deny: (stt hasDisplayToken: '=' at: 3).
	self assert: (stt hasDisplayToken: 'printsThis' at: 3).

	STTemplate reset.

	stt := '{%=  %}' asSTTemplate.
	self assert: (stt hasDisplayToken: '=' at: 3).

	stt := '{%  %}' asSTTemplate.
	self deny: (stt hasDisplayToken: '=' at: 3)
]

{ #category : #tests }
STTemplateTest >> testDetectsCustomTags [

	| stt |
	STTemplate options at: #openingTag put: '<s'.
	STTemplate options at: #closingTag put: '>'.
	STTemplate options at: #displayToken put: '='.
	stt := '<s= >' asSTTemplate.
	self deny: (stt hasDisplayToken: 'whatever' at: 3).
	self assert: (stt hasDisplayToken: '=' at: 3).

	stt := '<s= self >' asSTTemplate.

	self assert: (stt renderOn: 42) equals: '42'
]

{ #category : #tests }
STTemplateTest >> testDetectsDisplayToken [

	| stt |
	stt := '<st=  >' asSTTemplate.
	self assert: (stt hasDisplayToken: '=' at: 4).

	STTemplate beLegacy.
	stt := '{%=  %}' asSTTemplate.

	self assert: (stt hasDisplayToken: '=' at: 3)
]

{ #category : #tests }
STTemplateTest >> testDetectsMissingClosingTag [

	| stt |
	stt := '<tbody>
    <st self jobs do: [ :job |' asSTTemplate.

	"Not exactly detecting that but failing correctly."
	self should: [ stt renderOn: nil ] raise: STTemplateCompilationError
]

{ #category : #tests }
STTemplateTest >> testDisplayValueFromCustomAttribute [

	| stt context |
	stt := '<div data-custom="questionEverything(<st= self at: #answer>)">Ask</div>'
		       asSTTemplate.

	context := Dictionary new
		           at: #answer put: 42;
		           yourself.
	self
		assert: (stt renderOn: context)
		equals: '<div data-custom="questionEverything(42)">Ask</div>'
]

{ #category : #tests }
STTemplateTest >> testEmpty [

	self assert: ('' sttRenderOn: nil) equals: ''
]

{ #category : #tests }
STTemplateTest >> testEnclosingCode [

	self
		assert: ('<st= 42 ><p>Hello</p>' sttRenderOn: nil)
		equals: '42<p>Hello</p>'
]

{ #category : #tests }
STTemplateTest >> testEnclosingNoCode [

	self
		assert: ('<p>Hello</p><st >' sttRenderOn: nil)
		equals: '<p>Hello</p>'.

	self
		assert: ('<p>Hello</p><span><st= ></span>' sttRenderOn: nil)
		equals: '<p>Hello</p><span>nil</span>'
]

{ #category : #tests }
STTemplateTest >> testEnclosingNoCodeAfterElement [

	| stt |
	stt := '<p>Hello</p><st >' asSTTemplate.
	self shouldnt: [ stt asSmalltalkCode ] raise: STTError.
	self assert: (stt renderOn: nil) equals: '<p>Hello</p>'
]

{ #category : #tests }
STTemplateTest >> testEnclosingNoCodeBeforeElement [

	| rendered |
	rendered := '<st ><p>Hello</p>' sttRenderOn: nil.
	self assert: rendered  equals: '<p>Hello</p>'
]

{ #category : #tests }
STTemplateTest >> testEnclosingNoCodeEnclosingElement [

	self
		should: [ '<st <p>Hello</p> >' asSTTemplate renderOn: nil ]
		raise: STTemplateCompilationError
]

{ #category : #tests }
STTemplateTest >> testJobsTable [

	self
		assert: (self class jobsTableTemplate sttRenderOn:
				 self class jobsTableTemplateModel)
		equals: self class renderedJobsTableTemplate
]

{ #category : #tests }
STTemplateTest >> testNestedClosure [

	| stt shouldRender |
	stt := STTemplate on: '
		<st [ | answer | 
			answer := self.
		>
			<ul>
				<li><st= ''What is the answer'' ></li> 
				<li>to the question? <st= answer asString ></li> 
				<st [ answer := answer + 1>
					<li>and the answer +1? That would be: <st= answer asString ></li>
				<st ] value >
			</ul>
		<st ] value >'.

	shouldRender := '<ul>
				<li>What is the answer</li> 
				<li>to the question?42</li><li>and the answer +1? That would be:43</li></ul>'.
	self assert: (stt renderOn: 42) equals: shouldRender
]

{ #category : #tests }
STTemplateTest >> testNestedDisplayValueFromCustomAttribute [

	| stt context shouldRender source |
	source := '<ul>
			<st self do: [ :dic | >
				<li>
					<div data-custom="questionEverything(<st= dic at: #answer >)">
					<span>Ask, </span><span><st= dic at: #what ></span></div>
				</li>
			<st ] >
		</ul>' trimmed copyWithoutAll: { 
			          Character cr.
			          Character lf.
			          Character tab }.
	stt := STTemplate on: source.

	context := OrderedCollection new
		           add: (Dictionary new
				            at: #answer put: 42;
				            at: #what put: 'what?';
				            yourself);
		           add: (Dictionary new
				            at: #answer put: '42' printString;
				            at: #what put: 'but what is the question?';
				            yourself);
		           yourself.
	shouldRender := '<ul><li><div data-custom="questionEverything(42)"><span>Ask, </span><span>what?</span></div></li><li><div data-custom="questionEverything(''42'')"><span>Ask, </span><span>but what is the question?</span></div></li></ul>'.
	self assert: (stt renderOn: context) equals: shouldRender
]

{ #category : #tests }
STTemplateTest >> testValueFromTempVar [

	| source |
	source := '<p>Hello</p><span>
		<st= |answer| 
			answer := 42. 
			answer >
		</span>'.

	self
		assert: (source sttRenderOn: nil)
		equals: '<p>Hello</p><span>42</span>'
]

{ #category : #tests }
STTemplateTest >> testWithoutCode [

	self assert: ('<p>Hello</p>' sttRenderOn: nil) equals: '<p>Hello</p>'
]
