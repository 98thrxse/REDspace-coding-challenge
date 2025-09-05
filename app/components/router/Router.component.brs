sub navigateToPage(pageName as string, data = {} as object)
    _destroyPage()
    _createPage(pageName, data)
end sub

sub _destroyPage()
    if _isValidPage() then
        page = _getPage()
        page.callFunc("destroy")

        m.top.removeChild(page)
        page = invalid
    end if
end sub

sub _createPage(pageName as string, data = {} as object)
    page = createObject("roSGNode", pageName)
    page.callFunc("update", data)

    m.top.appendChild(page)
    page.setFocus(true)
end sub

function _getPage() as object
    return m.top.getChild(0)
end function

function _isValidPage() as boolean
    return _getPage() <> invalid
end function
