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
  <tbody>
    
      
      <tr
        hx-on:click="showJob("1-id")"
      >
        <th>
          
          1-id
        </th>
        <td>1-firstName</td>
        <td>42-1-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr>
      
      <tr
        hx-on:click="showJob("2-id")"
      >
        <th>
          
          2-id
        </th>
        <td>2-firstName</td>
        <td>42-2-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr>
      
      <tr
        hx-on:click="showJob("3-id")"
      >
        <th>
          
          3-id
        </th>
        <td>3-firstName</td>
        <td>42-3-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr>
      
      <tr
        hx-on:click="showJob("4-id")"
      >
        <th>
          
          4-id
        </th>
        <td>4-firstName</td>
        <td>42-4-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr>
      
      <tr
        hx-on:click="showJob("5-id")"
      >
        <th>
          
          5-id
        </th>
        <td>5-firstName</td>
        <td>42-5-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr>
      
      <tr
        hx-on:click="showJob("6-id")"
      >
        <th>
          
          6-id
        </th>
        <td>6-firstName</td>
        <td>42-6-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr>
      
      <tr
        hx-on:click="showJob("7-id")"
      >
        <th>
          
          7-id
        </th>
        <td>7-firstName</td>
        <td>42-7-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr>
      
      <tr
        hx-on:click="showJob("8-id")"
      >
        <th>
          
          8-id
        </th>
        <td>8-firstName</td>
        <td>42-8-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr>
      
      <tr
        hx-on:click="showJob("9-id")"
      >
        <th>
          
          9-id
        </th>
        <td>9-firstName</td>
        <td>42-9-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr>
      
      <tr
        hx-on:click="showJob("10-id")"
      >
        <th>
          
          10-id
        </th>
        <td>10-firstName</td>
        <td>42-10-effect</td>
        <td>2023-01-07 00:00-waitingFor</td>
      </tr>
      
    
  </tbody>
</table>
'
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
	self assert: rendered equals: '42
				'
]

