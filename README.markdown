# My Dotfiles

Install my development environment for [archlinux](https://www.archlinux.org/²)
or [debian](http://debian.org).

```sh
git clone https://github.com/themouette/dotfiles.git
cd dotfiles
./install
```

> Note: you can install only pieces, run `./install -h` to learn more
>
> When a file already exists at the destination (e.g. the default `~/.zshrc` on
> a fresh macOS), it is backed up as `<file>.bck` before being replaced by a
> symlink. Use `./install -f` to delete conflicting files instead — useful on
> a first install to discard stock config files.

Refer to dedicated documentation to learn more:

- [zsh usage](https://github.com/themouette/dotfiles/blob/master/doc/zsh.markdown)
- [vim usage](https://github.com/themouette/dotfiles/blob/master/doc/vim.markdown)
- [git usage](https://github.com/themouette/dotfiles/blob/master/doc/git.markdown)
- [bin usage](https://binhub.com/themouette/dotfiles/blob/master/doc/bin.markdown)
- [tmux usage](https://binhub.com/themouette/dotfiles/blob/master/doc/tmux.markdown)
- [pi usage](https://github.com/themouette/dotfiles/blob/master/doc/pi.markdown)

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
