# `dap/node.lua`

Configuración de DAP para JavaScript/TypeScript. Se apoya en el adapter
[`js-debug`](https://github.com/microsoft/vscode-js-debug) (el que en VS Code se
llama *pwa-node* / *pwa-chrome*), instalado por mason.

La idea: un solo adapter (el mismo servidor DAP) sirve tanto para depurar Node
como para depurar el navegador, y se registran varias configuraciones para no
tener que escribirlas a mano.

Todos los ejemplos de abajo están **completos y expandidos**: se muestran todas
las propiedades de la configuración, sin helpers. En el código real
`node.lua` los defaults vienen de `debug_config(overrides)`, que hace
`vim.tbl_deep_extend("force", defaults, overrides)` — por eso ahí solo se ve la
parte que cambia.

---

## Por qué `mason/packages/.../dapDebugServer.js`

nvim-dap no lanza un binario: lanza un proceso que habla el protocolo DAP por
stdio. Para JS ese proceso es `dapDebugServer.js`, que viene dentro del paquete
de mason:

```
~/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js
```

Por eso el `executable.command` es `node` (el intérprete) y el path del script
va en `args`. El path se construye con `vim.fn.stdpath("data")` en vez de
hardcodear `~/.local/share/nvim` para que funcione con cualquier
`NVIM_DATA_DIR` / `XDG_DATA_HOME`.

## Estructura de un adapter

`dap.adapters[<nombre>]` acepta dos formas.

### 1. Tabla (adapter estático)

```lua
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = {
      vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
      "${port}",
    },
  },
}
```

| key | para qué sirve |
| --- | --- |
| `type = "server"` | le dice a nvim-dap que este adapter es un **servidor** DAP: nvim se conecta por TCP en vez de hablar por stdio. Es lo que habilita `port` y `host`. |
| `host` | host donde escucha el servidor. `localhost` porque corre en la misma máquina. |
| `port = "${port}"` | puerto variable. nvim-dap ve el `${...}` y **pregunta / genera** un puerto libre en cada sesión, en lugar de fijar uno (y evitar choques si hay dos debugsessions). |
| `executable.command` | programa a ejecutar: `node`. |
| `executable.args` | argumentos. El primero es el script del adapter; el segundo es el puerto que se le pasa al script, que es el que hace el binding del socket. |

Los `${...}` de `type/port/executable` los resuelve **nvim-dap**. Los de la
configuración (`${file}`, `${workspaceFolder}`, `${port}`) los resuelve **js-debug**
(son las mismas variables que usa VS Code).

### 2. Función (adapter dinámico)

```lua
dap.adapters["node"] = function(cb, config)
  if config.type == "node" then
    config.type = "pwa-node"
  end

  local adapter = require("dap").adapters["pwa-node"]
  if type(adapter) == "function" then
    adapter(cb, config)
  else
    cb(adapter)
  end
end
```

Se usa cuando el adapter depende del tipo de la config que se está lanzando.
`alias_adapter("node", "pwa-node")` hace dos cosas:

1. Si la config pide `type = "node"` (nombre viejo), la reescribe a `pwa-node`.
   Así configs viejas o snippets de otras configs siguen funcionando.
2. Resuelve el adapter destino. Si es tabla, `cb(adapter)`; si es función,
   la delega (por si el destino también es dinámico).

## Estructura de una configuración

| key | para qué sirve |
| --- | --- |
| `type` | adapter a usar: `pwa-node` para Node, `pwa-chrome` para navegador. |
| `request` | `"launch"` = arrancar el programa y attachar al proceso; `"attach"` = conectar a algo que ya corre. |
| `name` | lo que se ve en la lista de `:DapContinue` / los pickers de Neovim. |
| `program` | entrypoint a ejecutar. `${file}` = el buffer actual; una ruta como `.../vitest.mjs` = script fijo. |
| `args` | argumentos de `program`. Un valor puede ser `function()` que devuelve un string (se evalúa al elegir la config), para pedir input. |
| `url` | (solo navegador) URL a la que hacer attach. |
| `webRoot` | (solo navegador) raíz del código fuente en disco, para mapear los sources servidos. |
| `sourceMaps` | si el código que corre es transpilado (bundles, TS→JS), que el adapter mapee back a los sources originales. |
| `cwd` | directorio de trabajo del proceso debuggeado. `${workspaceFolder}` = raíz del proyecto. Importante con paquetes ESM, que lo usan para resolver. |
| `resolveSourceMapLocations` | en qué rutas buscar esos source maps. `${workspaceFolder}/**` = todo el proyecto, `!**/node_modules/**` = pero ignorando dependencias. Sin esto, los breakpoints se bindean a `node_modules` o fallan. |
| `runtimeExecutable` | binario a depurar (normalmente `node`). **En lugar de** `program`: js-debug lo lanza con `--inspect` y conecta ahí. |
| `runtimeArgs` | argumentos de `runtimeExecutable`. Es lo que permite depurar runners que son subcomandos de node (`node --test ...`) en vez de scripts ejecutables. Mutuamente excluyente con `program`/`args`. |

