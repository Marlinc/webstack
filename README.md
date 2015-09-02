# Run

```bash
puppet module install puppetlabs-apache
puppet module install rlenglet-debconf_package
```

```bash
sudo FACTERLIB=`pwd`/facts puppet apply webstack.pp --verbose --debug --modulepath ~/.puppet/modules
```