{ #category : #tests }
STTemplateTest >> testComposedWithNamedPartials [

	| rendered partials |
	partials := Dictionary new
		            at: #namedYield put: '<p>This content</p>' asSTTemplate;
		            yourself.

	rendered := '<h1>Contents</h1><div><st= STT yield: #namedYield ></div>'
		            sttRenderOn: 42
		            partials: partials.

	self
		assert: rendered
		equals: '<h1>Contents</h1><div><p>This content</p></div>'
]

{ #category : #tests }
STTemplateTest >> testComposedWithNamedPartialsWithContext [

	| rendered partials |
	partials := Dictionary new
		            at: #namedYield put: '<p>This content is <st= self></p>' asSTTemplate;
		            yourself.

	rendered := '<h1>Contents</h1><div><st= STT yield: #namedYield ></div>'
		            sttRenderOn: 42
		            partials: partials.

	self
		assert: rendered
		equals: '<h1>Contents</h1><div><p>This content is 42</p></div>'
]

{ #category : #tests }
STTemplateTest >> testComposedWithPartial [

	| rendered partial |
	partial := '<p>The answer is <st= 40+2></p>' asSTTemplate.

	rendered := '<h1>Contents</h1><div><st= STT yield ></div>'
		            sttRenderOn: nil
		            partial: partial.

	self
		assert: rendered
		equals: '<h1>Contents</h1><div><p>The answer is 42</p></div>'
]

{ #category : #tests }
STTemplateTest >> testComposedWithPartialsWithCustomizedContext [

	| rendered partials |
	partials := Dictionary new
		            at: #namedYield
		            put: '<p>This content is <st= self ></p>' asSTTemplate;
		            yourself.

	rendered := '<h1>Contents</h1><div><st= STT yield: #namedYield on: #(#programmatic #dynamic) atRandom ></div>'
		            sttRenderOn: nil
		            partials: partials.

	self assert: (rendered
		 = '<h1>Contents</h1><div><p>This content is programmatic</p></div>' 
			 or: [ 
				 rendered
				 = '<h1>Contents</h1><div><p>This content is dynamic</p></div>' ])
]

{ #category : #tests }
STTemplateTest >> testComposedWithUnnamedPartial [

	| rendered partial |
	partial := '<p>This content</p>' asSTTemplate.

	self should: [
	rendered := '<h1>Contents</h1><div><st= STT yield ></div>'
		            sttRenderOn: 42
		            partial: partial] raise: Error.

	"self
		assert: rendered
		equals: '<h1>Contents</h1><div><p>This content</p></div>'"
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
		equals: '<p>Hello</p><span></span>'
]

{ #category : #tests }
STTemplateTest >> testEnclosingNoCodeAfterElement [

	| stt |
	stt := '<p>Hello</p><st >' asSTTemplate.
	self shouldnt: [ stt asSmalltalkSource ] raise: STTError.
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

	shouldRender := '
		
			<ul>
				<li>What is the answer</li> 
				<li>to the question? 42</li> 
				
					<li>and the answer +1? That would be: 43</li>
				
			</ul>
		'.
	self assert: (stt renderOn: 42) equals: shouldRender
]

{ #category : #tests }
STTemplateTest >> testNestedClosureSource [

	| stt shouldRender |
	stt := STTemplate on: '
		<st [ | answer | 
			answer := self>
			<ul>
				<li><st= ''What is the answer'' ></li> 
				<li>to the question? <st= answer asString ></li> 
				<st [ answer := answer + 1>
					<li>and the answer +1? That would be: <st= answer asString ></li>
				<st ] value>
			</ul>
		<st ] value>'.

	shouldRender := '| out result |
out := String new writeStream.
STTCurrentRenderingStream value: out during: [

out nextPutAll: ''
		''.
 [ | answer | 
			answer := self.
out nextPutAll: ''
			<ul>
				<li>''.
result := [  ''What is the answer''  ] value.
out nextPutAll: result asString.
out nextPutAll: ''</li> 
				<li>to the question? ''.
result := [  answer asString  ] value.
out nextPutAll: result asString.
out nextPutAll: ''</li> 
				''.
 [ answer := answer + 1.
out nextPutAll: ''
					<li>and the answer +1? That would be: ''.
result := [  answer asString  ] value.
out nextPutAll: result asString.
out nextPutAll: ''</li>
				''.
 ] value.
out nextPutAll: ''
			</ul>
		''.
 ] value.
^ out contents ]'.
	self assert: stt asSmalltalkSource equals: shouldRender
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
STTemplateTest >> testRenderComposedRenderedWithoutContext [

	| templateContext job1 job2 partials template result |
	templateContext := STTDummyJobModel new.
	job1 := STTDummyJobModel new
		        jobId: 1;
		        description: 'Job 1';
		        yourself.
	job2 := STTDummyJobModel new
		        jobId: 2;
		        description: 'Job 2';
		        yourself.
	templateContext jobs: { 
			job1.
			job2 }.
	partials := Dictionary new
		            at: #showJob put: '
<div>
	<h1>Partial content for #showJob</h1>
	<div><st STT yield: #jobDetails on: self></div>
</div>
' asSTTemplate;
		            at: #jobDetails
		            put:
			            '<p>Job ID: <span><st= self jobId></span></p><p>Job description: <span><st= self description></span></p>'
				            asSTTemplate;
		            yourself.
	template := '
<ul>
	<st self jobs do: [ :job | >
		<li>
			<st= STT yield: #showJob on: job>
		</li>
	<st ]>
</ul>
' asSTTemplate.

	result := '
<ul>
	
		<li>
			
<div>
	<h1>Partial content for #showJob</h1>
	<div><p>Job ID: <span>1</span></p><p>Job description: <span>Job 1</span></p></div>
</div>

		</li>
	
		<li>
			
<div>
	<h1>Partial content for #showJob</h1>
	<div><p>Job ID: <span>2</span></p><p>Job description: <span>Job 2</span></p></div>
</div>

		</li>
	
</ul>
'.

	self
		assert: (template renderOn: templateContext partials: partials)
		equals: result
]

{ #category : #tests }
STTemplateTest >> testRenderComposedSnippetWithNamedYield [

	| template partials |
	template := '<st= STT yield: #showJob >' asSTTemplate.
	partials := { (#showJob -> '<st= 42 >' asSTTemplate) } asDictionary.

	self
		assert: (template asSmalltalkSnippetWithPartials: partials)
		equals: ' STT yield: #showJob .'
]

{ #category : #tests }
STTemplateTest >> testRenderComposedSnippetWithoutContext [

	| model job1 job2 partials template result rendered |
	model := STTDummyJobModel new.
	job1 := STTDummyJobModel new
		        description: 'Job 1';
		        yourself.
	job2 := STTDummyJobModel new
		        description: 'Job 2';
		        yourself.
	model jobs: { 
			job1.
			job2 }.
	partials := Dictionary new
		            at: #showJob put: '
<div>
	<h1>Partial content for #showJob</h1>
	<p><st STT yield: #jobDetails ></p>
</div>
' asSTTemplate;
		            at: #jobDetails
		            put: '<span>Partial for #jobDetails</span>' asSTTemplate;
		            yourself.
	template := '
<ul>
	<st self jobs do: [ :job | >
		<li>
			<st= STT yield: #showJob >
		</li>
	<st ] >
</ul>
' asSTTemplate.

template.

]

{ #category : #tests }
STTemplateTest >> testRenderDoublyComposedSnippetWithNamedYield [

	| template partials |
	template := '<main><st= STT yield: #showJob ></main>' asSTTemplate.
	partials := { 
		            (#showJob
		             ->
		             '<section><st= STT yield: #jobDetails ></section>'
			             asSTTemplate).
		            (#jobDetails
		             ->
		             '<div><st= ''This is the #jobDetails content'' ></div>'
			             asSTTemplate) } asDictionary.

	self
		assert: (template asSmalltalkSnippetWithPartials: partials)
		equals: 'out nextPutAll: ''<main>''.
 STT yield: #showJob .
out nextPutAll: ''</main>''.'
]

{ #category : #tests }
STTemplateTest >> testRenderFourLevelsComposition [

	| template partials templateContext |
	templateContext := STTDummyJobModel new
		                   jobId: 42;
		                   description: 'job 1';
		                   thing: 'something visual';
		                   yourself.
	template := '<main><st= STT yield: #levelOne ></main>' asSTTemplate.
	partials := { 
		            (#levelOne -> '<section>
			<p><st= ''This is the #levelOne content (I include #levelTwo).'' ></p>
			<div><st= STT yield: #levelTwo on: self></div>
						</section>' asSTTemplate).
		            (#levelTwo -> '<div>
			<p><st= ''This is the #levelTwo content (I include #levelThree).'' ></p>
			<div><st= STT yield: #levelThree on: self></div>
			</div>' asSTTemplate).
		            (#levelThree -> '<div>
			<p><st= ''This is the #levelThree content (I include #levelFour).'' ></p>
			<div><st= STT yield: #levelFour on: self></div>
			</div>' asSTTemplate).
		            (#levelFour
		             ->
		             '<p><st= ''This is the #levelFour content.'' ></p>
						<p><st= self thing></p>'
			             asSTTemplate) } asDictionary.

	self
		assert: (template renderOn: templateContext partials: partials)
		equals: '<main><section>
			<p>This is the #levelOne content (I include #levelTwo).</p>
			<div><div>
			<p>This is the #levelTwo content (I include #levelThree).</p>
			<div><div>
			<p>This is the #levelThree content (I include #levelFour).</p>
			<div><p>This is the #levelFour content.</p>
						<p>something visual</p></div>
			</div></div>
			</div></div>
						</section></main>'
]

{ #category : #tests }
STTemplateTest >> testRenderSimpleNamedYieldSnippetWithoutDisplayToken [

	| template partials |
	template := '<st STT yield: #showJob >' asSTTemplate.
	partials := { (#showJob -> '<st= 42 >' asSTTemplate) } asDictionary.

	self
		assert: (template asSmalltalkSnippetWithPartials: partials)
		equals: ' STT yield: #showJob .'
]

{ #category : #tests }
STTemplateTest >> testRenderTriplyComposedSnippetWithNamedYield [

	| template partials |
	template := '<main><st= STT yield: #showJob ></main>' asSTTemplate.
	partials := { 
		            (#showJob
		             ->
		             '<section><st= STT yield: #jobInfo ></section>'
			             asSTTemplate).
		            (#jobInfo
		             ->
			             '<div><p><st= ''This is the #jobInfo content.'' ></p></div><st= STT yield: #jobDetails ></div></div>'
				             asSTTemplate).
		            (#jobDetails
		             ->
		             '<div><st= ''This is the #jobDetails content'' ></div>'
			             asSTTemplate) } asDictionary.

	self
		assert: (template asSmalltalkSnippetWithPartials: partials)
		equals: 'out nextPutAll: ''<main>''.
 STT yield: #showJob .
out nextPutAll: ''</main>''.'
]

{ #category : #tests }
STTemplateTest >> testRenderTriplyComposedWithNamedYield [

	| template partials templateContext |
	templateContext := STTDummyJobModel new
		                   jobId: 42;
		                   description: 'job 1';
		                   yourself.
	template := '<main><st= STT yield: #showJob ></main>' asSTTemplate.
	partials := { 
		            (#showJob
		             ->
		             '<section><st= STT yield: #jobInfo ></section>'
			             asSTTemplate).
		            (#jobInfo
		             ->
			             '<div><p><st= ''This is the #jobInfo content.'' ></p></div><st= STT yield: #jobDetails ></div></div>'
				             asSTTemplate).
		            (#jobDetails
		             ->
			             '<div><st= ''Job Details: jobId is {1} and its description is {2}'' format: { self jobId asString. self description } ></div>'
				             asSTTemplate) } asDictionary.

	self
		assert: (template renderOn: templateContext partials: partials)
		equals:
		'<main><section><div><p>This is the #jobInfo content.</p></div><div>Job Details: jobId is 42 and its description is job 1</div></div></div></section></main>'
]

{ #category : #tests }
STTemplateTest >> testSourceForEnclosingNoCodeBeforeElement [

	| template |
	template := '<st 6+5 ><p>Hello</p>' asSTTemplate.
	self assert: template asSmalltalkSource equals: '| out result |
out := String new writeStream.
STTCurrentRenderingStream value: out during: [

 6+5 .
out nextPutAll: ''<p>Hello</p>''.
^ out contents ]'
]

{ #category : #tests }
STTemplateTest >> testSourceForValueFromTempVar [

	| source |
	source := '<p>Hello</p><span>
		<st= |answer| 
			answer := 42. 
			answer >
		</span>'.

	self
		assert: source asSTTemplate asSmalltalkSource
		equals: '| out result |
out := String new writeStream.
STTCurrentRenderingStream value: out during: [

out nextPutAll: ''<p>Hello</p><span>
		''.
result := [  |answer| 
			answer := 42. 
			answer  ] value.
out nextPutAll: result asString.
out nextPutAll: ''
		</span>''.
^ out contents ]'
]

{ #category : #tests }
STTemplateTest >> testValueFromTempVar [

	| source |
	source := '<p>Hello</p><span>
		<st= |answer| 
			answer := 42. 
			answer >
		</span>'.

	self assert: (source sttRenderOn: nil) equals: '<p>Hello</p><span>
		42
		</span>'
]

{ #category : #tests }
STTemplateTest >> testWithoutCode [

	self assert: ('<p>Hello</p>' sttRenderOn: nil) equals: '<p>Hello</p>'
]
