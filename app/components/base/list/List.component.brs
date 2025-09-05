sub init()
    m.top.observeFieldScoped("rowItemSelected", "onRowItemSelected")
end sub

sub onRowItemSelected(event as object)
    rowItemSelected = event.getData()

    rowIndex = rowItemSelected[0]
    itemIndex = rowItemSelected[1]

    row = m.top.content.getChild(rowIndex)
    item = row.getChild(itemIndex)

    routerConstants = m.global.router.callFunc("getRouterConstants")
    m.global.router.callFunc("navigateToPage", routerConstants.routes.details, item)
end sub
