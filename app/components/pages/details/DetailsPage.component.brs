sub init()
    m.config = getDetailsConfig({
        font: m.global.theme.font
        safetyMargins: m.global.theme.safetyMargins
        uiResolution: m.global.deviceInfo.uiResolution
    })

    m.style = m.config.style
    for each item in m.style.items()
        m.[item.key] = m.top.findNode(item.key)
        if m.[item.key] <> invalid then m.[item.key].update(item.value)
    end for

    m.index = 0
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub onFocusChanged()
    hasFocus = m.top.hasFocus()
    if m.playButton <> invalid and hasFocus then
        m.buttonGroup.getChild(m.index).setFocus(true)
    end if
end sub

sub update(content as object)
    m.content = content

    setImage()
    setTextGroup()
end sub

sub setImage()
    image = m.content.image
    if image <> invalid then
        if image.original <> invalid then
            m.image.uri = image.original
        else if image.medium <> invalid then
            m.image.uri = image.medium
        end if
    end if
end sub

sub setTextGroup()
    setTitle()
    setAverageRating()
    setSummary()
    setGenres()
    setButtonGroup()
end sub

sub setTitle()
    title = m.content.title
    if title <> invalid and not title.isEmpty() then
        m.title = createObject("roSGNode", "Label")
        m.title.update(m.style.title)
        m.title.text = title
        m.textGroup.appendChild(m.title)
    end if
end sub

sub setAverageRating()
    averageRating = m.content.averageRating
    if averageRating <> invalid and not averageRating.isEmpty() then
        m.averageRating = createObject("roSGNode", "Label")
        m.averageRating.update(m.style.averageRating)
        m.averageRating.text = "★ " + averageRating.toStr()
        m.textGroup.appendChild(m.averageRating)
    end if
end sub

sub setSummary()
    summary = m.content.summary
    if summary <> invalid and not summary.isEmpty() then
        m.summary = createObject("roSGNode", "Label")
        m.summary.update(m.style.summary)
        m.summary.text = summary.toStr()
        m.textGroup.appendChild(m.summary)
    end if
end sub

sub setGenres()
    genres = m.content.genres
    if genres <> invalid and genres.count() > 0 then
        m.genres = createObject("roSGNode", "Label")
        m.genres.update(m.style.genres)
        for each genre in genres
            m.genres.text += ("•" + genre + " ")
        end for
        m.textGroup.appendChild(m.genres)
    end if
end sub

sub setButtonGroup()
    m.buttonGroup = createObject("roSGNode", "LayoutGroup")
    m.buttonGroup.update(m.style.buttonGroup)
    m.textGroup.appendChild(m.buttonGroup)

    setPlayButton()
    setBackButton()
end sub

sub setPlayButton()
    m.playButton = createObject("roSGNode", "Button")
    m.playButton.update(m.style.playButton)
    m.playButton.observeFieldScoped("buttonSelected", "onPlayButtonSelected")
    m.buttonGroup.appendChild(m.playButton)
end sub

sub setBackButton()
    m.backButton = createObject("roSGNode", "Button")
    m.backButton.update(m.style.backButton)
    m.backButton.observeFieldScoped("buttonSelected", "handleKeyBack")
    m.buttonGroup.appendChild(m.backButton)
end sub

sub onPlayButtonSelected()
    routerConstants = m.global.router.callFunc("getRouterConstants")
    m.global.router.callFunc("navigateToPage", routerConstants.routes.player, m.content)
end sub

sub onBackButtonSelected()
    routerConstants = m.global.router.callFunc("getRouterConstants")
    m.global.router.callFunc("navigateToPage", routerConstants.routes.home)
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

    if key = "left" then
        handled = handleKeyLeft()

    else if key = "right" then
        handled = handleKeyRight()

    else if key = "back" then
        handled = handleKeyBack()

    end if

    return handled
end function

function handleKeyLeft() as boolean
    if m.index > 0 then
        m.index--
        m.buttonGroup.getChild(m.index).setFocus(true)
    end if

    return true
end function

function handleKeyRight() as boolean
    if m.index < m.buttonGroup.getChildCount() - 1 then
        m.index++
        m.buttonGroup.getChild(m.index).setFocus(true)
    end if

    return true
end function

function handleKeyBack() as boolean
    onBackButtonSelected()
    return true
end function
