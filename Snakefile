configfile: "G18_10a.yml"

include: "rules/free_nucleons.smk"
include: "rules/cross_sections.smk"
include: "rules/merge_splines.smk"
include: "rules/xml2root.smk"
wildcard_constraints:
    tune = config["tune"]
rule all:
    input:
        [
            expand(file, tune=config["tune"])
            for file in config["output"]
        ]