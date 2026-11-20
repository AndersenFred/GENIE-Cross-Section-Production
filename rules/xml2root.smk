rule xmltoroot:
    container: 
        config.get("container", None)
    input:
        "{tune}.xml"
    output:
        temp("{tune}.root")
    params:
        energy_range=config["energy_range"],
        lepton = ",".join(config["leptons"]),
        targetlist = ",".join(
            str(pdg) for pdg in config["targets"].values()
        )
    log:
        log = "{tune}/logs/xmltoroot/xmltoroot.log",
        arg = "{tune}/logs/xmltoroot/xmltoroot.arg",
    benchmark:
        "{tune}/benchmark/xmltoroot/xmltoroot.benchmark"
    shell:
        """
        echo -f {input} \
            -o {output} \
            -p {params.lepton} \
            -t {params.targetlist} \
            --tune {wildcards.tune} \
            -e {params.energy_range} \
            > {log.arg} 2>&1
        ARG="$(echo "$(cat {log.arg})")"
        gspl2root $ARG > {log} 2>&1
        """