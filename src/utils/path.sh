get_devilbox_path() {
    if [ -n "$DEVILBOX_PATH" ]; then
        printf %s "${DEVILBOX_PATH}"
    else
        printf %s "$HOME/.devilbox"
    fi
}
