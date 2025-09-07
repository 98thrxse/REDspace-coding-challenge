sub init()
    m.top.id = "DetailsPage"
    m.routes = m.global.router.callFunc("getRoutes")
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

    m.global.router.callFunc("enableSideNav", m.top.id)
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub onFocusChanged()
    hasFocus = m.top.hasFocus()
    childCount = m.buttonGroup.getChildCount()

    if childCount > 0 and hasFocus then
        buttonFocused = m.buttonGroup.buttonFocused
        m.buttonGroup.getChild(buttonFocused).setFocus(true)
    end if
end sub

sub updateContent(content as object)
    m.content = content

    setImage()
    setTextGroup()
end sub

sub updateSafetyRegion(horizMargin as integer)
    m.title.width = m.style.title.width - horizMargin
    m.summary.width = m.style.summary.width - horizMargin
    m.averageRating.width = m.style.averageRating.width - horizMargin
    m.genres.width = m.style.genres.width - horizMargin
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
            m.genres.text += ("•" + genre + chr(32))
        end for
        m.textGroup.appendChild(m.genres)
    end if
end sub

sub setButtonGroup()
    m.buttonGroup = createObject("roSGNode", "ButtonGroup")
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
    player = m.routes.player
    m.global.router.callFunc("navigateToPage", player.id, m.content)
end sub

sub onBackButtonSelected()
    home = m.routes.home
    m.global.router.callFunc("navigateToPage", home.id)
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
    childCount = m.buttonGroup.getChildCount()
    buttonFocused = m.buttonGroup.buttonFocused

    if childCount > 0 and buttonFocused > 0 then
        buttonFocused--
        m.buttonGroup.getChild(buttonFocused).setFocus(true)
        return true
    end if

    return false
end function

function handleKeyRight() as boolean
    childCount = m.buttonGroup.getChildCount()
    buttonFocused = m.buttonGroup.buttonFocused

    if childCount > 0 and buttonFocused < childCount - 1 then
        buttonFocused++
        m.buttonGroup.getChild(buttonFocused).setFocus(true)
        return true
    end if

    return false
end function

function handleKeyBack() as boolean
    onBackButtonSelected()
    return true
end function
