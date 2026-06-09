//Kamila Fazilatunisa_120410230109_Latihanlb8

*1. Buka logfile dengan nama "latihanlab8" lalu masukan dataset lutkepohl2.dta untuk praktikum kali ini! 
cd "C:\Kamila Fazilatunisa_120410230109_TS"
global data "C:\Kamila Fazilatunisa_120410230109_TS\Data"
global log "C:\Kamila Fazilatunisa_120410230109_TS\Logfile"
global output "C:\Kamila Fazilatunisa_120410230109_TS\Output"

log using "$log/LatihanLab8TS"

use "$data\lutkepohl2.dta"
des

*2. Atur variabel dan set waktu kuartalan dari tahun 1960 kuartal 1!
tsset qtr, q

*3. Tampilkan grafik untuk visualisasi awal data pada variabel investment, income, dan consump secara bersamaan!
tsline inv inc consump
//terlihat bahwa data masih terlihat jarak nilai variabel yang jauh dan besar, di mana variabel investment dalam rentang 200-800, sedangkan variabel income dan consump berada di rentang angka 500-2500, maka harus dibentuk kebentuk logaritma

tsline ln_inv ln_inc ln_consump
//setelah diubah ke bentuk logaritma, semua variabel memilki satuan dan jarak yang kecil serta tidak terlalu jauh yakni 5-8

*4. Lakukan pengecekan stationeritas menggunakan Grafik dan ADF Test!
tsline ln_inv ln_inc ln_consump
//terdapat tren sehingga kemungkinan data tidak stasioner

dfuller ln_inv //belum stasioner p value > a
dfuller ln_inc //belum stasioner p value > a
dfuller ln_consump //belum stasioner p value > a
//data belum stasioner di tingkat level/harus diturunkan di turunan pertama di posttest dituls uji hipotesis uji kriteria kesimpulan

*turunan pertama*
dfuller dln_inv //sudah stasioner p value < a
dfuller dln_inc //sudah stasioner p value < a
dfuller dln_consump //sudah stasioner p value < a
//sudah stasioner di turunan pertama di posttest dituls uji hipotesis uji kriteria kesimpulan

*5. Carilah lag optimal untuk mode VAR diantara ketiga variabel tersebut dengan cara preestimation dan post estimation (gunakan lag terkecil dan simple model)! 

*pre estimation
varsoc dln_inc dln_inc dln_consump
*post estimation
var ln_inv dln_inc dln_consump
var ln_inv dln_inc dln_consump, lags(1/5)
varsoc

//lag optimal yang dapat digunakan adalah lag 2 karena memiliki nilai FPE dan AIC terkecil

*6. Lakukan regresi var pada variabel Logaritma Europe investment, income, dan consump. Lalu, tulislan persamaan matriks dan linear! 
var ln_inv dln_inc dln_consump, lags(1/2)

*7. Lihatlah apakah ada kausalitas yang terjadi di antara variabel tersebut! 
vargranger
/*
Ho: tidak terdapat hubungan kausalitas antar variabel
Ha: terdapat hubungan kausalitas (1/2 arah) antar variabel 
Kriteria:
p-value < α→ Ho ditolak 
p-value > α→ Ho tidak dapat ditolak 

Hasil:
Variabel dln_inc terhadap dln_inv tidak terdapat kausalitas (0.757 > 5%)
Variabel dln_consump terhadap dln_inv tidak terdapat kausalitas (0.378 > 5%)
Variabel dln_inv  terhadap dln_inc terdapat kausalitas (0.044 < 5%)
Variabel dln_consump terhadap dln_inc tidak terdapat kausalitas (0.078 > 5%)
Variabel dln_inv terhadap dln_consump tidak terdapat kausalitas (0.120 > 5%)
Variabel dln_inc terhadap dln_consump terdapat kausalitas (0.000 < 5%)

Kesimpulan: dengan tingkat signifikansi 5%, dapat disimpulkan bahwa terdapat hubungan 1 arah antara variabel investment terhadap income dan variabel income terhadap consump 
*/

