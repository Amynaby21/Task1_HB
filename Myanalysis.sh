#Counting in DNA
#!/usr/bin/bash
wget https://raw.githubusercontent.com/HackBio-Internship/wale-home-tasks/main/DNA.fa
tail -n +2 DNA.fa | tr -d '\n' | wc -c
grep -Eo 'A|T|G|C' DNA.fa | sort | uniq -c | awk '{print $2": "$1}'

#Conda software setup
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
bash Miniconda3-py39_4.12.0-Linux-x86_64.sh
#Installation of the chosen software
conda install \
fastqc \
fastp \
bwa
#Dataset download
#I combine my files in a folder called raw_reads that I upload on my terminal. The terminal consider the folder as a directory. To implement my softwares I will move to my directory.
cd raw_reads

#Implementing fastqc software
#Create a directory for the outputs 
mkdir Myoutput
fastqc raw_reads/*.fastq.gz -o Myoutput

#Implementing fastp software
#Create a directory for the outputs
mkdir fastp
SAMPLES=(
  "ACBarrie"
  "Alsen"
  "Baxter"
)

for SAMPLE in "${SAMPLES[@]}"; do

  fastp \
    -i "$PWD/${SAMPLE}_R1.fastq.gz" \
    -I "$PWD/${SAMPLE}_R2.fastq.gz" \
    -o "fastp/${SAMPLE}_R1.fastq.gz" \
    -O "fastp/${SAMPLE}_R2.fastq.gz" \
    --html "fastp/${SAMPLE}_fastp.html" 
done

#Implementing bwa software
#Downloadinf the reference file for my pairs and build the reference index
wget https://github.com/josoga2/yt-dataset/raw/main/dataset/references/reference.fasta
bwa index reference.fasta

#Create a directory for the outputs
mkdir repair
SAMPLES=(
  "ACBarrie"
  "Alsen"
  "Baxter"
)

for SAMPLE in "${SAMPLES[@]}"; do
        repair.sh in1=fastp/${SAMPLES}_R1.fastq.gz in2=fastp/${SAMPLE}_R2.fastq.gz out1=repair/${SAMPLE}_R1_rp_fastq.gz out2=repair/${SAMPLE}_R2_rp_fastq.gz outsingle=re>
        bwa mem -t 1 \
        raw_reads/reference.fasta \
        repair/${SAMPLE}_R1_rp_fastq.gz repair/${SAMPLE}_R2_rp_fastq.gz > ${SAMPLE}.sam 
done
