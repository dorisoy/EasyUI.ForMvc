
function getSplitter(id) {
    return $(id || "#Splitter").data("tSplitter");
}

function getSplitterHtml(paneCount) {
    return new $t.stringBuilder()
            .cat("<div style='width: 207px;height:100px'>")
                .rep("<div />", paneCount || 2)
            .cat("</div>")
        .string();
}
