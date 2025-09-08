sub setup()
    m.routes = getRoutes()
    m.cache = {}

    m.uiResolution = m.global.deviceInfo.uiResolution
    m.safetyMargins = m.global.theme.safetyMargins

    _createSideNav()
    _createOverlay()

    home = m.routes.home
    navigateToPage(home.id)
end sub

sub navigateToPage(pageName as string, content = {} as object)
    _destroyPage()
    _createPage(pageName, content)
    _onSideNavWidthChanged()
end sub

sub enableOverlay(visible as boolean)
    m.overlay.visible = visible
end sub

sub enableSideNav(id as string)
    for each route in m.routes.items()
        value = route.value
        if value.id = id then
            sideNav = value.sideNav
            m.sideNav.visible = sideNav.enabled
        end if
    end for
end sub

sub saveToCache(id as string, data as object)
    m.cache[id] = data
end sub

function loadFromCache(id as string) as object
    return m.cache[id]
end function

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false

    if not press then
        return handled
    end if

    if key = "back" then
        handled = handleKeyBack()
    else if key = "left" then
        handled = handleKeyLeft()
    else if key = "right" then
        handled = handleKeyRight()
    end if

    return handled
end function

function handleKeyBack() as boolean
    return true
end function

function handleKeyLeft() as boolean
    if m.sideNav.visible and m.page.isInFocusChain() then
        m.sideNav.setFocus(true)
    end if

    return true
end function

function handleKeyRight() as boolean
    if m.page.visible and m.sideNav.isInFocusChain() then
        m.page.setFocus(true)
    end if

    return true
end function
