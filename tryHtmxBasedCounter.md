# Counter on Teapot and htmx

This is a How-To guide to create a counter web application with AJAX using `STTemplate`, `Teapot` and `htmx`.

Everything is deliciously minimal and server side.

Use the following snippets in the presented sequence all in the same Workspace/Playground.

### SSR all the way

If you're new to [htmx](https://htmx.org/) watch [htmx in 100 seconds](https://www.youtube.com/watch?v=r-GSGH2RxJs).

### Setup

First configure a basic Teapot service to have the endpoints

```smalltalk
"Initialize the counter model"
counterState := 0.

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

"Add a ping route for healthcheck/dev-sanitycheck"
teapot GET: '/ping' -> 'pong'.
```

### Declare the templates

```smalltalk
"The one for a full page render"
sttCounterPage := STTemplate on: '<!DOCTYPE html>
<html>
  <head>
    <title>STTemplate Counter with htmx</title>
  </head>
  <body>
    <h1>Counter</h1>
    <h1 id="counterValue"><%= self%></h1>
    <button
      hx-post="/increase"
      hx-target="#counterValue"
      hx-swap="outerHTML">Increase</button>
    <button
      hx-post="/decrease"
      hx-target="#counterValue"
      hx-swap="outerHTML">Decrease</button>
  </body>
  <script
    src="https://unpkg.com/htmx.org@1.9.5"
    integrity="sha384-xcuj3WpfgjlKF+FXhSQFQ0ZNr39ln+hwjN3npfM9VBnUskLolQAcN80McRIVOPuO"
    crossorigin="anonymous"
  ></script>
</html>'.

"The one for just the part used to update on increase/decrease"
sttCounterView := '<h1 id="counterValue"><%= self%></h1>' asSTTemplate.
```

### Setup routes

```smalltalk
"Root"
teapot GET: '/' -> [ :req | sttCounterPage renderOn: counterState ].

"Increase action"
teapot POST: '/increase' -> [ :req |
	counterState := counterState + 1.
	sttCounterView renderOn: counterState ].

"Decrease action"
teapot POST: '/decrease' -> [ :req |
	counterState := counterState - 1.
	sttCounterView renderOn: counterState ].
```

Start the service and have fun.

### Operation

Control it with

```smalltalk
"Start the HTTP server."
teapot start.

"Stop the HTTP server."
teapot stop.
```