+++
title = "Editing Docs"
date = 2020-06-16T19:01:12-04:00
weight = 1
chapter = true
pre = "<b></b>"
+++

# Editing Docs

Tips and Tricks for editing and adidng to the Hugo site

### Basic Layout

Each chapter or folder has to have an "_index.md" file.

```bash
├── Building\ Clusters
│   ├── _index.md
│   ├── eksctl.md
│   ├── introduction.md
│   └── terraform.md
└── _index.md
```
### Ordering files/chapters

I add the following at the top of each _index.md file.

title = The name of the chapter on the sidebar

chapter = determines whether or not it can weighted with other chapters within the same folder. (I set this to true for every markdown file)

```bash
+++
title = "Building Clusters Part 1"
date = 2020-06-16T19:01:12-04:00
weight = 5 #weight specifies the order
chapter = true
pre = "<b></b>"
+++
```

If I wanted to add another section called "Building Clusters Part 2" I would add in a new markdown file "part2.md"

#### At the top I would add

```bash
+++
title = "Building Clusters Part 2"
date = 2020-06-16T19:01:12-04:00
weight = 10 #weight specifies the order
chapter = true
pre = "<b></b>"
+++
```
### Running locally

```bash
make docs
```

or

```bash
cd ps-eks-accelerator && hugo serve -D
``` 

navigate to ```http://localhost:1313/ps-eks-accelerator```

### Images

Images live in the ```ps-eks-accelerator/static/images/name-of-chapter/image.png```

#### Adding an image 
Examples is to add the image  ```eks-product-page.png``` in the Chapter ```Introduction```

We would add the image to ```ps-eks-accelerator/static/images/introduction/eks-product-page.png```

#### Linking to an image in a page

```bash
![Example Image](/images/introduction/eks-product-page.png)!
```

### Code samples

To add a bash code block use three backticks \```bash     (MY CODE HERE) \```
To add a yaml code block use three backticks \```yaml     (MY CODE HERE) 
\```

### Collapse Text

```bash
#Remove the spaces between the brackets {{ }}
{ {%expand "Title of the Colapse" %} }

Things: to put in my collapase

{ {% /expand %} }"

```

### Launching Site on Github via Environments

Here we show how you use Github to automatically build/deploy this site on Github Pushes and Merges

#### Step 1

Create an actions file

```bash
touch .github/workflows/docs.yaml
```
#### Step 2

Change the two parameters in the ```config.toml``` to match desired github repo. 
* The repo name needs to match the hugo project name
If we wanted to rename it we need to change both.

```yaml
baseurl = "https://jonahjon.github.io/ps-eks-accelerator"
```

#### Step 3

Assuming you have, or know how to create a github API key go do that through the developer settings.

Name it ```ACTIONS_DEPLOY_KEY```

#### Step 4

Finish by adding in our github actions workflow. This will deploy the site on git pushes, and can be found in the "Environments" section under the repo.

```yaml
name: Publish EKS Accelerator

on:
  push:
    branches: [ master ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: Checkout
        uses: actions/setup-node@v1
        with:
          node-version: 10.x
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2.2.1
        with:
          hugo-version: '0.58.3'
      - name: Prepare Hugo
        run: |
          git submodule sync && git submodule update --init
      - name: Build
        run: make docs
      - name: add nojekyll
        run: touch ./ps-eks-accelerator/public/.nojekyll
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          publish_dir: ./ps-eks-accelerator/public  # default: public
          github_token: ${{ secrets.GITHUB_TOKEN }}
```
