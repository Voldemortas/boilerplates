#!/bin/bash
npm create vite@latest . -- --template react-ts;
npm install -D vitest;
echo '{
  "trailingComma": "es5",
  "tabWidth": 2,
  "semi": false,
  "singleQuote": true,
  "bracketSpacing": false,
  "arrowParens": "always",
  "endOfLine": "crlf"
}' > .prettierrc;
