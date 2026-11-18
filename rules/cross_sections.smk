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
    output:
        temp("{tune}/targets/{target}/{lepton}/{egl}/splines.xml")
    log:
        "{tune}/logs/targets/{target}/{lepton}/{egl}.log"
    benchmark:
        "{tune}/benchmark/targets/{target}/{lepton}/{egl}.benchmark"
    shell:
        """
        export GMSGLAYOUT=FANCY
        gmkspl \
            {params.input_cross_sections} \
            -p {wildcards.lepton} \
            -t {params.target} \
            --tune {wildcards.tune} \
            --event-generator-list {wildcards.egl} \
            -n {params.n} \
            -e {params.energy_range} \
            -o {output} \
            > {log} 2>&1
        """