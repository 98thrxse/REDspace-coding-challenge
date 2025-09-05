sub init()
    m.config = getHomePageConfig({
        safetyMargins: m.global.theme.safetyMargins
        uiResolution: m.global.deviceInfo.uiResolution
    })

    style = m.config.style
    for each item in style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    createFetchShowsTask()

    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub createFetchShowsTask()
    m.fetchShowsTask = createObject("roSGNode", "FetchShowsTask")
    m.fetchShowsTask.functionName = "execute"
    m.fetchShowsTask.observeFieldScoped("response", "onFetchShowsTaskComplete")
    m.fetchShowsTask.control = "run"

    m.global.overlay.visible = true
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

            m.list.content = contentNode

            m.global.overlay.visible = false
        end if
    end if
end sub

sub onFocusChanged()
    hasFocus = m.top.hasFocus()
    if m.list <> invalid and hasFocus then
        m.list.setFocus(true)
    end if
end sub

sub destroy()
    children = m.top.getChildren(-1, 0)
    for each item in children
        m.top.removeChild(item)
        item = invalid
    end for
end sub
