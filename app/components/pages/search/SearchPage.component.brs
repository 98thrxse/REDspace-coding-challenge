sub init()
    m.top.id = "SearchPage"
    m.config = getSearchPageConfig({
        font: m.global.theme.font
        uiResolution: m.global.deviceInfo.uiResolution
        safetyMargins: m.global.theme.safetyMargins
    })

    m.style = m.config.style
    for each item in m.style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    m.global.router.callFunc("enableSideNav", m.top.id)

    m.rowList.observeFieldScoped("rowItemSelected", "onRowItemSelected")
    m.keyboard.observeFieldScoped("text", "onKeyboardTextChanged")
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub onRowItemSelected(event as object)
    rowItemSelected = event.getData()

    rowIndex = rowItemSelected[0]
    itemIndex = rowItemSelected[1]

    row = m.rowList.content.getChild(rowIndex)
    item = row.getChild(itemIndex)

    routes = m.global.router.callFunc("getRoutes")
    details = routes.details
    m.global.router.callFunc("navigateToPage", details.id, item)
end sub

sub onKeyboardTextChanged(event as object)
    text = event.getData()

    if text.len() >= m.config.length then
        createSearchShowsTask(text)
    end if
end sub

sub createSearchShowsTask(text as string)
    m.searchShowsTask = createObject("roSGNode", "SearchShowsTask")
    m.searchShowsTask.request = { text: text }
    m.searchShowsTask.functionName = "execute"
    m.searchShowsTask.observeFieldScoped("response", "onSearchShowsTaskComplete")
    m.searchShowsTask.control = "run"
end sub

sub onSearchShowsTaskComplete(event as object)
    if m.searchShowsTask <> invalid then
        m.searchShowsTask.unobserveFieldScoped("response")
        m.searchShowsTask.control = "stop"
    end if

    data = event.getData()
    if data <> invalid then
        content = data.content

        if content <> invalid then
            if not content.doesExist("error") then
                contentNode = createObject("roSGNode", "ContentNode")
                contentNode.update(content, true)

                m.hint.visible = false

                m.rowList.update({
                    content: contentNode
                })
            end if
        end if
    end if
end sub

sub updateSafetyRegion(horizMargin as integer)
    m.hint.width = m.style.hint.width - horizMargin
    m.rowList.itemSize = [m.style.rowList.itemSize[0] - horizMargin, m.rowList.itemSize[1]]
end sub

sub onFocusChanged()
    hasFocus = m.top.hasFocus()
    if m.keyboard <> invalid and hasFocus then
        m.keyboard.setFocus(true)
    end if
end sub

sub destroy()
    m.top.unobserveFieldScoped("focusedChild")
    m.keyboard.callFunc("destroy")

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

    if key = "up" then
        handled = handleKeyUp()

    else if key = "down" then
        handled = handleKeyDown()

    else if key = "back" then
        handled = handleKeyBack()
    end if

    return handled
end function

function handleKeyUp() as boolean
    if m.rowList.content <> invalid then
        m.rowList.setFocus(true)
    end if

    return true
end function

function handleKeyDown() as boolean
    m.keyboard.setFocus(true)

    return true
end function

function handleKeyBack() as boolean
    routes = m.global.router.callFunc("getRoutes")
    home = routes.home
    m.global.router.callFunc("navigateToPage", home.id, m.content)

    return true
end function
