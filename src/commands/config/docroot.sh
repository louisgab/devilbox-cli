get_current_document_root () {
    get_readable_current_config "Document root" "$DOCROOT_CONFIG"
}

set_document_root () {
    local new=$1
    set_readable_config "Document root" "$DOCROOT_CONFIG" "$new"
}
