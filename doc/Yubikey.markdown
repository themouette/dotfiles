Yubikey
=======

Describe how to install/use yubikey for several things.

### Browser

To use Yubikey U2F functionality in the browser, you will need nothing in
chrome, but Firefox requires [u2f-support-add-on
](https://addons.mozilla.org/en-US/firefox/addon/u2f-support-add-on/?src=api)

**Note that in September 2017, [Firefox Nightly enables support for FIDO U2F
Security Keys](https://www.yubico.com/2017/09/firefox-nightly-enables-support-fido-u2f-security-keys/)**

### Session Login

To log in your session, you'll need [yubico-pam
](https://developers.yubico.com/yubico-pam/). Note on arch linux, it is a
`pacman -S yubico-pam` away.

Then, just set up [pam authentication with challenge response
](https://developers.yubico.com/yubico-pam/Authentication_Using_Challenge-Response.html)

```
# Program a YubiKey for challenge response on Slot 2 if not done yet:
$ ykpersonalize -2 -ochal-resp -ochal-hmac -ohmac-lt64 -oserial-api-visible
...
Commit? (y/n) [n]: y

# Now generate local challenge and store it in /var/yubico
# NOTE that 123456 is your key id, so change accordingly
$ ykpamcfg -2 -v
$ sudo mkdir -p /var/yubico
$ sudo mv ~/.yubico/challenge-123456 /var/yubico/$USER-123456
$ sudo chown -R root:root /var/yubico/
$ sudo chmod -R 600 /var/yubico/
```

Then, Activate pam strategy:

```
$ sudo vim /etc/pam.d/system-login # or /etc/pam.d/common-auth
```

Prepend the following line as the first auth strategy

```
auth   sufficient        pam_yubico.so mode=challenge-response chalresp_path=/var/yubico
```

Open a new terminal as root (`sudo -i`, just in case to revert change),
and reload pam rules in current one:

```
$ sudo pam-auth-update
$ sudo -i # should not require a password
```

### Lock screen on key removal

From my current understanding, this is a `udev` script like:

- https://gist.github.com/jhass/070207e9d22b314d9992


### TOTP

You'll need yubikey-manger, `sudo pacman -S yubikey-manager ccid`

```
ykman oath list
```

In case the card cannot be found, you need to activate CCID communication mode,
just `ykman mode 6`.

### Going further

You can manage GPG keys, ssh login, vpn authentication, git commit signature...
