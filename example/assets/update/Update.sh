#!/bin/sh
set -eu
mode=$1
job=$2
target=$3
old_pid=$4
version=$5
checksum=$6
language=$7
theme=$8
workspace=$(CDPATH= cd -- "$(dirname -- "$job")" && pwd -P)
parent=$(dirname -- "$workspace")
case "$(basename -- "$workspace")" in .eui-update-*) ;; *) exit 1 ;; esac
[ "$job" = "$workspace/job.json" ] && [ ! -L "$target" ] && [ ! -L "$job" ]
[ "$(dirname -- "$target")" = "$parent" ] && [ -f "$target/Contents/MacOS/example" ]
staged="$workspace/EUI Gallery.app"
backup="$target.before-$(basename -- "$workspace")"
[ ! -e "$backup" ]

if [ "$mode" = prepare ]; then
    actual_checksum=$(/usr/bin/shasum -a 256 "$workspace/package.zip")
    [ "${actual_checksum%% *}" = "$checksum" ]
    /usr/bin/zipinfo -1 "$workspace/package.zip" > "$workspace/entries"
    while IFS= read -r path; do
        case "$path" in
            'EUI Gallery.app/'*|'__MACOSX/EUI Gallery.app/'*|'__MACOSX/') ;;
            *) exit 1 ;;
        esac
        case "/${path%/}/" in *'/../'*|*'/./'*|*'//'*|*'\'*) exit 1 ;; esac
    done < "$workspace/entries"
    echo 0
    /usr/bin/ditto -x -k "$workspace/package.zip" "$workspace"
    [ -f "$staged/Contents/MacOS/example" ] && [ ! -L "$staged" ]
    /usr/bin/codesign --verify --deep --strict "$staged"
    echo 100
    exit 0
fi

[ "$mode" = apply ]
count=0
while kill -0 "$old_pid" 2>/dev/null; do
    sleep 1
    count=$((count + 1))
    [ "$count" -lt 60 ] || exit 1
done
moved=0
installed=0
new_pid=
rollback() {
    trap - EXIT
    if [ -n "$new_pid" ] && kill -0 "$new_pid" 2>/dev/null; then
        kill "$new_pid"
        wait "$new_pid" 2>/dev/null || true
    fi
    if [ "$installed" = 1 ]; then mv "$target" "$staged"; fi
    if [ "$moved" = 1 ]; then mv "$backup" "$target"; fi
    /usr/bin/open -n "$target" --args --update-failed
    exit 1
}
trap rollback EXIT
mv "$target" "$backup"
moved=1
mv "$staged" "$target"
installed=1
printf '%s' "$version" > "$workspace/installed"
if [ "$theme" = dark ]; then
    "$target/Contents/MacOS/example" --update-result "$job" --language "$language" --dark > "$workspace/launch.log" 2>&1 &
else
    "$target/Contents/MacOS/example" --update-result "$job" --language "$language" > "$workspace/launch.log" 2>&1 &
fi
new_pid=$!
count=0
while [ ! -f "$job.ready" ]; do
    sleep 1
    kill -0 "$new_pid" 2>/dev/null || exit 1
    count=$((count + 1))
    [ "$count" -lt 60 ] || exit 1
done
trap - EXIT
rm -rf -- "$workspace"
