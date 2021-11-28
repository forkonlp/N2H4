getSection = function (html_obj, body_node_info = "script", 
          body_attr = "") 
{
    body <- rvest::html_nodes(html_obj, body_node_info)
    body <- rvest::html_text(body)
  Encoding(body) <- "UTF-8"
  body = stringr::str_extract(na.exclude(stringr::str_extract(body,"sid\\:.+\\,")),"\\d.+\\d")
  return(body)
}
