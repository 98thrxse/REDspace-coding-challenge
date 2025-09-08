sub init()
    m.config = getKeyboardConfig({
        uiResolution: m.global.deviceInfo.uiResolution
        safetyMargins: m.global.theme.safetyMargins
    })

    m.style = m.config.style
    for each item in m.style.items()
        m.[item.key] = m.top.findNode(item.key)
        if m.[item.key] <> invalid then m.[item.key].update(item.value)
    end for

    setKeyboard()
    m.top.observeFieldScoped("focusedChild", "onFocusChanged")
end sub

sub setKeyboard()
    m.keyGrid = m.top.keyGrid
    m.textEditBox = m.top.textEditBox

    m.textEditBox.update(m.style.textEditBox)
    m.textEditBox.observeFieldScoped("text", "onTextChanged")

    m.keyGrid.update(m.style.keyGrid)
    
    setTranslation()
end sub

sub setTranslation(state = false as boolean)
    keyboardBound = m.top.boundingRect()
    textEditBoxBound = m.textEditBox.boundingRect()

    x = m.style.keyboard.translation[0] - keyboardBound.width / 2
    if state then
        y = m.style.keyboard.translation[1] - keyboardBound.height
    else
        y = m.style.keyboard.translation[1] - textEditBoxBound.height
    end if

    m.top.translation = [x, y]
end sub

sub onTextChanged(event as object)
    m.top.text = event.getData()
end sub

sub onFocusChanged()
    isInFocusChain = m.top.isInFocusChain()
    if isInFocusChain then
        setTranslation(true)
    else
        setTranslation(false)
    end if
end sub

sub destroy()
    m.top.unobserveFieldScoped("focusedChild")

    children = m.top.getChildren(-1, 0)
    for each item in children
        m.top.removeChild(item)
        item = invalid
    end for
end sub
