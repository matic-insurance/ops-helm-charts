### Update Charts repository with new version

Charts are served via GitHub Pages from the `docs` folder:

```console
$ helm package nginx && helm package rails
$ mv *.tgz docs
$ helm repo index docs --url https://matic-insurance.github.io/ops-helm-charts/
$ git add .
$ git commit -av
$ git push origin master
```

From there, we can add repo `helm repo add helm-charts https://matic-insurance.github.io/ops-helm-charts`
