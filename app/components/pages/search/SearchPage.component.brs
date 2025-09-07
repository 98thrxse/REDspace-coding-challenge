sub init()
    m.top.id = "SearchPage"
    m.config = getSearchPageConfig({
        uiResolution: m.global.deviceInfo.uiResolution
    })

    style = m.config.style
    for each item in style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    m.global.router.callFunc("enableSideNav", m.top.id)
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub onFocusChanged()
    hasFocus = m.top.hasFocus()
    ' if m.video <> invalid and hasFocus then
    '     m.video.setFocus(true)
    ' end if
end sub

sub destroy()
    m.top.unobserveFieldScoped("focusedChild")

    children = m.top.getChildren(-1, 0)
    for each item in children
        m.top.removeChild(item)
        item = invalid
    end for
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    handled = false

    if not press then
        return handled
    end if

    if key = "back" then
        handled = handleKeyBack()
    end if

    return handled
end function

function handleKeyBack() as boolean
    routes = m.global.router.callFunc("getRoutes")
    home = routes.home
    m.global.router.callFunc("navigateToPage", home.id, m.content)

    return true
end function
