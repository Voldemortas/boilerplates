#!/bin/bash
bun init --yes .;
bun add https://github.com/Voldemortas/voldemortas-server/releases/download/latest/latest.tgz;
mkdir src;
mkdir src/front;
mkdir src/build;
mkdir src/static;
mkdir src/back;

echo "const metaDir = import.meta.dir ?? ''
//TODO find a way to organise this better
export const rootDir = metaDir + (metaDir.includes('/out') ? '/../' : '/../../')
export const outDir = rootDir + 'out'
export const tempDir = rootDir + 'temp'
export const srcDir = rootDir + 'src'
export const entryPoint = srcDir + '/build/server.ts'
export const staticDir = 'static'
export const frontDir = srcDir + '/front/'
export const defaultHtml = srcDir + '/build/default.html'
export const developmentHtml = srcDir + '/build/development.html'
" > src/build/config.ts;

echo "import {Route, BackRoute} from 'voldemortas-server/route'
const routes: Route[] = [new BackRoute('/', 'Hello world!')]

export default routes
" > src/pages.ts;

echo "import routes from 'src/pages'
import Server from 'voldemortas-server'
import {defaultHtml, developmentHtml, outDir} from 'build/config.ts'

const server = new Server({
  routes: routes,
  staticPaths: [/^\/static\//, /^\/front\//],
  defaultHtml,
  developmentHtml,
  outDir,
}).getServer()
console.log('Listening on ' + server.url)" > src/build/server.ts;

echo "import { wrap } from 'voldemortas-server'
import {
  defaultHtml,
  developmentHtml,
  entryPoint,
  frontDir,
  outDir,
  rootDir,
  srcDir,
  staticDir,
  tempDir,
} from 'build/config.ts'
import routes from 'src/pages.ts'

await wrap({
  rootDir,
  outDir,
  srcDir,
  entryPoint,
  staticDir,
  frontDir,
  tempDir,
  defaultHtml,
  developmentHtml,
  routes,
})
" > src/index.ts;

echo '<!doctype html>
<html>
  <head>
    <title>placeholder</title>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="/global.css" />
    <link rel="stylesheet" href="/placeholderPath.css" />
    <script>
      const hash = undefined
      const globalParams = undefined
    </script>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/placeholderPath.js"></script>
    <script id="dev"></script>
  </body>
</html>
' > src/build/default.html;

echo "<script>
  let socket = new WebSocket('ws://' + window.location.host)
  let interval
  manageSocket()

  function manageSocket() {
    socket.addEventListener('open', (e) => {
      clearInterval(interval)
    })
    socket.addEventListener('message', ({data}) => {
      if (data !== hash) {
        window.location.reload()
      }
    })
    socket.addEventListener('close', () => {
      interval = setInterval(() => {
        if (socket.readyState === WebSocket.CLOSED) {
          socket = new WebSocket('ws://' + window.location.host)
          manageSocket()
        }
      }, 200)
    })
  }
</script>
" > src/build/development.html;

echo 'static serving works' > src/static/test.txt;

echo '{
  "trailingComma": "es5",
  "tabWidth": 2,
  "semi": false,
  "singleQuote": true,
  "bracketSpacing": false,
  "arrowParens": "always",
  "endOfLine": "crlf"
}' > .prettierrc;

echo '# Custom project 
Read docs at https://github.com/Voldemortas/voldemortas-server' > README.md;
echo '{
  "compilerOptions": {
    "paths": {
      "back/*": ["./src/back/*"],
      "build/*": ["./src/build/*"],
      "front/*": ["./temp/*", "./src/front/*"],
      "src/*": ["./src/*"],
      "test/*": ["./test/*"]
    },
    // Enable latest features
    "lib": ["ESNext", "DOM"],
    "target": "ESNext",
    "module": "ESNext",
    "moduleDetection": "force",
    "jsx": "react-jsx",
    "allowJs": true,
    // Bundler mode
    "moduleResolution": "bundler",
    "allowImportingTsExtensions": true,
    "verbatimModuleSyntax": true,
    "noEmit": true,
    // Best practices
    "strict": true,
    "skipLibCheck": true,
    "noFallthroughCasesInSwitch": true,
    // Some stricter flags (disabled by default)
    "noUnusedLocals": false,
    "noUnusedParameters": false,
    "noPropertyAccessFromIndexSignature": false,
    "esModuleInterop": true,
    "typeRoots": ["./node_modules/@types", "./typings"]
  }
}
' > tsconfig.json;

sed -i 's#"module": "index.ts",#"module": "src/index.ts",\n  "scripts": {\n    "build-prod": "bun run src/index.ts --build --prod",\n    "build": "bun run src/index.ts --build",\n    "watch": "bun run src/index.ts --watch",\n    "serve": "bun run out/server.js --serve",\n    "serve-prod": "bun run out/server.js --serve --prod"\n  },#g' package.json