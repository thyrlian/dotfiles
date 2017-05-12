# Jing Li's dotfiles

Lazyman's Swiss Army Knife

## Setup

1. Clone the project;
2. Create symbolic link;
    ```console
    ln -s /where/you/clone/dotfiles ~/dotfiles
    ```
3. Load dotfiles in your [whatever]**rc** file;
    ```shell-script
    for DOTFILE in `find ~/dotfiles/files -type f -name ".*" | sed 's@//@/@'`
    do
      source $DOTFILE
    done
    ```
