# PGP

There is plenty of guides to generate a new PGP key, so I won't go into that.
This doc only list the commands I use to manage my PGP keys.

## My key management process

I tend to never use the certification key except to sign the master key.

I created subkey stored in a smartcard, so I can use it on any computer without
taking the risk of leaking the key.

## gpgenv

In this repo
([zsh/zshrc.d/gnupg](https://github.com/themouette/dotfiles/blob/master/zsh/zshrc.d/gnupg)) lives the gpgenv tool.

Maybe one day it can be promoted to `bin` directory.
It allows to easily create, backup and restore a GPG environment.

This can be used for key maintenance, but also to create a disposable
environment for testing purpose.

Run `gpgenv -h` to see the available commands.

## Useful commands

### Import private key

Before doing any key operation, I need to import the certification private key
from cold storage.
Ideally this is done in a VM with no network access. At least it should be done
on a trusted computer.

```
# Check it is not yet available
gpg --list-secret-keys
# Import
gpg --allow-secret-key-import --import /path/to/0FE9A9C60ED65AFD_pub-priv.asc
```

### Clean up

Once administration is done, I remove the private key from the keyring.

```
gpg --delete-secret-key 0FE9A9C60ED65AFD
```

### Renew key

When the key is expired, I just do the following:

```
gpg --edit-key 0FE9A9C60ED65AFD
gpg> expire
# then select all the subkeys
gpg> key 1
gpg> key 2
gpg> expire
gpg> save
```

An then backup, export and publish the new key

### Add a new email

```
gpg --edit-key 0FE9A9C60ED65AFD
gpg> adduid
# Fill the form
gpg> save
```

### Revoke an email

```
gpg --edit-key 0FE9A9C60ED65AFD
gpg> uid X
# X is the index of the email to revoke
gpg> revuid
gpg> save
```

### Backup and Export

After any change to the key, I create backups for every private key.

```
# Backup private and public key together for future imports
gpg --armor --export-secret-keys 0FE9A9C60ED65AFD > /path/to/0FE9A9C60ED65AFD_pub-priv.asc
gpg --armor --export 0FE9A9C60ED65AFD >> /path/to/0FE9A9C60ED65AFD_pub-priv.asc

# Backup public key separately
gpg --armor --export 0FE9A9C60ED65AFD >> /path/to/0FE9A9C60ED65AFD.gpg.pub

# Backup subkeys separately
gpg --armor --export-secret-subkeys 0FE9A9C60ED65AFD > /path/to/0FE9A9C60ED65AFD-subkeys_priv.asc
```

All those files are stored in a safe place, then the public key is uploaded to
the key server.

### Publish

For now I did publish my (out of date) key on keybase, but this might change in
the future.

I also added the public key to this repository.

Do not forget to update GitHub and GitLab with the new key.

## Restart from backup

Sometimes you screw up.
Delete the keys (private and public) and re-import:

```
gpg --delete-secret-key 0FE9A9C60ED65AFD
gpg --delete-key 0FE9A9C60ED65AFD
gpg --list-keys
gpg --allow-secret-key-import --import /path/to/0FE9A9C60ED65AFD_pub-priv.asc
```

### Enroll a smartcard (ie: yubikey)

When I get a new smartcard, I follow those steps (inspired from [Debian
Wiki](https://wiki.debian.org/Smartcards/OpenPGP) and [YubiKey 4 series GPG and
SSH setup
guide](https://gist.github.com/ageis/14adc308087859e199912b4c79c4aaa4)):

#### Prepare the card

```
gpg --card-edit

gpg/card> admin
Admin commands are allowed

gpg/card> name
Cardholder's surname: Bar
Cardholder's given name: Foo

gpg/card> passwd
# Change password and admin password

gpg/card> list
# Check everything is correct
gpg/card> quit
```

> You can also toggle the `forcesig` flag to control whether you'd like to
> require a PIN to be entered every time you sign a message.

#### Generate the subkeys

From what I see, it is better to share the same set of keys between ll the
smartcards. Only do this if you plan replacing the keys on every cards (and
maybe revoke the current set of keys).

```
gpg --edit-key 0FE9A9C60ED65AFD
# Create the Encrypt key
gpg> addkey
# Select 6: RSA (encrypt only).
# Set a 4096 bit key size.
# Set the expiration date.
# The first subkey is generated.

# Create the Authenticate key
gpg> addkey
# Select 8: RSA (set your own capabilities)
# Select S and E to toggle off the Sign and Encrypt capabilities.
# Select A to toggle on the Authenticate capability and press Q.
# Set a 4096 bit key size.
# Set the expiration date.
# The second subkey is generated.

gpg> save
```

Note: We'll always use a single encryption key.

#### Backup subkeys

```
gpg --armor --export-secret-subkeys 0FE9A9C60ED65AFD > /path/to/0FE9A9C60ED65AFD-subkeys_priv.asc
```

#### Transfer the keys to the card

```
gpg --edit-key 0FE9A9C60ED65AFD
gpg> toggle
# Select the signature key
gpg> key 1
gpg> keytocard
# Select the encryption key
gpg> key 2
gpg> keytocard
# Select the authentication key
gpg> key 3
gpg> keytocard
gpg> save
```

### Test everything works

If you get `gpg: signing failed: Inappropriate ioctl for device` then just run

```
# Thanks to https://github.com/keybase/keybase-issues/issues/2798
export GPG_TTY=$(tty)
```

Then test the keys:

```
echo "TEST" | gpg -ase -r 0FE9A9C60ED65AFD | gpg
```
