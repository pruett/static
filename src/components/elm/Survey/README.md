## Folder Structure

<p align="center">
  <img alt="folder-diagram" src="https://cloud.githubusercontent.com/assets/794809/25446433/81d3b986-2a7f-11e7-9e84-70eb1c5610dd.png" />
</p>

*Inspiration from [NoRedInk/elm-style-guide](https://github.com/NoRedInk/elm-style-guide)*


## Basic File Descriptions

### Main.elm

- Defines `init` function
- Consumes:
  - `Model` type alias from `Model.elm`
  - `view` function from `View.elm`
  - `update` function and `Msg` type from `Update.elm`
- Kicks off `Html.program`

### Update.elm

- Defines `Msg` type and associated type constructors
- Defines the `update` function handling each case of `Msg`
- Consumes:
  - `Model` type alias from `Model.elm`

### View.elm

- Defines `view` function
- Consumes:
  - `Model` type from `Model.elm`
  
### Model.elm

- Defines `Model` type alias
- Distributes to:
  - `Main.elm`, `Update.elm`, `View.elm`
  
## Folders/Namespaces

### Data/

Define type(s) and/or functions specific to domain
  
### View/

Define view functions specific to a domain
