### Install Teapot
```smalltalk
Metacello new
  baseline: 'Teapot';
  repository: 'github://zeroflag/Teapot:v2.7.0/source';
  load.
```

### Configure the server
```smalltalk
"Configure Teapot defaults"
teapot := Teapot configure: {
		#port -> 9090.
		#debugMode -> true.
		#defaultOutput -> #html
	}.

"Add an exception handler to fail gracefully"
teapot	 exception: Error ->  [ :ex :req | | content |
	content := (Smalltalk isHeadless and: [ Smalltalk isInteractiveGraphic ])
		ifTrue: [ 'Ouch: {1}' format: { ex messageText } ]
		ifFalse: [ 'Internal error' ].
		TeaResponse serverError body: content.
	].
```
### Setup routes
```smalltalk
"Add a ping route"
teapot GET: '/ping' -> 'pong'.

"Create an SSTemplate"
sstEcho := STTemplate on: '<% [ | echo | echo := self allButFirst %><h1>Echoing:</h1><h2><%= self %></h2><h3><%= echo %></h3><p><%= echo %></p> <% ] value %>'.

"Add a echo route that will render the HTML the template based on the received message value."
teapot GET: '/echo/<message>' -> [ :req | sstEcho renderOn: (req at: #message) ].
```

### Operation
```smalltalk
"Start the HTTP server."
teapot start.

"Stop the HTTP server."
teapot stop.

```
