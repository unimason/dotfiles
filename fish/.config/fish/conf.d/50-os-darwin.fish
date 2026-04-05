# macOS-only configuration
test (uname) = Darwin; or exit 0
status is-interactive; or exit 0

# Homebrew
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
else if test -x /usr/local/bin/brew
    /usr/local/bin/brew shellenv | source
end

# macOS-friendly abbreviations
abbr -a o    open
abbr -a oo   'open .'
abbr -a pbc  pbcopy
abbr -a pbp  pbpaste
abbr -a showfiles 'defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
abbr -a hidefiles 'defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
