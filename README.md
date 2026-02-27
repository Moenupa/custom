# Customize your SHELL

Clone and source:

```sh
cd ~
git clone https://github.com/Moenupa/.custom
echo "source ~/.custom/init.profile" >> ~/.profile
```

Install:

- bash/sh: `echo "source ~/.custom/alias.profile" >> ~/.profile`
- fish: `mkdir ~/.config && ln -s ~/.custom ~/.config/fish`
- zsh: edit `~/.zshrc` and register plugins:
    ```bash
    source "$ZSH_CUSTOM/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh"
    plugins=(
        vi-mode
        zsh-history-substring-search
        zsh-autosuggestions
        zsh-syntax-highlighting
    )
    ```
