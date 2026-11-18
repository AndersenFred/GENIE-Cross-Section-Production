FREE_NUCLEON_EGLS = config["free_nucleon_event_generator_lists"]

rule free_proton:
    params:
        target = 1000010010,
        n = config["n"],
        energy_range = config["energy_range"]
        gxmlpath = config["gxmlpath"]
    output:
        "{tune}/free_nucleons/{lepton}/{egl}/splines_free_p.xml"
    log:
        log = "{tune}/logs/free_nucleons/{lepton}/{egl}_p.log",
        arg = "{tune}/logs/free_nucleons/{lepton}/{egl}_p.arg"
    benchmark:
        "{tune}/benchmark/free_nucleons/{lepton}/{egl}_p.benchmark"
    wildcard_constraints:
        egl = "|".join(FREE_NUCLEON_EGLS)
    shell:
        """
        export GXMLPATH={gxmlpath}
        export GMSGLAYOUT=FANCY
        echo \
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


rule free_neutron:
    params:
        target = 1000000010,
        n = config["n"],
        energy_range = config["energy_range"]
        gxmlpath = config["gxmlpath"]
    output:
        temp("{tune}/free_nucleons/{lepton}/{egl}/splines_free_n.xml")
    log:
        log = "{tune}/logs/free_nucleons/{lepton}/{egl}_n.log",
        arg = "{tune}/logs/free_nucleons/{lepton}/{egl}_n.arg"
    benchmark:
        "{tune}/benchmark/free_nucleons/{lepton}/{egl}_n.benchmark"
    wildcard_constraints:
        egl = "|".join(FREE_NUCLEON_EGLS)
    shell:
        """
        export GMSGLAYOUT=FANCY
        export GXMLPATH={gxmlpath}
        echo \
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


rule free_nucleon:
    input:
        proton = "{tune}/free_nucleons/{lepton}/{egl}/splines_free_p.xml",
        neutron = "{tune}/free_nucleons/{lepton}/{egl}/splines_free_n.xml"
    output:
        temp("{tune}/free_nucleons/{lepton}/{egl}/splines_free_nucleon.xml")
    log:
        log = "{tune}/logs/free_nucleons/{lepton}/{egl}.log",
        arg = "{tune}/logs/free_nucleons/{lepton}/{egl}.arg"
    benchmark:
        "{tune}/benchmark/free_nucleons/{lepton}/{egl}_free_nucleon.benchmark"
    wildcard_constraints:
        egl = "|".join(FREE_NUCLEON_EGLS)
    shell:
        """

        echo -f {input.proton},{input.neutron} \
            -o {output} > {log.arg} 2>&1
        ARGS="$(echo "$(cat {log.arg})")"
        gspladd $ARGS > {log} 2>&1
        """