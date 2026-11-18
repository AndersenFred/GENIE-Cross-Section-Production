rule merge_splines:
    input:
        lambda wc: expand(
            "{tune}/targets/{target}/{lepton}/{egl}/splines.xml",
            tune=wc.tune,
            target=list(config["targets"].keys()),
            lepton=config["leptons"],
            egl=config["event-generator-lists"]
        )
    params:
        files=lambda wc, input: ",".join(input)
    output:
        "{tune}.xml"
    shell:
        """
        gspladd -f {params.files} -o {output}
        """