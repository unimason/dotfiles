function extract --description 'Extract common archive formats'
    if test (count $argv) -lt 1
        echo "usage: extract <file>..."
        return 1
    end
    for file in $argv
        if not test -f $file
            echo "extract: '$file' is not a file"; continue
        end
        switch $file
            case '*.tar.bz2' '*.tbz2'; tar xjf $file
            case '*.tar.gz'  '*.tgz';  tar xzf $file
            case '*.tar.xz'  '*.txz';  tar xJf $file
            case '*.tar';              tar xf  $file
            case '*.bz2';              bunzip2 $file
            case '*.gz';               gunzip  $file
            case '*.zip';              unzip   $file
            case '*.7z';               7z x    $file
            case '*.rar';              unrar x $file
            case '*';                  echo "extract: don't know how to extract '$file'"
        end
    end
end