Config mínima, tal cual la escribe `node.lua` para "Launch file":

```lua
{
  type = "pwa-node",
  request = "launch",
  name = "Launch file",
  program = "${file}",
  sourceMaps = true,
  cwd = "${workspaceFolder}",
  resolveSourceMapLocations = {
    "${workspaceFolder}/**",
    "!**/node_modules/**",
  },
}
```

Esos cuatro últimos (`sourceMaps`, `cwd`, `resolveSourceMapLocations`) son los
defaults de `debug_config`, y `type = "pwa-node"` también (salvo en la config de
Chrome, que pisa `type = "pwa-chrome"`).

## Configs incluidas

| config | para qué |
| --- | --- |
| Launch file | Depura el archivo actual tal cual (`program = ${file}`). Para Node puro o TS ya compilado. |
| Launch using Chrome | `pwa-chrome`. Pide la URL (default `http://localhost:3000`) y attach a la pestaña. El `vim.cmd("redraw")` es para que el prompt se vea antes de que `input()` bloquee la pantalla. |
| Vitest: current test file | Corre vitest con `${file}` y `--no-file-parallelism` (necesario para que los breakpoints caigan en el worker correcto). |
| Vitest: current test by name | Igual, pero con `-t` y pide el nombre del test. |
| Vitest: all tests | Suite completa. |

Las mismas configs se asignan a `javascript`, `typescript`, `javascriptreact` y
`typescriptreact`, así que `dap.continue()` ofrece la lista completa sin importar
el filetype del buffer.

## Cómo lanzar el runner: `npm` vs `.bin` vs el binario directo

[Hay](2026-10-04_hay.md) tres formas de invocar un test runner, y elegir bien importa porque
`js-debug` se attacha a **un** proceso: el que sea el hijo directo.

### Opción A — el binario real dentro de `node_modules` (la que usa este archivo)

```lua
program = "${workspaceFolder}/node_modules/jest/bin/jest.js"
```

Un solo proceso: node + el script. El proceso que debuggeás **es** el runner, así
que los breakpoints bindean sin configuración extra.

- ✅ sin processes hijos: bindea siempre, sin `autoAttachChildProcesses`
- ✅ los args van directos, sin `--` de por medio ni quoting raro
- ✅ paths absolutos deterministas
- ❌ path interno del paquete (cambia entre majors: `bin/jest.js` vs `bin/jest`)
- ❌ rompe con layouts no-hoisted (pnpm sin `node-linker=hoisted`, Yarn PnP)
- ❌ hay que actualizarlo a mano al subir de versión del runner

### Opción B — el shim de `.bin`

```lua
program = "${workspaceFolder}/node_modules/.bin/jest"
```

`node_modules/.bin/jest` no es el runner: es un wrapper (un JS con shebang, o un
`.cmd` en Windows) que a su vez invoca el binario real.

- ✅ path estable y "oficial" (`jest`, `mocha`, `vitest`), sobrevive a cambios internos
- ✅ no depende del layout de `node_modules`… siempre que `.bin` exista
- ❌ **proceso hijo**: hay que attaching al hijo (`autoAttachChildProcesses`, y a
  veces `runtimeArgs` extra), si no los breakpoints no bindean
- ❌ un salto extra, y en Windows el shim es un `.cmd` que complica el quoting
- ❌ si el paquete declara su bin como script de shell en vez de JS, no corre con `node`

### Opción C — `npm` / `npx` como command

```lua
command = "npm",
args = { "test", "--", "--runInBand" },
```

- ✅ usa los scripts de `package.json`: `npm test` es lo que el equipo escribe y
  ejecuta en CI, con sus `pretest`, variables de entorno y flags
