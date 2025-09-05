function getHomePageConfig(settings as object)
    safetyMargins = settings.safetyMargins

    uiResolution = settings.uiResolution
    screenSize = uiResolution.name

    horizMargin = safetyMargins.horizontal[screenSize]
    vertMargin = safetyMargins.vertical[screenSize]

    sizes = {
        list: {
            FHD: {
                numRows: 2
                itemSpacing: [0, 80]
            }
            HD: {
                numRows: 1
                itemSpacing: [0, 40]
            }
        }
    }

    style = {
        list: {
            numRows: sizes.list[screenSize].numRows
            translation: [horizMargin, vertMargin]
            rowTitleComponentName: "ListLabel"
            itemComponentName: "ListItem"
            itemSize: [uiResolution.width - horizMargin, 395]
            itemSpacing: sizes.list[screenSize].itemSpacing
            rowItemSpacing: [20, 0]
            rowItemSize: [[210, 295]]
            showRowLabel: [true]
            rowFocusAnimationStyle: "floatingFocus"
            vertFocusAnimationStyle: "floatingFocus"
            itemClippingRect: [
                - horizMargin
                - vertMargin
                uiResolution.width
                uiResolution.height
            ]
        }
    }

    config = {
        style: style
    }

    return config
end function