*8. Lakukan uji stabilitas pada model tersebut!
varstable, graph
//kesimpulan : eigenvalue telah berada pada kondisi -1<e<1, maka model sudah dalam keadaan stabil.

*9. Lakukan uji kointegrasi dengan grafik dan uji Johansen, apakah terdapat kointegrasi pada model?
tsline ln_consump ln_inc ln_inv
//apabila dilihat dari grafik, ketiga variabel tampak bergerak dengan tren yang hampir sama, meskipun terdapat fluktuasi jangka pendek. dengan demikian, secara visual terindikasi adanya kointegrasi atau hubungan jangka panjang di antara ketiga variabel

*UJI JOHANSEN*
vecrank ln_consump ln_inc ln_inv
/*
Ho : r=0 (tidak terdapat kointegrasi pada variabel)
Ha : r≠0 (terdapat kointegrasi pada variabel)

Kriteria:
Trace stat < critical value -> Ho tidak dapat ditolak
Trace stat > critical value -> Ho ditolak

Hasil:
rank(0): 32.6777 > 29,68 atau trace stat > critical value
maka Ho ditolak
rank(1): 10.8534 < 15,41 atau trace stat < critical value
maka Ho tidak dapat ditolak
rank (2): 3.4594 < 3,76 atau trace stat < critical value
maka Ho tidak dapat ditolak

Kesimpulan :
Jadi, terdapat hubungan jangka panjang atau kointegrasi
antara variabel income, consumption, dan investment 
sebanyak 1 kejadian.
*/

*10. Tampilkan grafik IRF untuk 5 periode mendatang dari persamaan VAR diatas, lalu gambarlah grafik IRF antara Variabel Logaritma  lihat bagaimana pengaruhnya pada 5 periode mendatang!
var dln_inv dln_inc dln_consump, lags(1/2)
irf create irflatihan8, step(5)set(irflatihanlab8ts)
irf graph irf
irf ograph (irflatihan8 dln_inc dln_consump irf) //dln_inc + impulse, dln_consump = response 

irf table irf
irf table irf, irf(irflatihan8)impulse(dln_inc)response(dln_consump)
//interpretasi : apabila terdapat guncangan sebesar 1 standar deviasi pada pertumbuhan logaritma income, menyebabkan respon positif awal pada pertumbuhan logaritma konsumsi pada periode ke-1, dan ke-2 (dengan puncak perumbuhan positif di periode ke-2 sebesar 0.24 standar deviasi), kemudian mengalami pertumbuhan negatif pada periode ke-3 sebesar -0.09 standar deviasi, dan di periode ke-5 dan ke-6 mengalami pertumbuhan yang positif kembali.

//irf impulse respons
//kalo mau lihat satu satu 

*11. Tampilkan grafik FEVD dan gambarlah grafik FEVD antara Variabel Logaritma Income dan Logaritma Investment! Setelahnya, lihat bagaimana pengaruh dari Variabel Logaritma Income terhadap variabel Logaritma Investment pada 3 periode mendatang
irf graph fevd
irf ograph (irflatihan8 dln_inc dln_inv fevd) //dln_inc = impulse, dln_inv = response

irf table fevd
irf table fevd, irf(irflatihan8)impulse(dln_inc)response(dln_inv)
//intepretasi : pada 3 periode mendatang jika tejadi shock pada vaiabel logaritma income maka akan berpengaruh 3.34% tehadap variabel logaritma investment atau dengan kata lain shock pada variabel logaritma income hanya menjelaskan variasi atau perubahan variabel dari investment sebesar 3.34% dan sisanya 96,66% dijelaskan oleh variabel invest itu sendiri

*12. Lakukan forecasting untuk 3 variabel tersebut selama 5 periode selanjutnya serta interpretasikan hasilnya!
fcast compute fc_,step(5)
br
fcast graph fc_dln_inv fc_dln_inc fc_dln_consump
fcast graph fc_dln_inc
fcast graph fc_dln_inv
fcast graph fc_dln_consump
 
save "$output/latihanlab8"

