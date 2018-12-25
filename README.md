# elm-js-no-ports
Elm and JavaScript communication without ports.

- Elm → JavaScript
    - using property setter of custom element
- JavaScript → Elm
    - using custom event of custom element

---

1. Create custom element and custom event
```js
customElements.define(
    "elm-node",
    class extends HTMLElement {
        constructor() {
            super();
        }

        set elmAttr(name) {
            if (!name)
                return;
            const reply = `Hello ${name} !!`;
            const event = new CustomEvent("elm-event", {
                detail: reply
            });
            document.getElementById("elm-node").dispatchEvent(event);
        }
    }
);
```

2. Use custom element in Elm
```elm
    Html.node "elm-node"
        [ id "elm-node"
        , property "elmAttr" <| E.string model.output
        , on "elm-event" <| D.map Receive (D.at [ "detail" ] D.string)
        ]
        []
```

3. Set value in property
```elm
update msg model =
    case msg of

        -- ...
    
        Save ->
            ( { model | output = model.name }, Cmd.none )
```

4. Use received value
```elm
update msg model =
    case msg of

        -- ...

        Receive received ->
            ( { model | received = received }, Process.sleep 0 |> Task.perform (always NoOp) )
```
using Cmd.none will not rerender (I don't know why :disappointed:)
