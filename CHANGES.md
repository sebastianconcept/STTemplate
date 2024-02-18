Feb 17, 2024
===================================
- Using by default the same convention seen in Ruby on Rails for opening and closing tags `<% 40+2 %>` and `<%= 40+2 %>` .

Jan 25, 2024
===================================
- STT has new deprecated methods in favor of methods that are friendlier to Ride-based applications.
- `STT yield: aNamedPartialToYield` is now `STT yieldUsing: aNamedPartialToYield`.
- `STT yield: aNamedPartialToYield on: aContext` is now `STT yield: aContext using: aNamedPartialToYield`.

Jan 23, 2024
===================================
- Added smalltalkCI
- Added Codecov
- Added which Pharo versions are supported (currently only Pharo10)
  
Jan 21, 2024
===================================
- Adjusted the compilation so the templates can access instVars of the context directly as if they where a method of that object (which dinamically they are).
- This works `<div><st= firstName, ' ', answer asString></div>`
- `testCanAccessInstVarsOfTheContext` and `testCanAccessInstVarsOfTheContextFromAPartial` are coverage.

Jan 21, 2024
===================================
- Adjusted `STT yield:on:` to allow rendering cases like this one `<st= STT yield: 'shared/alerts.html' on: self alerts>` where `shared/alerts.html` has alerts deeper in the partials sent in the rendering context.

Jan 8, 2024
===================================
- Added `README.md` and how-to guides: one to test it with `Teapot` and another one using it to make an `htmx` based Counter app.
