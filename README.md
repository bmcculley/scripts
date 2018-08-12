# Scripts

Various scripts to help do things.

Shell Tricks
------------

```bash
# run multiple scripts from a directory
ls example{1..2}.sh|xargs -n 1 -P 0 bash

# run the previous command as sudo
sudo !!

# a function to create a directory and move into it
function mkcd() { mkdir -p "$1" && cd "$_"; }

# remove lines that begin with '#'
sed '/^#/ d'

# remove empty lines
sed -i '/^$/d'

# create muliple files oneliner
touch /some/directory/{file1.txt,file2.txt}
```

**more to come, feel free to add "tricks"**
