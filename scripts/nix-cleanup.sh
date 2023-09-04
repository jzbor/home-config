#!/bin/sh

OLDER_THAN="14d"

if command -v home-manager > /dev/null; then
	echo
	echo "=== Expiring home-manager generations ==="
	echo "> home-manager expire-generations \"$OLDER_THAN\""
	home-manager expire-generations "$OLDER_THAN"
else
	echo "=> Skipping home-manager cleanup ('home-manager' not available)"
fi

echo
echo "=== Cleaning local profile ==="
echo "> nix profile wipe-history --older-than \"$OLDER_THAN\""
nix profile wipe-history --older-than "$OLDER_THAN"

if command -v doas > /dev/null; then
	echo
	echo "=== Cleaning system profile ==="
	echo "> doas nix-collect-garbage -d --delete-older-than \"$OLDER_THAN\""
	doas nix-collect-garbage -d --delete-older-than "$OLDER_THAN"
else
	echo "=> Skipping system profile ('doas' not available)"
fi

echo
echo "=== Running garbage collection on nix store ==="
echo "> nix store gc"
nix store gc


echo
echo "=== Optimizing nix store ==="
echo
echo "> nix store optimise"
nix store optimise
