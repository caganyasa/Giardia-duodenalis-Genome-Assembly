rule fastqc_before_trimming:
    input:
        input_dir=config["data_dir"] + "/DNA/raw"
    params:
        threads=32
    output:
        out_dir=directory("results/Genomics/1_Assembly/1_Preprocessing/fastqc_before_trimming/")
    conda:
        "envs/genomics.yaml"
    script:
        "scripts/Genomics/1_Assembly/1_Preprocessing/ReadQualityCheck.py"


# =========================
# ASSEMBLY
# =========================

rule flye:
    input:
        reads=config["data_dir"] + "/DNA/{process}/nanopore.fastq.gz"
    params:
        genome_size="114m",
        threads=32
    output:
        assembly="results/Genomics/1_Assembly/2_Assemblers/flye/{process}/assembly.fasta/assembly.fasta"
    conda:
        "envs/genomics.yaml"
    script:
        "scripts/Genomics/1_Assembly/2_Assemblers/FlyeAssembler.py"

# =========================
# (DISABLED) Meryl (missing script)
# =========================
# rule meryl:
#     input:
#         genome="results/Genomics/1_Assembly/2_Assemblers/{assembler}/assembly.fasta"
#     output:
#         merylDB=directory("results/Genomics/1_Assembly/3_Evaluation/winnowmap/{assembler}/merlyDB"),
#         repetitive_k15="results/Genomics/1_Assembly/3_Evaluation/winnowmap/{assembler}/repetitive_k15.txt"
#     params:
#         threads=30,
#         nanopore=True
#     conda:
#         "envs/genomics.yaml"
#     script:
#         "scripts/Genomics/1_Assembly/3_Evaluation/CalculateKmerLongReads.py"


# =========================
# (OPTIONAL) Winnowmap (meryl bağlı olduğu için kapalı)
# =========================
# rule winnowmap:
#     input:
#         genome="results/Genomics/1_Assembly/2_Assemblers/{assembler}/assembly.fasta",
#         long_read=config["data_dir"] + "/DNA/raw/{long_read}.fastq.gz"
#     output:
#         sorted_bam="results/Genomics/1_Assembly/3_Evaluation/winnowmap/{assembler}/{long_read}.bam"
#     params:
#         threads=32
#     conda:
#         "envs/genomics.yaml"
#     script:
#         "scripts/Genomics/1_Assembly/3_Evaluation/MapLongReadsToAssembly.py"


# =========================
# EVALUATION
# =========================

rule quast:
    input:
        assembly="results/Genomics/1_Assembly/2_Assemblers/flye/raw/assembly.fasta/assembly.fasta"
    params:
        threads=32
    output:
        report_dir=directory("results/Genomics/1_Assembly/3_Evaluation/quast/flye/raw/")
    conda:
        "envs/genomics.yaml"
    script:
        "scripts/Genomics/1_Assembly/3_Evaluation/AssemblyQualityCheck.py"


rule multiqc:
    input:
        input_dir="results/Genomics/1_Assembly/"
    output:
        out_dir=directory("results/Genomics/1_Assembly/3_Evaluation/multiqc/")
    conda:
        "envs/genomics.yaml"
    shell:
        "multiqc {input.input_dir} -o {output.out_dir}"


rule plot_coverage_cont:
    input:
        nano="results/Genomics/1_Assembly/3_Evaluation/winnowmap/flye/raw/nanopore.bam"
    output:
        out="results/Genomics/1_Assembly/3_Evaluation/deeptools/flye_raw.png",
        outraw="results/Genomics/1_Assembly/3_Evaluation/deeptools/flye_raw/outRawCounts.txt"
    params:
        threads=32
    conda:
        "envs/genomics.yaml"
    script:
        "scripts/Genomics/1_Assembly/3_Evaluation/PlotCoverage.py"
