Common `*sh` functions or aliases
=================================

The `~/.sh/shrc.d/` content is sourced for bash or zsh configuration.

## Disable gnome keyring for ssh agent

Due to `ed25519` not being supported by gnome agent, I deactivate the agent
using [this technique](http://askubuntu.com/a/594147).

Then agent still needs to be activated.

## Common vars

- `$IS_MACOS` will be `"true"` when on MacOs
- `$IS_LINUX` will be `"true"` when on Linux

``` sh
if [[ "$IS_MACOS" = "true" ]] ; then
    # Do something specific to macos
elif [[ "$IS_LINUX" = "true" ]] ; then
    # Do something specific to linux
fi
```

## Commands

* `fonctions` List available functions. Yes, this is in french.
* `bashtips` List a set of tips for bash
* `myip`
* `myip6`
