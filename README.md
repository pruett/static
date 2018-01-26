<p align="center">
  <img alt="static site generator from warby parker" src="https://user-images.githubusercontent.com/794809/35441962-78246634-0273-11e8-8c23-30da2278fcc8.png" />
</p>

# static
`under development`

### Requirements

- Node.js >= v6
- `npm` or `yarn`

### Getting started

```bash
# pull down repo:
git clone <repo>

# install local dependencies:
npm install
# - or -
yarn
```

### Commands

```bash
# bootstrap project:
./static --page=<name>
## creates a folder in pages/<name> with a starter template

# run development server
./static --page=<name>
## runs a hot-reload development server listening to changes to project

# build static page
./static --page=<name>
## compiles and outputs assets to dist/<name> folder

# deploy static page
./static --page=<name>
## deploys dist/<name>
```