- ✅agnóstico: si el proyecto cambia de runner, la config no cambia
- ❌ **doble proceso**: `npm` es node, y el runner es su hijo. Necesita
  `autoAttachChildProcesses = true` (y en algún caso `autoAttachChildProcesses`
  con delay, porque npm hace `fork` + `spawn`)
- ❌ los args hay que pasarlos **después de `--`**, si no npm se los queda o rompe
- ❌ `npm test` a veces corre dos veces el pretest/posttest; el ruido en la consola DAP
- ❌ `npx` además descarga el paquete si no está instalado: red en medio de un debug

**Recomendación:** opción A para depurar (bindea siempre y ves exactamente lo que
pasa), opción C para reproducir el comando real del equipo cuando lo que
interesa es "lo que falla en CI".

Los ejemplos de abajo usan la A.

## Ejemplos: otros test runners

El patrón es siempre el mismo: `program` = el binario del runner dentro de
`node_modules` (no `node_modules/.bin/...`, que es un shim), `args` = el archivo
o filtro, y la flag que obliga al runner a ejecutarse en **un solo proceso**
(`--runInBand`, `--no-file-parallelism`, `--no-parallel`). Sin eso el breakpoint
se bindea a un worker que muere antes de que sea útil.

Para "todos los tests" el truco es el mismo en todos: **quitar el path de la
config** y dejar que cada runner aplique su propio default (`testMatch` de jest,
`spec` de mocha, `files` de web-test-runner...). Solo la flag de serialización se
mantiene.

### Jest

Archivo actual:

```lua
{
  type = "pwa-node",
  request = "launch",
  name = "Jest: current test file",
  program = "${workspaceFolder}/node_modules/jest/bin/jest.js",
  args = { "--runInBand", "--runTestsByPath", "${file}" },
  sourceMaps = true,
  cwd = "${workspaceFolder}",
  resolveSourceMapLocations = {
    "${workspaceFolder}/**",
    "!**/node_modules/**",
  },
}
```

Suite completa:

```lua
{
  type = "pwa-node",
  request = "launch",
  name = "Jest: all tests",
  program = "${workspaceFolder}/node_modules/jest/bin/jest.js",
  args = { "--runInBand" },
  sourceMaps = true,
  cwd = "${workspaceFolder}",
  resolveSourceMapLocations = {
    "${workspaceFolder}/**",
    "!**/node_modules/**",
  },
}
```

Un solo test por nombre: `args = { "--runInBand", "-t", function() ... end }`.
`--runInBand` (o `--maxWorkers=1`) desactiva los workers; `--runTestsByPath` evita
que el patrón del archivo se interprete como regex. Sin `--runTestsByPath`, jest
toma los paths como regex.

### Mocha

Archivo actual:

```lua
{
  type = "pwa-node",
  request = "launch",
  name = "Mocha: current test file",
  program = "${workspaceFolder}/node_modules/mocha/bin/mocha.js",
  args = { "--no-parallel", "${file}" },
  sourceMaps = true,
  cwd = "${workspaceFolder}",
  resolveSourceMapLocations = {
    "${workspaceFolder}/**",
    "!**/node_modules/**",
  },
}
```

Suite completa:

```lua
{
  type = "pwa-node",
  request = "launch",
  name = "Mocha: all tests",
  program = "${workspaceFolder}/node_modules/mocha/bin/mocha.js",
  args = { "--no-parallel" },
  sourceMaps = true,
  cwd = "${workspaceFolder}",
  resolveSourceMapLocations = {
    "${workspaceFolder}/**",
    "!**/node_modules/**",
  },
}
```

Un solo test: `args = { "--no-parallel", "--grep", function() ... end }`.
`--no-parallel` es para mocha >= 10; en versiones anteriores, no pasar
`--parallel` ya lo ejecuta en serie. Ojo: mocha usa `--spec` para filtrar por
path, pero pasar el archivo directo también funciona.

### Web Test Runner (`@web/test-runner`)

Archivo actual:

```lua
{
  type = "pwa-node",
  request = "launch",
  name = "Web Test Runner: current test file",
  program = "${workspaceFolder}/node_modules/@web/test-runner/dist/bin.js",
  args = { "--config", "${workspaceFolder}/web-test-runner.config.mjs", "${file}" },
  sourceMaps = true,
  cwd = "${workspaceFolder}",
  resolveSourceMapLocations = {
    "${workspaceFolder}/**",
    "!**/node_modules/**",
  },
}
```

