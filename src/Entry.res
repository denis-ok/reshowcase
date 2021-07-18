open Belt

type rec addFunctions = {
  addDemo: (string, Configs.demoUnitProps => React.element) => unit,
  addCategory: (string, addFunctions => unit) => unit,
}

let rootMap: Entity.mutableEntityMap = MutableMap.String.make()

let demo = (f): unit => {
  let internalAddDemo = (demoName: string, demoUnit: Configs.demoUnitProps => React.element) => {
    rootMap->MutableMap.String.set(demoName, Demo(demoUnit))
  }

  let rec internalAddCategory = (
    categoryName: string,
    func: addFunctions => unit,
    ~prevMap: Entity.mutableEntityMap,
  ) => {
    let newCategory = MutableMap.String.make()

    prevMap->MutableMap.String.set(categoryName, Category(newCategory))

    let newAddDemo = (demoName: string, demoUnit: Configs.demoUnitProps => React.element) => {
      newCategory->MutableMap.String.set(demoName, Demo(demoUnit))
    }

    let newFunctions = {
      addDemo: newAddDemo,
      addCategory: internalAddCategory(~prevMap=newCategory),
    }

    func(newFunctions)
  }

  let addFunctions = {
    addDemo: internalAddDemo,
    addCategory: internalAddCategory(~prevMap=rootMap),
  }

  f(addFunctions)
}

let start = () =>
  switch ReactDOM.querySelector("#root") {
  | Some(root) => ReactDOM.render(<ReshowcaseUi.App demos=rootMap />, root)
  | None => ()
  }
