#!/usr/bin/env python3
import yaml
from jinja2 import Environment, FileSystemLoader, StrictUndefined
import os
import json

def render():
    hugo_name = "ps-eks-accelerator"
    config_data = yaml.load(open('./skeleton/values.yaml'))
    # print(json.dumps(config_data, indent=4))

    env = Environment(loader = FileSystemLoader(searchpath="./skeleton/templates/"),   trim_blocks=True, lstrip_blocks=True)
    index_template = env.get_template('index.yaml.j2')
    partner_template = env.get_template('example.yaml.j2')
    example_template = env.get_template('partner.yaml.j2')

    # Check that the hugo project exists
    if not os.path.isdir(hugo_name):
        print("Could not find path:" + hugo_name)
        return

    for k,v in config_data.items():
        for chapters in v:
            for k, v in chapters.items():
                print(json.dumps(v, indent=4))
                # create _index.md
                outdir = os.path.abspath(hugo_name + "/content/" + k)
                if not os.path.exists(outdir):
                    os.makedirs(outdir)
                outfile = outdir + "/" + "_index.md"
                try:
                    os.stat(outfile)
                except:
                    ofile = open(outfile, "w")
                    out = index_template.render(subsections)
                    ofile.write(out)
                    ofile.close()
                for subsections in v: # iterate over subsections
                    sub_outdir = os.path.abspath(outdir + "/" + subsections['name'])
                    if not os.path.exists(sub_outdir):
                        os.makedirs(sub_outdir)
                    sub_outfile = sub_outdir + "/" + "_index.md"
                    try:
                        os.stat(sub_outfile)
                    except:
                        ofile = open(sub_outfile, "w")
                        out = index_template.render(subsections)
                        ofile.write(out)
                        ofile.close()
                    # create _example.md
                    sub_outfile = sub_outdir + "/" + "_example.md"
                    try:
                        os.stat(sub_outfile)
                    except:
                        ofile = open(sub_outfile, "w")
                        out = partner_template.render(subsections)
                        ofile.write(out)
                        ofile.close()
                    # create _partner.md
                    sub_outfile = sub_outdir + "/" + "_partner.md"
                    try:
                        os.stat(sub_outfile)
                    except:
                        ofile = open(sub_outfile, "w")
                        out = example_template.render(subsections)
                        ofile.write(out)
                        ofile.close()

render()