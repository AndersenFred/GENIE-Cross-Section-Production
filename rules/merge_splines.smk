rule merge_splines:
    container: 
        config.get("container", None)
    input:
        lambda wc: expand(
            "{tune}/targets/{target}/{lepton}/{egl}/splines.xml",
            tune=wc.tune,
            target=list(config["targets"].keys()),
            lepton=config["leptons"],
            egl=config["event-generator-lists"]
        )
    log:
        log = "{tune}/logs/merge/{tune}.log",
        arg = "{tune}/logs/merge/{tune}.arg"
    benchmark:
        "{tune}/benchmark/xmltoroot.benchmark"
    params:
        files=lambda wc, input: ",".join(input)
    output:
        temp("{tune}.xml")
    shell:
        """
        echo -f {params.files} -o {output} > {log.arg} 2>&1
        ARGS="$(echo "$(cat {log.arg})")"
        gspladd $ARGS > {log.log} 2>&1
        """