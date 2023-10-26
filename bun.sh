#!/bin/bash
mkdir src;
bun init -y;
echo -n "`head -n -1 package.json`" > package.json;
echo ',
  "imports": {
    "#src/*": "./build/*"
  }
}' >> package.json; 
echo '{
  "trailingComma": "es5",
  "tabWidth": 2,
  "semi": false,
  "singleQuote": true,
  "bracketSpacing": false,
  "arrowParens": "always",
  "endOfLine": "crlf"
}' > .prettierrc;
echo 'node_modules
build
coverage' > .gitignore;
git init;
