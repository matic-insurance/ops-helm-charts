## OPS-HELM-CHARS

Project contains charts for:
* nginx web-server
* ruby on rails application

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

From there, I we can add repo `helm repo add helm-chart https://matic-insurance.github.io/ops-helm-charts`
