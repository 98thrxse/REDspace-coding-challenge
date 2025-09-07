sub init()
    m.routes = m.global.router.callFunc("getRoutes")
    m.config = getSideNavConfig({
        font: m.global.theme.font
        colors: m.global.theme.colors
        uiResolution: m.global.deviceInfo.uiResolution
    })

    style = m.config.style
    for each item in style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    setButtonGroup()
    setWidth()

    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub setWidth(state = false as boolean)
    sideNav = m.config.sizes.sideNav
    width = sideNav.width[state.toStr()]

    m.background.width = width
    m.buttonGroup.update({
        maxWidth: width
        minWidth: width
    })

    m.top.width = width
end sub

sub setButtonGroup()
    for each route in m.routes.items()
        value = route.value
        sideNav = value.sideNav

        if sideNav.listed then
            button = createObject("roSGNode", "Button")
            button.id = value.id
            button.text = value.name
            button.observeFieldScoped("buttonSelected", "onButtonSelected")
            m.buttonGroup.appendChild(button)
        end if
    end for
end sub

sub onButtonSelected(event as object)
    id = event.getNode()
    m.global.router.callFunc("navigateToPage", id, m.content)
end sub

sub onFocusChanged()
    isInFocusChain = m.top.isInFocusChain()
    childCount = m.buttonGroup.getChildCount()

    if childCount > 0 and isInFocusChain then
        setWidth(true)
        buttonFocused = m.buttonGroup.buttonFocused
        m.buttonGroup.getChild(buttonFocused).setFocus(true)
    else
        setWidth(false)
    end if
end sub

sub destroy()
end sub
