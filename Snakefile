configfile: "config.yml"

include: "rules/free_nucleons.smk"
include: "rules/cross_sections.smk"
include: "rules/merge_splines.smk"
include: "rules/xml2root.smk"
wildcard_constraints:
    tune = config["tune"]
rule all:
    input:
        expand(
            "{tune}.xml",
            tune=[config["tune"]]
        ),
        expand(
            "{tune}.root",
            tune=[config["tune"]]
        ),