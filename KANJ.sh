BEGIN {
    FS = ","
    mode  = ARGV[2]
    count_p = 0
    total = 0
    count_r = 0
    count_b = 0
    delete ARGV[2]
}

{
    if (mode == "a" && NR > 1) {
    count_p ++
}



    if (mode == "b" && NR > 1) {
        gsub(/[^a-zA-Z0-9]/, "", $4)
        gerbong[$4] = 1
    }

    if (mode == "c" && NR > 1) {
        if ($2 > max) {
            max = $2
            nama = $1
        }
    }

    if (mode == "d" && NR > 1) {
        usia = $2
        total += usia
        count_r ++
  }
 
    if (mode == "e" && NR > 1) {
        if ( $3 == "Business") {
        count_b ++  

  }

 }

}

END {
    if (mode == "a") {
       print "Jumlah seluruh penumpang KANJ adalah " count_p " orang"
   }


    else if (mode == "b") {
        count_g = 0 
          for (g in gerbong) {
            count_g ++
        }
        print "Jumlah gerbong penumpang KANJ adalah", count_g
    }

    else if (mode == "c") {
        print nama " adalah penumpang kereta tertua dengan usia " max " tahun"
    }
    
    else if (mode == "d") {
        rata = int(total/count_r + 0.5)
        print "Rata-rata usia penumpang KANJ adalah " rata " tahun"
}
    else if (mode == "e") {
        print "Jumlah penumpang business class " count_b " orang"
 }
    else {
      print "Soal tidak dikenali. Gunakan a, b, c, d, atau e."  
      
  }
}



