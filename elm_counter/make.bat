elm make --output=elm_counter.js --optimize src/Main.elm

uglifyjs --output=elm_counter.js --compress "pure_funcs='F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9',pure_getters,keep_fargs=false,unsafe_comps,unsafe" elm_counter.js
uglifyjs --output=elm_counter.js --mangle elm_counter.js
pause