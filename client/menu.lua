
function SHOW_ALERT_DIALOG(header, content)
    local alert = lib.alertDialog({
        header = header or '',
        content = content or '',
        centered = true,
        cancel = true
    })
end