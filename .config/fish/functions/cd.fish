function cd --description "Change directory, using zoxide when available"
    if type -q z
        z $argv
    else
        builtin cd $argv
    end
end
