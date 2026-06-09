//Kamila Fazilatunisa_120410230109_Lab10TS

//1. Masukan data moneter.dta kedalam stata dan buat variabel yang menunjukan waktu observasi dari tahun 2000 pada kuartal 1! 
cd "C:\Kamila Fazilatunisa_120410230109_TS"
global data "C:\Kamila Fazilatunisa_120410230109_TS\Data"
global log "C:\Kamila Fazilatunisa_120410230109_TS\Logfile"
global output "C:\Kamila Fazilatunisa_120410230109_TS\Output"

log using "$log/LatihanLab10TS"

use "$data/moneter.dta"
gen time = tq(2000q1)+_n-1
format %tq time
tsset time, q

//2. Cek stationeritas pada ketiga variabel tersebut!
dfuller rrp //tidak stasioner di tingkat level
dfuller cpi //tidak stasioner di tingkat level
dfuller outputgap //sudah stasioner di tingkat level
//variabel rrp dan cpi belom stasioner tingkat level sedangkan outputgap sudah stasioner di tingkat level

dfuller d.rrp
dfuller d.cpi
//variabel rrp dan cpi sudah stasioner di turunan pertama dengan tingkat signifikansi 5%

//3. Identifikasi lag optimal yang bisa digunakan pada masing-masing variabel dan tanpa menggunakan maxlags cukup dengan AIC!
ssc install ardl
ardl cpi rrp outputgap, aic
matrix list e(lags)
//lag optimum yang dapat digunakan untuk semua variabel adalah (2 2 2)

//4. Buatlah model regresi terkait pengaruh kebijakan moneter dengan variabel Output Gap dan Reserve Repo Rate terhadap inflasi (CPI). Kemudian ujilah apakah terdapat misspesifikasi dalam model regresi tersebut (Uji Ramsey Reset Test)?
ardl cpi rrp outputgap, lags(2 2 2) ec 
estat ovtest
// Nilai Prob > F > a => 0.2525 > 0.05 => H0 tidak dapat ditolak, tidak ada mispesifikasi dalam model regresi atau model sudah sesuai dengan tingkat signifikansi 5%

//5. Dengan persamaan di nomor 4, apakah ada hubungan kointegrasi dalam model?
ardl cpi rrp outputgap, lags(2 2 2) ec
estat btest
//kesimpulan : F stat > i(1)L_05 (upper bound), 7.207 > 4.05 => H0 ditolak => terdapat kointegrasi atau hubungan jangka panjang dalam model dengan tingkat signifikansi 5%

//6. Lakukan pengujian stabilitas pada model yang telah dibangun untuk melihat apakah model sudah stabil?
ssc install cusum9
*cukup diinstall sekali

cusum9 l(1/2).cpi l(1/2).rrp l(1/2).outputgap
//model sudah stabil karena garis biru tidak keluar dari batas atas dan batas bawah

//7. Simpan output dengan outreg dalam bentuk .doc dan lakukan estimasi model untuk melihat hubungan jangka pendek, jangka panjang dan kecepatan perubahan di equilibrium di jangka pendek
ardl cpi rrp outputgap, lags(2 2 2) ec
ssc install outreg2
outreg2 using hasil_ardl.doc, word

//ECT(cpi L1) = -0.229 -> signifikan dan negatif -> sudah sesuai syarat ECM, artinya terdapat hubungan jangka panjang yang valid meskipun secara individual terdapat variabel yang belum signifikan.
//Interpretasi ECT = Model akan menuju keseimbangan dengan kecepatan sekitar 23% (0.229 x 100%) setiap kuartal, proses konvergensi atau penyesuaian perlu ke tingkat keseimbangan (equilibrium) memakan waktu sekitar (1/0.23) 4.34 kuartal / 390 hari untuk mencapai penyesuaian 100%
di 1/0.229

//8. Lakukan pengujian asumsi klasik pada model yang dibangun!

//Uji Multikolinearitas (Uji (VIF) variance inflation factor) //
ardl cpi rrp outputgap, lags(2 2 2) ec
estat vif
*notes : batas kriteria 5 = kalau R-Squared < 80%, 10 kalau R-Squared > 80%
//Hasil : VIF < 5 = 2.87 < 5, artinya dalam model tidak ada multikolinearitas

//Uji Heteroskedastisitas (white test)//
estat imtest, white
//Prob chi2 > a = 0.1470 > 0.05 H0 tidak dapat ditolak, yang berarti tidak terdapat masalah heteroskedastisitas

//Autokorelasi (Beursch Godfrey)
estat bgodfrey
//Prob chi2 > a = 0.7434 > 0.05 H0 tidak dapat ditolak, yang berarti tidak terdapat masalah autokorelasi dalam model

//kalo n kurang dari 40 pake uji normalitas
save "$output/Kamila_latihanlab9TS"
