#!/bin/bash
echo 'uninstalling staruml from your ~/.local directory'
echo 'run with -c to remove ~/.config/StarUML'

removeConfig=false

while getopts c opt; do
  case $opt in
    c)
      removeConfig=true
      ;;
  esac
done

shift $((OPTIND - 1))

if [ "$removeConfig" = true ]; then
    echo 'deleting ~/.config/StarUML'
    rm -rf ~/.config/StarUML
fi

# Safety first: only uninstall files we know about.

rm -f ~/.local/bin/staruml
rm -f ~/.local/share/applications/staruml.desktop

echo 'finished uninstall staruml from your ~/.local directory'
