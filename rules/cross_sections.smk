rule cross_section:
    input:
        lambda wc: (
            f"{wc.tune}/free_nucleons/{wc.lepton}/{wc.egl}/"
            "splines_free_nucleon.xml"
            if wc.egl in FREE_NUCLEON_EGLS
            else []
        )
    params:
        target=lambda wc: config["targets"][wc.target],
        n=config["n"],
        energy_range=config["energy_range"],
        input_cross_sections=lambda wc: (
            f"--input-cross-sections "
            f"{wc.tune}/free_nucleons/{wc.lepton}/{wc.egl}/"
            "splines_free_nucleon.xml"
            if wc.egl in FREE_NUCLEON_EGLS
            else ""
        )
        gxmlpath = config["gxmlpath"]
    output:
        temp("{tune}/targets/{target}/{lepton}/{egl}/splines.xml")
    log:
        log = "{tune}/logs/targets/{target}/{lepton}/{egl}.log",
        arg = "{tune}/logs/targets/{target}/{lepton}/{egl}.arg"
    benchmark:
        "{tune}/benchmark/targets/{target}/{lepton}/{egl}.benchmark"
    shell:
        """
        export GMSGLAYOUT=FANCY
        export GXMLPATH={gxmlpath}
        echo \
            {params.input_cross_sections} \
            -p {wildcards.lepton} \
            -t {params.target} \
            --tune {wildcards.tune} \
            --event-generator-list {wildcards.egl} \
            -n {params.n} \
            -e {params.energy_range} \
            -o {output} \
            > {log.arg} 2>&1
        ARGS="$(echo "$(cat {log.arg})")"
        gmkspl $ARGS > {log.log} 2>&1
        """