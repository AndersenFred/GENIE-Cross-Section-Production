FREE_NUCLEON_EGLS = config["free_nucleon_event_generator_lists"]

rule free_proton:
    params:
        target = 1000010010,
        n = config["n"],
        energy_range = config["energy_range"]
    output:
        "{tune}/free_nucleons/{lepton}/{egl}/splines_free_p.xml"
    log:
        "{tune}/logs/free_p/{lepton}/{egl}.log"
    benchmark:
        "{tune}/benchmark/free_p/{lepton}/{egl}.benchmark"
    wildcard_constraints:
        egl = "|".join(FREE_NUCLEON_EGLS)
    shell:
        """
        export GMSGLAYOUT=FANCY
        gmkspl \
            -p {wildcards.lepton} \
            -t {params.target} \
            --tune {wildcards.tune} \
            --event-generator-list {wildcards.egl} \
            -n {params.n} \
            -e {params.energy_range} \
            -o {output} \
            > {log} 2>&1
        """


rule free_neutron:
    params:
        target = 1000000010,
        n = config["n"],
        energy_range = config["energy_range"]
    output:
        "{tune}/free_nucleons/{lepton}/{egl}/splines_free_n.xml"
    log:
        "{tune}/logs/free_n/{lepton}/{egl}.log"
    benchmark:
        "{tune}/benchmark/free_n/{lepton}/{egl}.benchmark"
    wildcard_constraints:
        egl = "|".join(FREE_NUCLEON_EGLS)
    shell:
        """
        export GMSGLAYOUT=FANCY
        gmkspl \
            -p {wildcards.lepton} \
            -t {params.target} \
            --tune {wildcards.tune} \
            --event-generator-list {wildcards.egl} \
            -n {params.n} \
            -e {params.energy_range} \
            -o {output} \
            > {log} 2>&1
        """


rule free_nucleon:
    input:
        proton = "{tune}/free_nucleons/{lepton}/{egl}/splines_free_p.xml",
        neutron = "{tune}/free_nucleons/{lepton}/{egl}/splines_free_n.xml"
    output:
        "{tune}/free_nucleons/{lepton}/{egl}/splines_free_nucleon.xml"
    wildcard_constraints:
        egl = "|".join(FREE_NUCLEON_EGLS)
    shell:
        """
        gspladd \
            -f {input.proton},{input.neutron} \
            -o {output}
        """