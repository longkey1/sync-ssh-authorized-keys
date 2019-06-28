# sync-ssh-authorized-keys

sync ssy authroized keys file.

## Install

edit configuration file.

```shell
$ echo 'https://github.com/longkey1.keys' > keys-urls.dist
$ echo 'https://github.com/longkey2.keys' >> keys-urls.dist
```

install

```shell
$ make install
```

uninstall

```shell
$ make uninstall
```
