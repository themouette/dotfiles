My Dotfiles
===========

Install my development environment for [archlinux](https://www.archlinux.org/²)
or [debian](http://debian.org).

``` sh
git clone https://github.com/themouette/dotfiles.git
cd dotfiles
./install.sh
```

Refer to dedicated documentation to learn more:

* [zsh usage](https://github.com/themouette/dotfiles/blob/master/doc/zsh.markdown)
* [vim usage](https://github.com/themouette/dotfiles/blob/master/doc/vim.markdown)
* [git usage](https://github.com/themouette/dotfiles/blob/master/doc/git.markdown)
* [bin usage](https://binhub.com/themouette/dotfiles/blob/master/doc/bin.markdown)

## Install NodeJs

To install nodejs and npm (no sudo required):

``` sh
./install/nodejs.sh 0.12.2
```

## SSH config

For security reasons my `~/.ssh/` folder is not public.

Make sure `~/.ssh/config` contains at least the following:

```
Host *
  PreferredAuthentications publickey
  # Add the key to agent on demand
  AddKeysToAgent yes
  # Manage default key files in a tree
  # Note that %h is host ans %u is remote user
  IdentityFile %d/.ssh/id_rsa
  IdentityFile %d/.ssh/hosts/%h/%u/id_rsa
  IdentityFile %d/.ssh/hosts/%h/id_rsa
  IdentityFile %d/.ssh/users/%u/id_rsa
```
