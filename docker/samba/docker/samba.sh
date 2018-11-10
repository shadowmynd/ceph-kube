#!/bin/sh

exec ionice -c 3 smbd -FS </dev/null &
exec ionice -c 3 nmbd -FS </dev/null