Suite completa:

```lua
{
  type = "pwa-node",
  request = "launch",
  name = "Web Test Runner: all tests",
  program = "${workspaceFolder}/node_modules/@web/test-runner/dist/bin.js",
  args = { "--config", "${workspaceFolder}/web-test-runner.config.mjs" },
  sourceMaps = true,
  cwd = "${workspaceFolder}",
  resolveSourceMapLocations = {
    "${workspaceFolder}/**",
    "!**/node_modules/**",
  },
}
```

Levanta el servidor de test-runner bajo Node (los tests corren en Chromium vía
puppeteer). Los breakpoints en el código del test-runner funcionan; en el del
test hay que usar `pwa-chrome` sobre la URL que imprime. Equivalente a
`node_modules/.bin/web-test-runner`, pero saltando el shim. Sin path, usa el
`files` del config.

### Tape

Archivo actual:

```lua
{
  type = "pwa-node",
  request = "launch",
  name = "Tape: current test file",
  program = "${workspaceFolder}/node_modules/tape/bin/tape",
  args = { "${file}" },
  sourceMaps = true,
  cwd = "${workspaceFolder}",
  resolveSourceMapLocations = {
    "${workspaceFolder}/**",
    "!**/node_modules/**",
  },
}
```

Suite completa:

```lua
{
  type = "pwa-node",
  request = "launch",
  name = "Tape: all tests",
  program = "${workspaceFolder}/node_modules/tape/bin/tape",
  args = { "test/**/*.js" },
  sourceMaps = true,
  cwd = "${workspaceFolder}",
  resolveSourceMapLocations = {
    "${workspaceFolder}/**",
    "!**/node_modules/**",
  },
}
```

No necesita flag de serialización: tape ya corre todo en el mismo proceso. Aquí
el path sí es obligatorio: tape sin args **lee de stdin** y se queda esperando.
Tape hace glob de los args, por eso el `test/**/*.js` funciona sin que lo
expanda la shell (nvim pasa los args tal cual, sin shell).

### Chai

Chai no es un test runner, son **aserciones** (`expect`). No hay nada que
configurar en DAP: los tests se lanzan con el runner que usen.

Con mocha o jest, la config de arriba sirve tal cual; lo único es el import en el
propio test:

```js
const { expect } = require("chai");

describe("sum", () => {
  it("adds", () => {
    expect(1 + 1).to.equal(2);
  });
});
```

Donde chai sí necesita config propia es con el runner **built-in de node**
(`node:test`), porque ahí no hay binario que lanzar: se depura `node` con
`runtimeArgs`.

Archivo actual:

```lua
{
  type = "pwa-node",
  request = "launch",
  name = "Node --test: current test file",
  runtimeExecutable = "node",
  runtimeArgs = { "--test", "${file}", "--test-reporter=spec" },
  sourceMaps = true,
  cwd = "${workspaceFolder}",
  resolveSourceMapLocations = {
    "${workspaceFolder}/**",
    "!**/node_modules/**",
  },
}
```

Suite completa:

```lua
{
  type = "pwa-node",
  request = "launch",
  name = "Node --test: all tests",
  runtimeExecutable = "node",
  runtimeArgs = { "--test" },
  sourceMaps = true,
  cwd = "${workspaceFolder}",
  resolveSourceMapLocations = {
    "${workspaceFolder}/**",
    "!**/node_modules/**",
  },
}
```

Notas:

- `node --test` sin paths hace descubrimiento recursivo desde `cwd` a partir de
  Node 22; en versiones anteriores hay que pasar los paths (o el glob, si la
  versión lo soporta): `runtimeArgs = { "--test", "test/**/*.js" }`.
- Ojo con `--test-reporter=spec`: es necesario porque el runner por defecto
  (`tap`) usa concurrencia y los breakpoints no se bindean bien.
- Ojo también: los tests de node corren en **hilos** (`node:test` usa
  `node::worker` por archivo). Si los breakpoints no bindean, añadir
  `autoAttachChildProcesses = true` y ponerlos en el test, no en el runner.

Un script suelto que use chai sin runner (un `main.js` con asserts) es
justamente la config "Launch file" (`program = "${file}"`).

## Referencias

- [nvim-dap adapters](https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt#L141-adapter)
- [js-debug wiki (opciones de launch)](https://github.com/microsoft/vscode-js-debug/blob/main/OPTIONS.md)
