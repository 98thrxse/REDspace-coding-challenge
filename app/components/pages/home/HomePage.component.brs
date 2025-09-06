sub init()
    m.top.id = "HomePage"
    m.config = getHomePageConfig({
        safetyMargins: m.global.theme.safetyMargins
        uiResolution: m.global.deviceInfo.uiResolution
    })

    m.style = m.config.style
    for each item in m.style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    retrieveContent()

    m.rowList.observeFieldScoped("rowItemSelected", "onRowItemSelected")
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub retrieveContent()
    cache = m.global.router.callFunc("loadFromCache", m.top.id)
    if cache = invalid then
        m.global.router.callFunc("enableOverlay", true)
        createFetchShowsTask()
    else
        m.rowList.content = cache.content
        m.global.router.callFunc("enableSideNav", m.top.id)
    end if
end sub

sub createFetchShowsTask()
    m.fetchShowsTask = createObject("roSGNode", "FetchShowsTask")
    m.fetchShowsTask.functionName = "execute"
    m.fetchShowsTask.observeFieldScoped("response", "onFetchShowsTaskComplete")
    m.fetchShowsTask.control = "run"
end sub

sub onFetchShowsTaskComplete(event as object)
    if m.fetchShowsTask <> invalid then
        m.fetchShowsTask.unobserveFieldScoped("response")
        m.fetchShowsTask.control = "stop"
    end if

    content = event.getData()
    if content <> invalid then
        if not content.doesExist("error") then
            contentNode = createObject("roSGNode", "ContentNode")
            contentNode.update(content, true)

            m.rowList.content = contentNode
            m.global.router.callFunc("saveToCache", m.top.id, contentNode)
            
            m.global.router.callFunc("enableOverlay", false)
            m.global.router.callFunc("enableSideNav", m.top.id)
        end if
    end if
end sub

sub updateSafetyRegion(horizMargin as integer)
    m.rowList.itemSize = [m.style.rowList.itemSize[0] - horizMargin, m.rowList.itemSize[1]]
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

sub onFocusChanged()
    hasFocus = m.top.hasFocus()
    if m.rowList <> invalid and hasFocus then
        m.rowList.setFocus(true)
    end if
end sub

sub destroy()
    m.rowList.unobserveFieldScoped("rowItemSelected")
    m.top.unobserveFieldScoped("focusedChild")

    children = m.top.getChildren(-1, 0)
    for each item in children
        m.top.removeChild(item)
        item = invalid
    end for
end sub
