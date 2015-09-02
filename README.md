# Run

```bash
puppet module install puppetlabs-apache
```

```bash
sudo FACTERLIB=`pwd`/facts puppet apply webstack.pp --verbose --debug --modulepath ~/.puppet/modules
```
