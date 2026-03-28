#!/usr/bin/env bash

set -u

log() {
    printf '[bash-dap-demo] %s\n' "$1"
}

sum_range() {
    local start="$1"
    local finish="$2"
    local total=0
    local value

    for ((value = start; value <= finish; value++)); do
        total=$((total + value))
    done

    printf '%s\n' "$total"
}

classify_name() {
    local name="$1"

    case "$name" in
    admin)
        printf 'role=admin\n'
        ;;
    guest)
        printf 'role=guest\n'
        ;;
    *)
        printf 'role=user\n'
        ;;
    esac
}

main() {
    local name="${1:-world}"
    local limit="${2:-5}"
    local total

    log "starting demo"
    log "name=$name limit=$limit"

    total="$(sum_range 1 "$limit")"
    log "sum_range(1, $limit) = $total"

    for item in alpha beta gamma; do
        log "loop item=$item"
    done

    if ((total > 10)); then
        log "total is greater than 10"
    else
        log "total is 10 or less"
    fi

    classify_name "$name"
    log "finished demo"
}

main "$@"
