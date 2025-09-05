sub init()
    m.config = getRowListItemConfig({
        font: m.global.theme.font
    })

    style = m.config.style
    for each item in style.items()
        m.[item.key] = m.top.findNode(item.key)
        m.[item.key].update(item.value)
    end for

    m.top.observeFieldScoped("itemContent", "onItemContentChanged")
end sub

sub onItemContentChanged(event as object)
    m.itemContent = event.getData()

    if m.itemContent <> invalid then
        setImage()
        setTitle()
        setAverageRating()
    end if
end sub

sub setImage()
    image = m.itemContent.image
    if image <> invalid then
        if image.medium <> invalid then
            m.image.uri = image.medium
        else if image.original <> invalid then
            m.image.uri = image.original
        end if
    end if
end sub

sub setTitle()
    title = m.itemContent.title
    if title <> invalid and not title.isEmpty() then
        m.title.text = title
    end if
end sub

sub setAverageRating()
    averageRating = m.itemContent.averageRating
    if averageRating <> invalid and not averageRating.isEmpty() then
        m.averageRating.text = "★ " + averageRating.toStr()
    end if
end sub
