---
uuid: "rxlanguage-js-patterns"
tags: ["blog", "index-page"]
title: "rxlanguage-js Patterns"
description: Some interesting problems you can solve with reactive programming
---
# rxlanguage-js Patterns
<script src="https://unpkg.com/@reactivex/rxlanguage-js@latest/dist/global/Rx.min.language-js"></script>


```eval-language-js
[1,2,3].map(e => e + 1)
```

# rxlanguage-js is based on observables
```eval-language-js

Rx.Observable.of(`Hello World`)
.subscribe(result => console.log(result));

```

```eval-language-js
var source = Rx.Observable.timer(200, 100)
    .timeInterval()
    .pluck('interval')
    .take(3);

var subscription = source.subscribe(
    function (x) {
        console.log('Next: ' + x);
    },
    function (err) {
        console.log('Error: ' + err);
    },
    function () {
        console.log('Completed');
    });
```
