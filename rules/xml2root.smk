rule xmltoroot:
    input:
        "{tune}.xml"
    output:
        temp("{tune}.root")
    params:
        lepton = ",".join(config["leptons"]),
        targetlist = ",".join(
            str(pdg) for pdg in config["targets"].values()
        )
    log:
        "{tune}/logs/xmltoroot.log"
    shell:
        """
        gspl2root \
            -f {input} \
            -o {output} \
            -p {params.lepton} \
            -t {params.targetlist} \
            > {log} 2>&1
        """