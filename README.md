# STTemplate

Smalltalk template library

[![Release](https://img.shields.io/github/v/tag/sebastianconcept/STTemplate?label=release)](https://github.com/sebastianconcept/STTemplate/releases)
![Tests](https://img.shields.io/badge/tests-18-green)
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE.txt)

## Features

- Content agnostic.
- Can create nested closures.
- Evaluate the expression or
- Display last object of your expression as String.
- Compiles content lazily only once.
- Opening and closing tags and display token can be customized.
___
1. [Description](#description)
2. [Examples](#examples)
3. [Install](#install)
4. [Guides](#guides)
5. [Backstory](#backstory)

## Install

```smalltalk
"In Pharo 10"

"By default it installs 'Core'"
Metacello new
  baseline: 'STTemplate';
  repository: 'github://sebastianconcept/STTemplate:v0.0.1';
  load.

"Optionally use `load: #('Core' 'Tests')`" 
```

Or as dependency in your `Baseline`

```smalltalk
spec baseline: 'STTemplate' with: [ spec repository: 'github://sebastianconcept/STTemplate:v0.0.1' ]
```

## Description

`STTemplate` is a Smalltalk template class.

It can run Smalltalk code found between the opening (`<st`) and closing (`>`) tags when present in the content.

There are two ways to have Smalltalk running from `STTemplate` instances:

### 1. Displayed

Analogous to a `printIt`

```smalltalk
'<p><st= ''Hello '', self ></p>' sttRenderOn: 'STT'.
"'<p>Hello STT</p>'"
```

### 2. Evaluated

Analogous to a `doIt`

```smalltalk
'<p>Hello STT<st 40+2 ></p>' sttRenderOn: 'STT'.
"'<p>Hello STT</p>'"

'<p>Hello STT<st self crShow: ''Greetings from an STT closure!'' ></p>' sttRenderOn: Transcript.
"'<p>Hello STT</p>'"

"And in the Transcript you'll see:"

'Greetings from an STT closure!'
```

### Examples

```smalltalk
"Displays the 42 as content of the span element:"

'<p>The Answer: <span><st= 42></span></p>' sttRenderOn: nil.
"'<p>The Answer: <span>42</span></p>'"
```

```smalltalk
"Displays the 42 as content of the span element because
adds 2 to the context sent with `sttRenderOn: 40`"

'<p>The Answer: <span><st= self + 2></span></p>' sttRenderOn: 40.
"'<p>The Answer: <span>42</span></p>'"
```

```smalltalk
"Displays `Answer:` and 42 after transforming them:"

'<p>The <span><st= self key capitalized, '': ''></span><span><st= self value + 2></span></p>' sttRenderOn: (#answer -> 40).
"'<p>The <span>Answer: </span><span>42</span></p>'"
```

```smalltalk
"Creates a closure that does not display but iterates an interval from 1 to 3.
In each iteration, it creates another Smalltalk closure that has access
to self as expected and uses that to display its content:"

'<st 1 to: 3 do: [ :i | ><p>The Answer is <span><st= self value + 2>!</span></p><st ] >' sttRenderOn: (#answer -> 40).
"'<p>The Answer is <span>42!</span></p><p>The Answer is <span>42!</span></p><p>The Answer is <span>42!</span></p>'"
```

## Guides

[Try SSTemplate on Teapot](tryOnTeapot.md). The most basic example to use an `STTemplate` to render the response of an API's endpoint.

[Try an SSTemplate based counter using Teapot and htmx](tryHtmxBasedCounter.md)

## Unit Tests

See all the tests in `STTemplateTest`.


## Backstory

While searching for a templating system in Smalltalk I've sumbled upon Norbert Hartl's [Mustache](https://github.com/noha/mustache) implementation. I've adopted it in [Ride](https://github.com/sebastianconcept/ride) `v0.0.15` and it worked remarkably well. As per january 2024, I have it production in one case here: [PhotograFX](https://photografx.pro).

While Mustache templates do their job, there are two issues with them:
1. The controllers having them as views, might become a bit busy in preparing the model for the Mustache templates and
2. Mustache templates sometimes obscured issues in their visitor mechanism, making seemingly simple problems harder to pinpoint.

This motivated me to explore a design based on efficient templates tailored for Smalltalk, akin to what `.erb` templates do for [Ruby on Rails](https://rubyonrails.org/).

Despite my extensive experience with  [Seaside](https://seaside.st/), I wanted to delve into the concept of a Smalltalk web app driven by templates. The primary motivation was to maintain easy the adoption of already made HTML and a stateless software design, anticipating linear memory scaling and maximizing operations per second per image.

Searching further resulted in finding [Smalltalk/X - STT - Smalltalk Templates](https://live.exept.de/stt/default.stt) and a bit later this one from 2002 for Squeak [Squeak STT - Smalltalk Templates](https://wiki.squeak.org/squeak/2604). After loading it and doing some adapting it revealed not to cover needed cases but inspired creating this library here. Thank you Federico Gregorio Stilman and Diego Gomez Deck for that inspiting proof of concept.


