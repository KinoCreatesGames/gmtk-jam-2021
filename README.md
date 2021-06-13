
<h1 align="center">Sprocket</h1>
---


*Based off Richard Bray's template [degit](https://github.com/Rich-Harris/degit).*

### 1. Download

You can also create a new project based on this template using degit which will ignore all git related files.
```sh
npx degit KinoCreatesGames/gmtk-jam-2021 sprocket
cd sprocket
```

### 2. Install dependencies

```sh
lix scope create
lix download
npm i 
```

### 3. Build
It's recommended to run the [Haxe compilation server](https://youtu.be/3crCJlVXy-8) when developing to cache the compilation, this should be done in a separate terminal window/tab with the following command.
```sh
npm run comp-server
```

Your **.hx** files are watched with [Facebook's watman plugin](https://facebook.github.io/watchman/). Anytime you save a file it will trigger an automatic rebuild. 
```sh
npm start 
```
