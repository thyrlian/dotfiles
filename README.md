# Jing Li's dotfiles

Lazyman's Swiss Army Knife

## Setup

1. Clone the project;
2. Create symbolic link;
    ```shell-script
    ln -s /where/you/clone/dotfiles ~/dotfiles
    
    # Optional: hide the symbolic link but not the source file
    SetFile -P -a V ~/dotfiles
    ```
3. Load dotfiles in your [whatever]**rc** file;
    ```shell-script
    for DOTFILE in `find ~/dotfiles/files -type f -name ".*" | sed 's@//@/@'`
    do
      source $DOTFILE
    done
    ```
