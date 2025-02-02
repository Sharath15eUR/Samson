#!/bin/bash
ERROR_LOG="errors.log"
display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -d <directory>    Directory to search for a keyword."
    echo "  -k <keyword>      Keyword to search for in files."
    echo "  -f <file>         File to search for a keyword."
    echo "  --help            Display this help menu."
    echo
    echo "Examples:"
    echo "  $0 -d logs -k error       # Search 'logs' directory for 'error'"
    echo "  $0 -f script.sh -k TODO   # Search 'script.sh' for 'TODO'"
    echo "  $0 --help                 # Display this help menu"
}
 
log_error() {
    local error_message="$1"
    echo "Error: $error_message" | tee -a "$ERROR_LOG" >&2
}
 
search_file() {
    local file="$1"
    local keyword="$2"
 
    if [[ ! -f "$file" ]]; then
        log_error "File '$file' does not exist."
        return
    fi
 
    echo "Searching for '$keyword' in '$file':"
    grep "$keyword" "$file"
    if [[ $? -ne 0 ]]; then
        log_error "The keyword '$keyword' was not found in '$file'."
    fi
}
 
search_directory() {
    local dir="$1"
    local keyword="$2"
 
    if [[ ! -d "$dir" ]]; then
        log_error "Directory '$dir' does not exist."
        return
    fi
 
    echo "Searching for '$keyword' in '$dir':"
    grep -r "$keyword" "$dir"
    if [[ $? -ne 0 ]]; then
        log_error "No files containing the keyword '$keyword' were found in '$dir'."
    fi
}
 
main() {
    if [[ "$1" == "--help" ]]; then
        display_help
        exit 0
    fi
 
    local directory=""
    local keyword=""
    local file=""
 
    while getopts ":d:k:f:" opt; do
        case "$opt" in
            d) directory="$OPTARG" ;;
            k) keyword="$OPTARG" ;;
            f) file="$OPTARG" ;;
            *) log_error "Invalid option: -$OPTARG"; display_help; exit 1 ;;
        esac
    done
 
    # Check if keyword is provided
    if [[ -z "$keyword" ]]; then
        log_error "Keyword is required."
        display_help
        exit 1
    fi
 
    if [[ -n "$directory" ]]; then
        search_directory "$directory" "$keyword"
    elif [[ -n "$file" ]]; then
        search_file "$file" "$keyword"
    else
        log_error "You must specify either a directory (-d) or a file (-f)."
        display_help
        exit 1
    fi
}
 

    main "$@"


