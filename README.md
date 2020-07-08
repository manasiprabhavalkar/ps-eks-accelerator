# EKSAccelerator Packaged Offering

## Development

### Pre-Requisites

Setup [Hugo](https://gohugo.io/) locally as per the [instructions](https://gohugo.io/getting-started/installing/).

E.g. On macOS

```sh
brew install hugo
```

### To build/run locally

```sh
git clone --recursive ssh://git.amazon.com/pkg/EksAcceleratorOffering

cd EksAcceleratorOffering
 
make dev
```

go to ```http://localhost:1313/ps-eks-accelerator```


Hugo Server support hot reloads, so changing files in ps-eks-accelerator/content/ gets reflected in realtime on your browser.
