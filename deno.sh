#!/bin/bash
mkdir src;
deno init --lib;
echo -n "`head -n -1 deno.json`" > deno.json;
echo ',
  "fmt": {
    "useTabs": false,
    "semiColons": false,
    "singleQuote": true,
    "trailingCommas": "onlyMultiLine",
    "useBraces": "always"
  }
}' >> deno.json;
echo 'node_modules
build
out
dist
coverage
.idea' > .gitignore;
git init;
