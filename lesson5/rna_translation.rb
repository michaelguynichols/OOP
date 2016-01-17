TRANSLATION = { "Methionine" => ["AUG"], "Phenylalanine" => ["UUU", "UUC"],
                "Leucine" => ["UUA", "UUG"], "Serine" => ["UCU", "UCC", "UCA", "UCG"],
                "Tyrosine" => ["UAU", "UAC"], "Cysteine" => ["UGU", "UGC"],
                "Tryptophan" => ["UGG"], "STOP" => ["UAA", "UAG", "UGA"] }

class InvalidCodonError < StandardError

end

class Translation
  def self.split_into_codons(rna)
    codons = []
    i = 0
    start_slice_index = 0
    while i < rna.size
      if i != 0 && (i + 1) % 3 == 0
        codon = rna.slice(start_slice_index..i)
        break if terminating_codon?(codon)
        if !codons.include?(codon)
          codons << codon
        end
        start_slice_index = i + 1
      end
      i += 1
    end
    codons
  end

  def self.valid_rna?(rna)
    valid_codons = TRANSLATION.values.flatten
    split_into_codons(rna).each do |codon|
      if !valid_codons.include?(codon)
        raise InvalidCodonError
      end
    end
    true
  end

  def self.terminating_codon?(codon)
    TRANSLATION["STOP"].include?(codon)
  end

  def self.of_rna(rna)
    codons = split_into_codons(rna)
    valid_rna?(rna)
    protein = []
    codons.each do |codon|
      protein << of_codon(codon)
    end
    protein
  end

  def self.of_codon(codon)
    TRANSLATION.each do |key, codons|
      if codons.include?(codon)
        return key
      end
    end
  end
end
